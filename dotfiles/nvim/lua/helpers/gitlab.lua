local ghost_text = require("gitlab.ghost_text")


---@class GitlabHelpers
---@field ghost_text GhostText
local M = {}

---@class GhostText
---@field insert_word function
---@field insert_line function
M.ghost_text = {}

---@class TextCache
---@field initialized boolean
---@field value string
---@field decorator function
---@field first_word function
---@field first_line function
---@field insert_text function
local TextCache = {
    cache = nil,
    initialized = false,
}

--- Return a list of words from a given string.
--- The words are split like vim's "w" operator. Whitespace and newlines are
--- retained and are interpereted as words.
---@param text string
---@return table words
local function split_words(text)
    local tokens = {}
    for chunk, space in text:gmatch("([^%s]+)(%s*)") do
        local subchunks = {}
        local current_word = ""
        for i = 1, #chunk do
            local c = chunk:sub(i, i)
            if c:match("[%w_]") then
                current_word = current_word .. c
            else
                if #current_word > 0 then
                    table.insert(subchunks, current_word)
                    current_word = ""
                end
                table.insert(subchunks, c)
            end
        end
        if #current_word > 0 then
            table.insert(subchunks, current_word)
        end
        if #subchunks > 0 then
            subchunks[#subchunks] = subchunks[#subchunks] .. space
        else
            table.insert(subchunks, space)
        end
        for _, sc in ipairs(subchunks) do
            table.insert(tokens, sc)
        end
    end
    return tokens
end

--- Insert text and move cursor to the end of the inserted text.
---@param text string The text to be inserted
local function insert_text(text)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = ghost_text.vim.split(text, '\n')
    ghost_text.vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, lines)
    local new_row = row + #lines - 1
    local new_col = #lines > 1 and #lines[#lines] or (col + #lines[1])
    ghost_text.vim.api.nvim_win_set_cursor(0, { new_row, new_col })
    if ghost_text.is_streaming then
        ghost_text.cancel_streaming()
    end
end

M.ghost_text.insert_word = function()
    local first_word = TextCache.first_word()
    if not first_word then
        return
    end
    TextCache.cache = nil
    insert_text(first_word)
end

M.ghost_text.insert_line = function()
    local first_line = TextCache.first_line()
    if not first_line then
        return
    end
    insert_text(first_line)
end

--- Decorator to cache first argument of `func` in the local variable
--- `last_suggestion`
---@param func function(suggestion: table): nil
---@return function(suggestion: table): nil
TextCache.decorator = function(func)
    return function(suggestion, ...)
        TextCache.cache = suggestion
        func(suggestion, ...)
    end
end

--- Return the first word from the cache.
---@return string first_word
TextCache.first_word = function()
    if not TextCache.cache then
        return ''
    end
    local text_to_insert = TextCache.cache[1].insertText
    return split_words(text_to_insert)[1]
end

--- Return the first line of the cache.
---@return string first_line
TextCache.first_line = function()
    if not TextCache.cache then
        return ''
    end
    local lines = vim.split(TextCache.cache[1].insertText, '\n')
    return lines[1] or ''
end


-- TODO: can be done better
if not TextCache.initialized then
    ghost_text.display_suggestion = TextCache.decorator(ghost_text.display_suggestion)
end

return M
