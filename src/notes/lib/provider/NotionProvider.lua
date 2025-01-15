local o = require 'notes.vendor'.obj
local u = require 'notes.lib.util'
local p = require 'cc.pretty'

local BaseProvider = require 'notes.lib.provider.BaseProvider'

local NotionProvider = o.class(BaseProvider)
NotionProvider.type = 'NotionProvider'

function NotionProvider:constructor ()
    self:super('constructor')

    self.token = nil

    -- set up REST client
    self.client = require 'notes.vendor'.rest()
    self.client:setBaseURL('https://api.notion.com/v1')
    self.client:setHeaders({
        ['Notion-Version'] = '2022-06-28',
    })
end

function NotionProvider:authorize (secret)
    -- OAuth NYI, required for public integration
    -- internal integration uses secret as Bearer token

    self.token = secret

    self.client:setHeaders({
        ['Authorization'] = 'Bearer ' .. self.token,
    })
end

function NotionProvider:getPage (page_id)
    local pageData = self.client:get('/pages/' .. page_id)
end

function NotionProvider:getPageContent (page_id)
    return self:getBlockChildren(page_id)
end

function NotionProvider:getBlockChildren (block_id)
    return self.client:get('/blocks/' .. block_id .. '/children')
end

function NotionProvider:getBlockPlainText (block)
    local buffer = ''

    if block.type == 'bookmark' then
        buffer = buffer .. block.bookmark.url

    elseif block.type == 'bulleted_list_item' then
        buffer = buffer .. string.char(0x07) .. ' '

        for _,content in ipairs(block.bulleted_list_item.rich_text) do
            if content.plain_text then
                buffer = buffer .. content.plain_text
            end
        end
    
    elseif block.type == 'callout' then
        buffer = buffer .. '> '

        for _,content in ipairs(block.callout.rich_text) do
            if content.plain_text then
                buffer = buffer .. content.plain_text
            end
        end
    
    elseif block.type == 'child_page' then
        buffer = buffer .. string.char(0xBB) .. ' ' .. block.child_page.title

    elseif block.type == 'code' then
        buffer = buffer .. '```' .. block.code.language .. '\n'

        for _,content in ipairs(block.code.rich_text) do
            if content.plain_text then
                buffer = buffer .. content.plain_text
            end
        end

        buffer = buffer .. '\n```'
    
    elseif block.type == 'divider' then
        buffer = buffer .. string.rep('-', (term.getSize()))

    elseif block.type == 'heading_1' then
        buffer = buffer .. '# '

        for _,content in ipairs(block.heading_1.rich_text) do
            if content.plain_text then
                buffer = buffer .. content.plain_text
            end
        end
    
    elseif block.type == 'heading_2' then
        buffer = buffer .. '## '

        for _,content in ipairs(block.heading_2.rich_text) do
            if content.plain_text then
                buffer = buffer .. content.plain_text
            end
        end
    
    elseif block.type == 'heading_3' then
        buffer = buffer .. '### '

        for _,content in ipairs(block.heading_3.rich_text) do
            if content.plain_text then
                buffer = buffer .. content.plain_text
            end
        end
    
    elseif block.type == 'numbered_list_item' then
        -- u.pprint(block)
        buffer = buffer .. string.char(0x04) .. ' '

        for _,content in ipairs(block.numbered_list_item.rich_text) do
            if content.plain_text then
                buffer = buffer .. content.plain_text
            end
        end

    elseif block.type == 'paragraph' then
        for _,content in ipairs(block.paragraph.rich_text) do
            if content.plain_text then
                buffer = buffer .. content.plain_text
            end
        end
    
    elseif block.type == 'quote' then
        buffer = buffer .. '> '

        for _,content in ipairs(block.quote.rich_text) do
            if content.plain_text then
                buffer = buffer .. content.plain_text
            end
        end
    
    elseif block.type == 'to_do' then
        buffer = buffer .. '[' .. (block.to_do.checked and string.char(0xD7) or ' ') .. '] '

        for _,content in ipairs(block.to_do.rich_text) do
            if content.plain_text then
                buffer = buffer .. content.plain_text
            end
        end

    elseif block.type == 'toggle' then
        buffer = buffer .. string.char(0x10) .. ' '

        for _,content in ipairs(block.toggle.rich_text) do
            if content.plain_text then
                buffer = buffer .. content.plain_text
            end
        end

    else
        buffer = buffer .. '[block ' .. block.type .. ']'
    end

    return buffer
end

function NotionProvider:renderBlocksPlainText (blocks, indent)
    indent = indent or 0

    local text = ''

    for _,block in ipairs(blocks.results) do
        local plainText = self:getBlockPlainText(block)

        if plainText then
            text = text .. string.rep('  ', indent) .. plainText .. '\n'
        end

        if block.has_children then
            local children = self:getBlockChildren(block.id)
            text = text .. self:renderBlocksPlainText(children, indent + 1)
        end
    end

    return text
end

return NotionProvider