local fn = require("helpers.fn")

-- Function
local function render_mermaid_svg(output_path)
    local input = vim.fn.expand("%:p")

    local ext   = vim.fn.expand("%:e")

    if ext ~= "mmd" then
        vim.notify("Not an .mmd file", vim.log.levels.WARN)
        return
    end

    vim.cmd("write")

    if not output_path or #output_path == 0 then
        output_path = vim.fn.expand("%:p:r") .. ".svg"
    end

    vim.fn.jobstart({ "mmdc", "-i", input, "-o", output_path }, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            if not fn.is_empty(data) then
                vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
            end
        end,
        on_stderr = function(_, data)
            if not fn.is_empty(data) then
                vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
            end
        end,
        on_exit = function()
            vim.notify("Rendered: " .. output_path, vim.log.levels.INFO)
        end,
    })
end

-- Command
vim.api.nvim_create_user_command("MermaidRender", function(opts)
    render_mermaid_svg(opts.args)
end, {

    nargs = "?",
    complete = "file",
})

-- Mapping
vim.keymap.set("n", "<leader>mr", ":MermaidRender<CR>", {
    desc = "Render Mermaid diagram",
})
