local o = require 'ObjectModel'
local pprint = require 'cc.pretty'.pretty_print

local chr = string.char

local REST = o.class()
REST.type = 'REST'

function REST:constructor()
    self.debugState = false

    self.headers = {}
    self.baseURL = nil
    self.unsmartQuotes = true
    self.jsonMode = true
end

function REST:setBaseURL(url)
    self.baseURL = url
end

function REST:setHeaders(headers)
    for k,v in pairs(headers) do
        self.headers[k] = v
    end
end

function REST:get(url, headers)
    if headers then
        self:setHeaders(headers)
    end

    -- pprint(self.baseURL)
    -- pprint(url)
    -- pprint(self.headers)

    local res, error, errRes = http.get(self.baseURL .. url, self.headers, true)

    if not res then
        print('REST GET failed: ' .. error)
        pprint(errRes.readAll())
        errRes.close()
    end

    local body = res.readAll()
    res.close()

    -- f you, *unsmarts your quotes*
    if self.unsmartQuotes then
        body = string.gsub(body, '\xe2\x80[\x98\x99]', "'")
        body = string.gsub(body, '\xe2\x80[\x9c\x9d]', self.jsonMode and '\\"' or '"')
    end

    if self.jsonMode then
        return textutils.unserializeJSON(body)
    end

    return body
end

return REST