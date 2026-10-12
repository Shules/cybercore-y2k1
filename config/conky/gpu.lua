local data = {
    temp = 0,
    util = 0,
    memused = 0,
    memtotal = 0,
    memutil = 0,
    power = 0,
    fan = 0
}
local last_attempt = 0
local last_success = 0
local STALE_TIMEOUT = 5

local function update_data()
    local now = os.time()
    -- Only attempt to read once per second
    if now == last_attempt then
        return
    end
    last_attempt = now

    local f = io.open("/dev/shm/cybercore_gpu_conky", "r")
    if not f then
        -- If file is missing for longer than timeout, reset values to 0
        if now - last_success > STALE_TIMEOUT then
            for k in pairs(data) do
                data[k] = 0
            end
        end
        return
    end

    local found = false
    for line in f:lines() do
        local k, v = line:match("(%w+)%s+(%d+)")
        if k and v then
            data[k] = tonumber(v) or 0
            found = true
        end
    end
    f:close()

    if found then
        last_success = now
    elseif now - last_success > STALE_TIMEOUT then
        for k in pairs(data) do
            data[k] = 0
        end
    end
end

function conky_gpu_val(key)
    update_data()
    return tostring(data[key] or 0)
end

function conky_gpu_util()
    update_data()
    return data.util or 0
end

function conky_gpu_memutil()
    update_data()
    return data.memutil or 0
end
