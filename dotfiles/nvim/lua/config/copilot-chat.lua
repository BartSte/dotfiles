local chat = require("CopilotChat")
local mapper = require("helpers.keymapper")

local opts = {
    model = "o3-mini",
    mappings = { submit_prompt = { normal = "<C-s>" } }
}
chat.setup(opts)

mapper.nnoremap("<leader>A", ":CopilotChatOpen<CR>")
mapper.nnoremap("<leader>ac", ":CopilotChatCommit<CR>")
mapper.nnoremap("<leader>ad", ":CopilotChatDocs<CR>")
mapper.nnoremap("<leader>ae", ":CopilotChatExplain<CR>")
mapper.nnoremap("<leader>af", ":CopilotChatFix<CR>")
mapper.nnoremap("<leader>ao", ":CopilotChatOptimize<CR>")
mapper.nnoremap("<leader>ar", ":CopilotChatReview<CR>")
mapper.nnoremap("<leader>at", ":CopilotChatTests<CR>")

mapper.vnoremap("<leader>ac", ":CopilotChatCommit<CR>")
mapper.vnoremap("<leader>ad", ":CopilotChatDocs<CR>")
mapper.vnoremap("<leader>ae", ":CopilotChatExplain<CR>")
mapper.vnoremap("<leader>af", ":CopilotChatFix<CR>")
mapper.vnoremap("<leader>ao", ":CopilotChatOptimize<CR>")
mapper.vnoremap("<leader>at", ":CopilotChatTests<CR>")
