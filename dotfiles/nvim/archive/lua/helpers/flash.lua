local M = {}
local Flash = require("lua.helpers.flash")

---@param opts Flash.Format
local function format(opts)
    -- always show first and second label
    return {
        { opts.match.label1, "FlashMatch" },
        { opts.match.label2, "FlashLabel" },
    }
end

local opts_w = {
    search = { mode = "search", forward = true, wrap = false },
    label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
    pattern = [[\<]],
    action = function(match, state)
        state:hide()
        Flash.jump({
            search = { max_length = 0 },
            highlight = { matches = false },
            label = { format = format },
            matcher = function(win)
                -- limit matches to the current label
                return vim.tbl_filter(function(m)
                    return m.label == match.label and m.win == win
                end, state.results)
            end,
            labeler = function(matches)
                for _, m in ipairs(matches) do
                    m.label = m.label2 -- use the second label
                end
            end,
        })
    end,
    labeler = function(matches, state)
        local labels = state:labels()
        for m, match in ipairs(matches) do
            match.label1 = labels[math.floor((m - 1) / #labels) + 1]
            match.label2 = labels[(m - 1) % #labels + 1]
            match.label = match.label1
        end
    end,
}

local opts_b = {}
local opts_e = {}
local opts_ge = {}
local opts_B = {}
local opts_W = {}
local opts_E = {}
local opts_gE = {}

M.make_jump = function(opts)
    opts = opts or {}
    return function()
        require("lua.helpers.flash").jump(opts)
    end
end

M.jump_b = M.make_jump(opts_b)
M.jump_w = M.make_jump(opts_w)
M.jump_e = M.make_jump(opts_e)
M.jump_ge = M.make_jump(opts_ge)
M.jump_B = M.make_jump(opts_B)
M.jump_W = M.make_jump(opts_W)
M.jump_E = M.make_jump(opts_E)
M.jump_gE = M.make_jump(opts_gE)

return M
