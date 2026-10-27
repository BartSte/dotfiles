-- Run with: nvim --headless -u NONE -i NONE -l dotfiles/tests/nvim/test_project_shada.lua
local source = debug.getinfo(1, "S").source:sub(2)
local root = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(source)))
package.path = root .. "/nvim/lua/?.lua;" .. package.path
local shada = require("helpers.project_shada")
local temporary = vim.fn.tempname()
vim.fn.mkdir(temporary, "p")

local function git(...)
    local result = vim.system({ "git", ... }, { text = true }):wait()
    assert(result.code == 0, result.stderr)
    return vim.trim(result.stdout)
end

local function verify()
    local clone = temporary .. "/original clone"
    local linked = temporary .. "/worktrees/feature branch"
    local detached = temporary .. "/worktrees/detached"
    git("init", "--quiet", "--initial-branch=main", clone)
    git("-C", clone, "-c", "user.name=ShaDa Test", "-c", "user.email=test@example.invalid",
        "commit", "--quiet", "--allow-empty", "-m", "initial")
    git("-C", clone, "worktree", "add", "--quiet", "-b", "feature", linked)
    git("-C", clone, "worktree", "add", "--quiet", "--detach", detached)
    local nested = linked .. "/nested directory"
    vim.fn.mkdir(nested, "p")
    local expected = vim.fs.joinpath(vim.fn.stdpath("state"), "shada", "original clone.shada")
    assert(shada.path(clone) == expected, "The clone's existing ShaDa filename changed")
    assert(shada.path(linked) == expected, "The linked worktree uses a separate ShaDa")
    assert(shada.path(nested) == expected, "A subdirectory uses a separate ShaDa")
    assert(shada.path(detached) == expected, "A detached worktree uses a separate ShaDa")

    local separate = temporary .. "/separate git clone"
    git("init", "--quiet", "--separate-git-dir=" .. temporary .. "/git storage", separate)
    git("-C", separate, "-c", "user.name=ShaDa Test", "-c", "user.email=test@example.invalid",
        "commit", "--quiet", "--allow-empty", "-m", "initial")
    local separate_linked = temporary .. "/separate linked"
    git("-C", separate, "worktree", "add", "--quiet", "-b", "feature", separate_linked)
    assert(shada.path(separate) == shada.path(separate_linked), "Separate Git storage did not share ShaDa")
    local outside = temporary .. "/not a repository"
    vim.fn.mkdir(outside, "p")
    assert(shada.path(outside) == vim.fs.joinpath(vim.fn.stdpath("state"), "shada", "not a repository.shada"),
        "The non-Git fallback changed")

    -- Exercise the installed plugin's MakeShada command and startup read.
    local plugin = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "nvim-project-marks")
    assert(vim.fn.isdirectory(plugin) == 1, "Install nvim-project-marks before this integration test")
    vim.opt.runtimepath:append(plugin)
    local directory = temporary .. "/state/shada"
    vim.fn.mkdir(directory, "p")
    local real_stdpath = vim.fn.stdpath
    vim.fn.stdpath = function(kind)
        if kind == "state" then return temporary .. "/state" end
        return real_stdpath(kind)
    end
    vim.cmd.cd(vim.fn.fnameescape(linked))
    dofile(root .. "/nvim/lua/config/projectmarks.lua")
    local target = require("projectmarks").opts.shadafile
    assert(target == directory .. "/original clone.shada", "MakeShada target differs in the worktree")
    vim.cmd.MakeShada()
    assert(vim.fn.filereadable(target) == 1, "MakeShada did not create the shared file")
    vim.cmd.cd(vim.fn.fnameescape(clone))
    dofile(root .. "/nvim/lua/config/projectmarks.lua")
    assert(vim.o.shadafile == target, "The clone did not select the shared file")
    vim.cmd.cd(vim.fn.fnameescape(linked))
    dofile(root .. "/nvim/lua/config/projectmarks.lua")
    assert(vim.o.shadafile == target, "The worktree did not select the shared file")
    vim.fn.stdpath = real_stdpath
end

local ok, err = xpcall(verify, debug.traceback)
vim.o.shadafile = "NONE"
vim.cmd.cd(root)
vim.fn.delete(temporary, "rf")
assert(ok, err)
print("PASS: clone, linked and detached worktrees, nested paths, non-Git fallback, and MakeShada")
