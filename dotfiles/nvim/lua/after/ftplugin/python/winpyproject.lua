local M = {}

M.setup = function()
    --Try to open the file `pyproject.toml` in the current directory.
    --If it exists, extract the line that holds `max_line_length`.
    --From this line, extract the value after the `=`.
    --Use this value as the vim.opt_local.textwidth value.
    local max_line_length = vim.fn.systemlist("cat pyproject.toml | grep max_line_length")
    if #max_line_length > 0 then
        local line = max_line_length[1]
        local value = line:match("= (%d+)")
        if value then
            vim.opt_local.textwidth = tonumber(value)
        end
    end
end

return M
