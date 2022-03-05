# LanguageDetect
Lua spoken language detection library using n-gram

`LanguageDetect` is a port of the [PEAR::Text_LanguageDetect](https://pear.php.net/package/Text_LanguageDetect) for [Lua](https://lua.org) and [LuaJIT](https://luajit.org)

LanguageDetect can identify 52 human languages from text samples and return confidence scores for each.

## Installation

This package can be installed via [LuaRocks](https://luarocks.org/) as follows
```shell
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

## API
* `detect(sample, limit)` Detects the closeness of a sample of text to the known languages
* `getLanguages()` Returns the list of detectable languages
* `getLanguageCount()` Returns the number of languages that the lib can detect
* `setLanguageType(format)` Sets the language format to be used. Suported values:
  * `iso2`, resulting in two letter language format
  * `iso3`, resulting in three letter language format
  * Any other value results in the full language name

## Credits
Nicholas Pisarro for his work on [PEAR::Text_LanguageDetect](https://pear.php.net/package/Text_LanguageDetect)

Francois-Guillaume Ribreau and Ruslan Zavackiy for their work on [node-language-detect](https://github.com/FGRibreau/node-language-detect)

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
