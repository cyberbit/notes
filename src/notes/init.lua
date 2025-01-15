-- Notes by cyberbit
-- MIT License
-- Version 0.0.1

local _Notes = {
    _VERSION = '0.0.1',
    provider = require 'notes.lib.provider',
}

local args = {...}

if #args < 1 or type(package.loaded['notes']) ~= 'table' then
    print('notes ' .. _Notes._VERSION)
    print(' * A command-line interface is not yet implemented, please use require()')
end

return _Notes