require 'cairo'
require 'cairo_xlib'

local data = {
    temp = 0,
    util = 0,
    memused = 0,
    memtotal = 0,
    memutil = 0,
    power = 0,
    fan = 0,
    timestamp = 0
}
local is_stale = true
local last_attempt = 0
local STALE_TIMEOUT = 5

local function update_data()
    local now = os.time()
    if now == last_attempt then
        return
    end
    last_attempt = now

    local f = io.open("/dev/shm/cybercore_gpu_conky", "r")
    if not f then
        is_stale = true
        return
    end

    local parsed_ts = 0
    for line in f:lines() do
        local k, v = line:match("(%w+)%s+(%d+)")
        if k and v then
            local num = tonumber(v) or 0
            data[k] = num
            if k == "timestamp" then
                parsed_ts = num
            end
        end
    end
    f:close()

    if parsed_ts > 0 and (now - parsed_ts) <= STALE_TIMEOUT then
        is_stale = false
    else
        is_stale = true
    end
end

function conky_gpu_val(key)
    update_data()
    if is_stale then
        return "N/D"
    end
    return tostring(data[key] or "N/D")
end

function conky_gpu_status()
    update_data()
    if is_stale then
        return "OFFLINE"
    end
    return "ONLINE"
end

function conky_gpu_util()
    update_data()
    if is_stale then
        return 0
    end
    return data.util or 0
end

function conky_gpu_memutil()
    update_data()
    if is_stale then
        return 0
    end
    return data.memutil or 0
end

-- Decorative sequences use elapsed time, never random telemetry-like values.
-- /proc/uptime supplies a monotonic, subsecond clock without spawning a
-- process or adding a Lua dependency. Read once per frame, share across calls.
local clock_frame, clock_value
local function animation_time()
    local frame = conky_parse and conky_parse('${updates}') or nil
    if frame and frame == clock_frame then return clock_value end
    local f = io.open('/proc/uptime', 'r')
    local value
    if f then
        value = tonumber((f:read('*l') or ''):match('^[%d.]+'))
        f:close()
    end
    clock_frame = frame
    clock_value = value or os.time()
    return clock_value
end
local started_at = animation_time()
local function elapsed()
    return math.max(0, animation_time() - started_at)
end

local function sequence(duration, hold, offset)
    local phase = (elapsed() + (offset or 0)) % (duration + hold)
    if phase >= duration then return 100, true end
    return math.min(100, 1 + math.floor(99 * phase / (duration - 1))), false
end

local spinner_frames = {"[ - ]", "[ \\ ]", "[ | ]", "[ / ]"}
function conky_spinner(id_str)
    local id = tonumber(id_str) or 1
    return spinner_frames[(math.floor(elapsed() * 8) + id) % #spinner_frames + 1]
end

function conky_injection_bar()
    local pct, done = sequence(24, 7, 0)
    local filled = math.floor(pct / 5)
    return string.format("[%s%s] %3d%% %s", string.rep("|", filled),
        string.rep(".", 20 - filled), pct, done and "[OK]" or "")
end

function conky_sequence_status(id)
    local pct, done
    if id == "cache" then pct, done = sequence(15, 9, 7)
    else pct, done = sequence(19, 12, 3) end
    return done and "[OK]" or string.format("%3d%%", pct)
end


function conky_module_count()
    return string.format('%02d', math.floor(elapsed() / 2) % 24 + 1)
end
function conky_dots()
    return string.rep('.', math.floor(elapsed()) % 4)
end
function conky_injection_status()
    local pct, done = sequence(24, 7, 0)
    return done and '[OK]' or string.format('%d%%', pct)
end
function conky_next_cycle()
    local phase = elapsed() % 31
    return phase >= 24 and tostring(math.ceil(31 - phase)) .. 's' or 'pending'
end
function conky_queue_row(index)
    local row = tonumber(index) or 0
    local head = math.floor(elapsed() / 3)
    local id = (head + row) % 24 + 1
    local status = row < 5 and '[OK]' or row == 5 and 'loading' or 'queued'
    return string.format('%02d  module_%02d       %-9s', row + 1, id, status)
end
-- Read one coherent process table every two seconds. Repainting at 20 Hz
-- must not reshuffle names and percentages on each animation frame.
local process_snapshot = {}
local process_refreshed = -math.huge
function conky_process_value(row, field)
    local now = animation_time()
    if now - process_refreshed >= 2 then
        local snapshot = {}
        for i = 1, 5 do
            snapshot[i] = {}
            for _, key in ipairs({'name', 'cpu', 'mem'}) do
                local value = conky_parse('${top ' .. key .. ' ' .. i .. '}') or ''
                value = value:match('^%s*(.-)%s*$')
                snapshot[i][key] = value ~= '' and value or 'N/D'
            end
        end
        process_snapshot = snapshot
        process_refreshed = now
    end
    local entry = process_snapshot[tonumber(row)]
    return entry and entry[field] or 'N/D'
end

-- Decorative boot log: completed events stay visible while the next one runs.
-- A slower cycle and timestamps distinguish this from the injection pipeline.
local boot_events = {'Read configuration', 'Load resources', 'Mount workspace', 'Start services'}
local boot_times = {0, 4, 10, 16, 22}
function conky_runtime_row(index)
    local row = tonumber(index) or 1
    local t = math.floor(elapsed()) % 36
    if row == 5 then
        local ready = 0
        for i = 1, 4 do if t >= boot_times[i + 1] then ready = ready + 1 end end
        return string.format('SESSION %02d  /  %d OF 4 READY%s', math.floor(elapsed() / 36) + 1,
            ready, ready == 4 and '  [ONLINE]' or '')
    end
    if not boot_events[row] then return '' end
    if t < boot_times[row] then
        return string.format('[--:--] %-20s [WAIT]', boot_events[row])
    end
    local state = t >= boot_times[row + 1] and '[OK]' or '[...]'
    return string.format('[00:%02d] %-20s %s', boot_times[row], boot_events[row], state)
end

-- All three stages follow the same progress as the main injection bar.
local injection_stages = {'Resolve target', 'Stage payload', 'Commit changes'}
function conky_injection_stage(index)
    local row = tonumber(index) or 1
    if not injection_stages[row] then return '' end
    local pct, done = sequence(24, 7, 0)
    local active = math.min(3, math.floor((pct - 1) / 34) + 1)
    local state = done or row < active
    state = state and '[OK]' or row == active and '[RUN]' or '[WAIT]'
    return string.format('%02d > %-19s %s', row, injection_stages[row], state)
end

-- Cairo Graphical Circular Loading Ring (Active Memory Decryptor)
-- Clean standalone ring without violet tip, perfectly centered in Module 02
function conky_draw_ring()
    if conky_window == nil then return end
    -- Reuse Conky's per-frame surface where supported; older versions own
    -- the fallback surface and must explicitly destroy it.
    local borrowed = type(conky_surface) == 'function'
    local cs
    if borrowed then
        cs = conky_surface()
    else
        cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable,
            conky_window.visual, conky_window.width, conky_window.height)
    end
    if not cs then return '' end
    local cr = cairo_create(cs)

    -- Floating in Upper-Mid Center (xc=960, yc=230, radius=42)
    local xc = 950
    local yc = 250
    local radius = 42

    local now = animation_time()
    local pct = 0.72
    local angle = 2 * math.pi * pct

    -- 1. Outer radar ticks in Violet (#BD00FF)
    cairo_set_line_width(cr, 1.5)
    cairo_set_source_rgba(cr, 0.74, 0.0, 1.0, 0.6) -- #BD00FF
    for i = 0, 31 do
        local a = i * (2 * math.pi / 32)
        local r1 = radius + 6
        local r2 = radius + 11
        if i % 8 == 0 then r2 = radius + 15 end
        cairo_move_to(cr, xc + r1 * math.cos(a), yc + r1 * math.sin(a))
        cairo_line_to(cr, xc + r2 * math.cos(a), yc + r2 * math.sin(a))
    end
    cairo_stroke(cr)

    -- 2. Background track ring (dim Winamp green #004D14)
    cairo_set_line_width(cr, 5)
    cairo_set_source_rgba(cr, 0.0, 0.28, 0.08, 0.6)
    cairo_arc(cr, xc, yc, radius, 0, 2 * math.pi)
    cairo_stroke(cr)

    -- 3. Active progress arc (Winamp Neon Green #00FF44)
    cairo_set_line_width(cr, 5)
    cairo_set_source_rgba(cr, 0.0, 1.0, 0.27, 1.0)
    cairo_arc(cr, xc, yc, radius, now * 1.4, now * 1.4 + angle)
    cairo_stroke(cr)

    cairo_select_font_face(cr, 'Share Tech Mono', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
    cairo_set_font_size(cr, 14)
    cairo_set_source_rgba(cr, 0.0, 1.0, 0.27, 1.0)
    cairo_move_to(cr, xc - 30, yc + 5)
    cairo_show_text(cr, 'LOADING')
    -- Clean finish: NO violet tip dot
    cairo_destroy(cr)
    if not borrowed then cairo_surface_destroy(cs) end
    return ""
end
