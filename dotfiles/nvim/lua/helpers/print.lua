local M = {}

M.print_table = function(t)
    for key, value in pairs(t) do
        if type(value) == "table" then
            print(key .. ":")
            M.print_table(value) -- Recursive call to print nested tables
        else
            print(key .. ": " .. tostring(value))
        end
    end
end

return M
