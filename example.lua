local function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    local formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))      
    else
      print(formatting .. v)
    end
  end
end


local LanguageDetect = require('LanguageDetect');
local lngDetector = LanguageDetect();

-- OR
-- local lngDetector = require('LanguageDetect')('iso3')

tprint(lngDetector.detect('This is a test.'));

--[[
  { { 'english', 0.5969230769230769 },
  { 'hungarian', 0.407948717948718 },
  { 'latin', 0.39205128205128204 },
  { 'french', 0.367948717948718 },
  { 'portuguese', 0.3669230769230769 },
  { 'estonian', 0.3507692307692307 },
  { 'latvian', 0.2615384615384615 },
  { 'spanish', 0.2597435897435898 },
  { 'slovak', 0.25051282051282053 },
  { 'dutch', 0.2482051282051282 },
  { 'lithuanian', 0.2466666666666667 },
  ... }
--]]

-- Set language name to iso2
lngDetector.setLanguageType('iso2')
-- Only get the first 2 results
tprint(lngDetector.detect('This is a test.', 2));

--[[
  { { 'en', 0.5969230769230769 }, { 'hu', 0.407948717948718 }  }
--]]
