local ghost_text = require("gitlab.ghost_text")

---@class GitlabHelpers
---@field ghost_text GhostText
local M = {}

---@class GhostText
---@field insert_word function(): nil
---@field insert_line function(): nil
M.ghost_text = {}

---@class TextCache
---@field initialized boolean
---@field value string
---@field decorator function(function): function
---@field first_word function(): string
---@field first_line function(): string
---@field insert_text function(): nil
local TextCache = {
    initialized = false,
    value = "",
}

--- Return a list of words from a given string.
--- The words are split like vim's "w" operator. Whitespace and newlines are
--- retained and are interpereted as words.
---@param text string
---@return string[] words
local function split_words(text)
    local words = {}
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
            table.insert(words, sc)
        end
    end
    return words
end

--- Insert text and move cursor to the end of the inserted text.
---@param text string The text to be inserted
local function insert_text(text)
    local old_row, old_col = unpack(vim.api.nvim_win_get_cursor(0))

    local lines = ghost_text.vim.split(text, '\n')
    ghost_text.vim.api.nvim_buf_set_text(0, old_row - 1, old_col, old_row - 1, old_col, lines)

    local new_row = old_row + #lines - 1
    local new_col = #lines > 1 and #lines[#lines] or (old_col + #lines[1])
    ghost_text.vim.api.nvim_win_set_cursor(0, { new_row, new_col })

    if ghost_text.is_streaming then
        ghost_text.cancel_streaming()
    end
end

--- Insert a single word from the cache.
---@return nil
M.ghost_text.insert_word = function()
    insert_text(TextCache.first_word())
    TextCache.value = ""
end

--- Insert a single line from the cache.
---@return nil
M.ghost_text.insert_line = function()
    insert_text(TextCache.first_line())
    TextCache.value = ""
end

--- Decorator to cache first argument of `func` in the local variable
--- `last_suggestion`
---@param func function(suggestion: table): nil
---@return function(suggestion: table): nil
TextCache.decorator = function(func)
    return function(suggestion, ...)
        TextCache.value = suggestion[1].insertText
        func(suggestion, ...)
    end
end

--- Return the first word from the cache.
---@return string first_word
TextCache.first_word = function()
    return split_words(TextCache.value)[1] or ""
end

--- Return the first line of the cache.
---@return string first_line
TextCache.first_line = function()
    return vim.split(TextCache.value, '\n')[1] or ""
end


-- TODO: can be done better
if not TextCache.initialized then
    ghost_text.display_suggestion = TextCache.decorator(ghost_text.display_suggestion)
end

return M
