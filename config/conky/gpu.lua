local data = {
    temp = 0,
    util = 0,
    memused = 0,
    memtotal = 0,
    memutil = 0,
    power = 0,
    fan = 0
}
local last_read = 0

local function update_data()
    local now = os.time()
    if now == last_read then
        return
    end

    local f = io.open("/dev/shm/cybercore_gpu_conky", "r")
    if not f then return end
    for line in f:lines() do
        local k, v = line:match("(%w+)%s+(%d+)")
        if k and v then
            data[k] = tonumber(v) or 0
        end
    end
    f:close()
    last_read = now
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
