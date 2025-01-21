# notes
Notion client in Minecraft

# Example
```lua
local notion = require 'notes'.provider.notion()

-- Notion Page/Block ID to render
local page_id = 'abf2fb8b-9561-4f77-8e4d-8bad7065bb24'

-- Authorize with token from an internal integration with permission to read content
-- Then, add integration as a connection on the page of interest
notion:authorize('ntn_abc123')

local termSize = {term.getSize()}
local win = window.create(term.current(), 1, 1, termSize[1], termSize[2], true)

term.redirect(win)

-- Render page/block and update every 10 seconds
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
