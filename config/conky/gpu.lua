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
    -- Throttle file reads to at most once per second across all Conky calls
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

    -- Check freshness against the daemon's write timestamp
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
