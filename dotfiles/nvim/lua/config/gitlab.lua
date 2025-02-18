local commands = require("gitlab.commands")
local defaults = require("gitlab.config.defaults")
local ghost_text = require("gitlab.ghost_text")
local gitlab = require("gitlab")
local mapper = require("helpers.keymapper")

local last_suggestion = nil
local function decorate(func)
    return function(suggestion)
        last_suggestion = suggestion
        func(suggestion)
    end
end

--- Return a list of words.
--- White space and newlines are removed.
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

local get_first_word = function()
    if not last_suggestion then
        return ''
    end
    local text_to_insert = last_suggestion[1].insertText
    return split_words(text_to_insert)[1]
end

local get_first_line = function()
    if not last_suggestion then
        return ''
    end
    local lines = vim.split(last_suggestion[1].insertText, '\n')
    return lines[1] or ''
end

--- Insert text and move cursor to the end of the inserted text.
---@param text string The text to be inserted
local function insert_text(text)
    last_suggestion = nil
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

local function insert_line()
    local first_line = get_first_line()
    if not first_line then
        return
    end
    insert_text(first_line)
end

local function insert_word()
    local first_word = get_first_word()
    if not first_word then
        return
    end
    insert_text(first_word)
end

local default_filetypes = defaults.code_suggestions.auto_filetypes
local auto_filetypes    = { "lua", "markdown", "zsh", "sh", "toml", "yaml" }
vim.list_extend(auto_filetypes, default_filetypes)

gitlab.setup({
    code_suggestions = {
        auto_filetypes = auto_filetypes,
        ghost_text = {
            enabled = true,
            toggle_enabled = false,
            accept_suggestion = '<Right>',
            clear_suggestions = '<Left>',
            stream = true,
        },
    },
    resource_editing = {
        enabled = true,
    },
    statusline = {
        enabled = false,
    },
})
commands.create() -- Needed to reset the `FileType` autocommand.
ghost_text.display_suggestion = decorate(ghost_text.display_suggestion)

-- Insert first word of the ghost text.
mapper.inoremap("<C-Right>", insert_word)
mapper.inoremap("<S-Right>", insert_line)
