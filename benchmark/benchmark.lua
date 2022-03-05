local data = require('benchmark.data.text')
local LanguageDetect = require('LanguageDetect')

local l = LanguageDetect()

local ok = 0

local start = os.clock()
for i, _ in pairs(data) do
  local text = data[i]
  local r = l.detect(text.text)

  if r and r[1][2] > 0.2 then
    ok = ok + 1
  end
end
local final = os.clock()

local time = (final-start)--math.floor((final-start)+0.5)/1000

print(#data .. " items processed in " .. time .. " secs (" .. ok .. " with a score > 0.2)")
