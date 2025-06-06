local M = {}

--- Convert a hexadecimal color string to normalized RGB values.
---@param h string A hex color string (e.g. "#RRGGBB" or "RRGGBB").
---@return number r Normalized red channel (0–1).
---@return number g Normalized green channel (0–1).
---@return number b Normalized blue channel (0–1).
local function hex_to_rgb(h)
    h = h:gsub("#", "")
    local r = tonumber(h:sub(1, 2), 16) / 255
    local g = tonumber(h:sub(3, 4), 16) / 255
    local b = tonumber(h:sub(5, 6), 16) / 255
    return r, g, b
end


--- Convert normalized RGB values to a hexadecimal color string.
---@param r number Normalized red channel (0–1).
---@param g number Normalized green channel (0–1).
---@param b number Normalized blue channel (0–1).
---@return string Hexadecimal color string (e.g. "#RRGGBB").
local function rgb_to_hex(r, g, b)
    --- Clamp a number to the [0–1] range.
    ---@param x number Input value.
    ---@return number Clamped value.
    local function clamp(x) return math.max(0, math.min(1, x)) end
    r, g, b = clamp(r), clamp(g), clamp(b)
    return string.format(
        "#%02X%02X%02X",
        math.floor(r * 255 + 0.5),
        math.floor(g * 255 + 0.5),
        math.floor(b * 255 + 0.5)
    )
end

--- Convert normalized RGB values to HSL.
---@param r number Red channel (0–1).
---@param g number Green channel (0–1).
---@param b number Blue channel (0–1).
---@return number h Hue component (0–1).
---@return number s Saturation component (0–1).
---@return number l Lightness component (0–1).
local function rgb_to_hsl(r, g, b)
    local maxv = math.max(r, g, b)
    local minv = math.min(r, g, b)
    local h, s, l

    l = (maxv + minv) / 2

    if maxv == minv then
        h = 0
        s = 0
    else
        local d = maxv - minv
        if l > 0.5 then
            s = d / (2 - maxv - minv)
        else
            s = d / (maxv + minv)
        end

        if maxv == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif maxv == g then
            h = (b - r) / d + 2
        else
            h = (r - g) / d + 4
        end

        h = h / 6
    end

    return h, s, l
end

--- Convert HSL values to normalized RGB.
---@param h number Hue component (0–1).
---@param s number Saturation component (0–1).
---@param l number Lightness component (0–1).
---@return number r Red channel (0–1).
---@return number g Green channel (0–1).
---@return number b Blue channel (0–1).
local function hsl_to_rgb(h, s, l)
    local function hue_to_rgb(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < 1 / 6 then return p + (q - p) * 6 * t end
        if t < 1 / 2 then return q end
        if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
        return p
    end

    if s == 0 then
    else
        local q = (l < 0.5) and (l * (1 + s)) or (l + s - l * s)
        local p = 2 * l - q
        local r = hue_to_rgb(p, q, h + 1 / 3)
        local g = hue_to_rgb(p, q, h)
        local b = hue_to_rgb(p, q, h - 1 / 3)
        return r, g, b
    end
end

--- Boost the saturation and adjust the lightness of a hex color.
---@param hex string The input hex color string (e.g. "#RRGGBB").
---@param sat_multiplier number? (optional) Saturation multiplier (default = 1.5).
---@param light_delta number? (optional) Lightness delta (default = 0.08).
---@return string The adjusted hex color string.
function M.boost(hex, sat_multiplier, light_delta)
    local s_mult  = sat_multiplier or 1.5
    local l_delta = light_delta or 0.08

    local r, g, b = hex_to_rgb(hex)
    local h, s, l = rgb_to_hsl(r, g, b)

    local s2      = math.min(s * s_mult, 1.0)

    local l2
    if l < 0.5 then
        l2 = math.max(0, l - l_delta)
    else
        l2 = math.min(1, l + l_delta)
    end

    local r2, g2, b2 = hsl_to_rgb(h, s2, l2)
    return rgb_to_hex(r2, g2, b2)
end

--- Boost the saturation and adjust the lightness of a palette of hex colors.
---@param palette table<string, string> A mapping of keys to hex color strings.
---@param sat_multiplier number? Optional saturation multiplier (default = 1.5).
---@param light_delta number? Optional lightness delta (default = 0.08).
---@return table<string, string> The adjusted palette with new hex color strings.
function M.boost_palette(palette, sat_multiplier, light_delta)
    local result = {}
    for key, hex in pairs(palette) do
        result[key] = M.boost(hex, sat_multiplier, light_delta)
    end
    return result
end

return M
