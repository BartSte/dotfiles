local M = {}

local function log(msg, level)
    level = level or vim.log.levels.INFO
    vim.api.nvim_notify(msg, level, {})
end

local function file_tree_is_valid()
    local has_src = vim.fn.filereadable('src')
    local has_tests = vim.fn.filereadable('tests')
    return has_src == 1 and has_tests == 1
end

local function get_test_file(src_file)
    local test_file = vim.fn.substitute(src_file, 'src/[^/]*', 'tests', '')
    test_file = vim.fn.substitute(test_file, "/", "/test_", "g")
    return vim.fn.substitute(test_file, "//", "/", "g")
end

local function get_src_file(test_file)
    local src_file = vim.fn.substitute(test_file, 'tests[^/]*', 'src/*/', '')
    src_file = vim.fn.substitute(src_file, "/test_", "/", "g")
    return vim.fn.substitute(src_file, "//", "/", "g")
end

local function get_toggle_file()
    local rel_path = vim.fn.expand('%:p:~:.')
    local is_src = vim.fn.match(rel_path, 'src/') ~= -1
    local is_test = vim.fn.match(rel_path, 'tests/') ~= -1

    if is_src then
        return get_test_file(rel_path)
    elseif is_test then
        return get_src_file(rel_path)
    else
        log("Not in src or tests directory", vim.log.levels.ERROR)
        return rel_path
    end
end

--- Toggle between source and test file.
--- If the current file is in the `src` directory, the corresponding test file
--- is opened and vice versa.
--- If the current file is not in the `src` or `tests` directory, an error is
--- shown.
--- The following directory structure is assumed:
--- ```
--- .
--- ├── src
--- │   └── package_name
--- │       └── dir
--- │           └── file.py
--- └── tests
---     └── test_dir
---        └── test_file.py
M.toggle_test_file = function()
    if file_tree_is_valid() then
        log("No src and/or tests directory found", vim.log.levels.ERROR)
        return
    end

    local path = get_toggle_file()
    if vim.fn.filereadable(path) == 0 then
        log("File not found: " .. path, vim.log.levels.ERROR)
    else
        vim.cmd('edit ' .. path)
    end
end

return M
