local M = {}

function M.get(filetype)
    local prompt = "For the filetype %s specifically, make sure that:\n%s"
    if not filetype then return "" end
    if not M[filetype] then return "" end
    return prompt:format(filetype, M[filetype])
end

M.python = [[
- use buildin types as much as possible (list is preferred over List)
- import types from `collections.abc` were possible
- do not use `Optional` but use ` | None` instead
- do not escape the double quotes when making docstrings.
]]

return M
