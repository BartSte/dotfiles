local mapper = require("helpers.keymapper")

--- Configure environment variables for aider based on hostname
--- Sets API keys and model selection depending on current system
---@side effect Modifies vim.env with API keys and model selection
local function setup_env()
    local hostname = vim.fn.hostname()
    if hostname == "bart-asus" then
        vim.schedule(function() require("helpers.rbw").set_env("DEEPSEEK_API_KEY") end)
        vim.env["AIDER_MODEL"] = "deepseek/deepseek-reasoner"
    elseif hostname == "zbook" then
        vim.schedule(function() require("helpers.rbw").set_env("OPENAI_API_KEY") end)
        vim.env["AIDER_MODEL"] = "gpt-5-codex"
        vim.env["AIDER_WEAK_MODEL"] = "gpt-5-nano"
    end
end

setup_env()
require("prompts").setup({
    notify = true,
    loglevel = "INFO"
})

mapper.nnoremap("<leader>ad", ":AiDocstrings<CR>")
mapper.nnoremap("<leader>af", ":AiFix<CR>")
mapper.nnoremap("<leader>aq", ":AiAbort<CR>")
mapper.nnoremap("<leader>ar", ":AiRefactor<CR>")
mapper.nnoremap("<leader>at", ":AiTests<CR>")
mapper.nnoremap("<leader>au", ":AiUndo<CR>")
mapper.nnoremap("<leader>ay", ":AiTypehints<CR>")
mapper.nnoremap("<leader>ae", ":AiExplain<CR>")
mapper.nnoremap("<leader>aa", ":AiAsk<CR>")
mapper.nnoremap("<leader>ao", ":AiShowOutput<CR>")
mapper.nnoremap("<leader>ac", ":AiCommit<CR>")
mapper.vnoremap("<leader>ad", ":AiDocstrings<CR>")
mapper.vnoremap("<leader>af", ":AiFix<CR>")
mapper.vnoremap("<leader>ar", ":AiRefactor<CR>")
mapper.vnoremap("<leader>at", ":AiTests<CR>")
mapper.vnoremap("<leader>ay", ":AiTypehints<CR>")
mapper.vnoremap("<leader>ae", ":AiExplain<CR>")
mapper.vnoremap("<leader>aa", ":AiAsk<CR>")
