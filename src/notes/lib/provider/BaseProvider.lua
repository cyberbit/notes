local o = require 'notes.vendor'.obj
local u = require 'notes.lib.util'

local BaseProvider = o.class()
BaseProvider.type = 'BaseProvider'

function BaseProvider:constructor()
    assert(self.type ~= BaseProvider.type, 'BaseProvider cannot be instantiated')

    self.debugState = false
end

function BaseProvider:debug(debug)
    self.debugState = debug and true or false

    return self
end

function BaseProvider:dlog(msg)
    if self.debugState then u.log(msg) end
end

return BaseProvider