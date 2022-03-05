-- This Lua 5.3+ script converts .json data from https://github.com/FGRibreau/node-language-detect to Lua (all versions)
-- You must run this in Lua 5.3 or newer to work.
-- The generated files from this script are supported by Lua 5.1+ and LuaJIT.

local file = io.open("data/lang.json", "r")
local content = file:read("*a")
file:close()

content = content:gsub('"([^"]+)":', function(match)
  return '["'.. match .. '"]='
end)

content = content:gsub("\\u(....)", function(match)
  return load("return '\\u{" .. match .. "}'")()
end)

file = io.open("data/lang.lua", "w")
file:write("return " .. content)
file:close()

file = io.open("data/unicode_blocks.json", "r")
content = file:read("*a")
file:close()

content = content:gsub('%[', function(match)
  return '{'
end)

content = content:gsub('%]', function(match)
  return '}'
end)


file = io.open("data/unicode_blocks.lua", "w")
file:write("return " .. content)
file:close()
