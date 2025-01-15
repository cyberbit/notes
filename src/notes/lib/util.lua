-- TODO write my own pretty_print
local pretty = require 'cc.pretty' or { pretty_print = print }

local function tsleep(num)
    local sec = tonumber(os.clock() + num)
    while (os.clock() < sec) do end
end

local function log(msg)
    print('NOTES :: '..msg)
end

local function err(msg)
    error('NOTES :: '..msg)
end

local function pprint(dater)
    return pretty.pretty_print(dater)
end

local function constrainAppend (data, value, width)
    local removed = 0

    table.insert(data, value)

    while #data > width do
        table.remove(data, 1)
        removed = removed + 1
    end

    return removed
end

local function indexOf (tab, value)
    if type(value) == 'nil' then return -1 end
    
    for i,v in ipairs(tab) do
        if v == value then
            return i
        end
    end

    return -1
end

return {
    log = log,
    err = err,
    pprint = pprint,
    sleep = os.sleep or tsleep,
    constrainAppend = constrainAppend,
    indexOf = indexOf
}