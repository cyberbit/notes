-- Notes Vendor Loader by cyberbit
-- MIT License
-- Version 0.0.1
-- Submodules are copyright of their respective authors. For licensing, see https://github.com/cyberbit/notes/blob/main/LICENSE

if package.path:find('notes/vendor') == nil then package.path = package.path .. ';notes/vendor/?;notes/vendor/?.lua;notes/vendor/?/init.lua' end

local libs = {
    obj = 'ObjectModel',
    rest = 'rest',
}

return setmetatable({}, {
    __index = function(_, key)
        if libs[key] then
            return (require(libs[key]))
        end
    end,
})