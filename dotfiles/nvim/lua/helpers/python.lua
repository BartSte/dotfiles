local M = {}

local function log(msg)
    vim.api.nvim_notify(msg, vim.log.levels.ERROR, { title = 'Switch test file' })
end

local function file_tree_is_valid()
    local has_src = vim.fn.isdirectory('src') == 1
    local has_tests = vim.fn.isdirectory('tests') == 1
    return has_src and has_tests
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
    local rel_path = vim.fn.expand('%:p:~:.')
    local is_src = vim.fn.match(rel_path, 'src/') == 0
    local is_test = vim.fn.match(rel_path, 'tests/') == 0

    if not file_tree_is_valid() then
        log("Invalid file tree")
    elseif not is_src and not is_test then
        log("Not in src or tests directory")
    elseif is_src then
        rel_path = get_test_file(rel_path)
    elseif is_test then
        rel_path = get_src_file(rel_path)
    end

    vim.cmd('edit ' .. rel_path)
end

M.open_test_file = function()
    local is_test = vim.fn.match(vim.fn.expand('%:p:~:.'), 'tests/') == 0
    if is_test then
        log("Already in test file")
    elseif not file_tree_is_valid() then
        log("Invalid file tree")
    else
        local test_file = get_test_file(vim.fn.expand('%:p:~:.'))
        vim.cmd('edit ' .. test_file)
    end
end

M.open_src_file = function()
    local is_src = vim.fn.match(vim.fn.expand('%:p:~:.'), 'src/') == 0
    if is_src then
        log("Already in src file")
    elseif not file_tree_is_valid() then
        log("Invalid file tree")
    else
        local src_file = get_src_file(vim.fn.expand('%:p:~:.'))
        vim.cmd('edit ' .. src_file)
    end
end

return M
