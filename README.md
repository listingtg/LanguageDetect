# LanguageDetect
Lua spoken language detection library using n-gram

## Installation

```
$ luarocks install languagedetect
```

## Usage

```lua
local LanguageDetect = require('LanguageDetect')

-- change result format:
-- LanguageDetect.setLanguageType('iso2')

local result = LanguageDetect.detect('This is a test.')

--[[
result example:
  {
    { 'english', 0.5969230769230769 },
    { 'hungarian', 0.407948717948718 },
    ...
  }
--]]

print(result[1][1]) --> english
```

## License

MIT License

Copyright (c) 2022 listingtg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
