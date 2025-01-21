# notes
Notion client in Minecraft

# Example
```lua
local notion = require 'notes'.provider.notion()
local u = require 'notes.lib.util'

local page_id = 'abf2fb8b-9561-4f77-8e4d-8bad7065bb24'

notion:authorize('ntn_abc123')

local termSize = {term.getSize()}
local win = window.create(term.current(), 1, 1, termSize[1], termSize[2], true)

term.redirect(win)

while true do
    local pageContent = notion:getPageContent(page_id)
    
    win.setVisible(false)
    term.clear()
    term.setCursorPos(1, 1)

    print(notion:renderBlocksPlainText(pageContent))

    win.setVisible(true)
    
    sleep(10)
end
```