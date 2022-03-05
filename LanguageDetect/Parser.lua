local dbUnicodeBlocks = require('LanguageDetect.data.unicode_blocks')

--[[

 * This class represents a text sample to be parsed.
 *
 * Largely inspired from the PHP Pear Package Text_LanguageDetect by Nicholas Pisarro
 * Licence: http://www.debian.org/misc/bsd.license BSD
 *
 * @author Francois-Guillaume Ribreau - @FGRibreau
 * @author Ruslan Zavackiy - @Chaoser
 * @author github.com/listingtg
 *
 * @see https://github.com/listingtg/LanguageDetect

--]]
return function (str)
  local self = {}
  --[[

   * The size of the trigram data arrays
   *
   * @access   private
   * @local      int

--]]
  self.threshold = 300

  --[[

   * stores the trigram ranks of the sample
   *
   * @access  private
   * @local     array

--]]
  self.trigramRanks = {}

  --[[

   * Whether the parser should compile trigrams
   *
   * @access  private
   * @local     bool

--]]
  self.compileTrigram = true

  self.compileUnicode = true
  self.unicodeSkipAscii = true
  self.unicodeBlocks = {}
  
  --[[

   * Whether the trigram parser should pad the beginning of the string
   *
   * @access  private
   * @local     bool

--]]
  self.trigramPadStart = false

  self.trigram = {}

  --[[

   * the piece of text being parsed
   *
   * @access  private
   * @local     string

--]]

  --[[

   * Constructor
   *
   * @access  private
   * @param   string  string to be parsed

--]]
  self.str = str and string.gsub(str, "[~!@#$%%%^&%*%(%)_|%+%-=%?;:\",.<>%{%}%[%]\\/]", ' ') or ''
  



  --[[

   * turn on/off padding the beginning of the sample string
   *
   * @access  public
   * @param   bool   true for on, false for off

--]]
  self.setPadStart = function(bool)
    self.trigramPadStart = bool or true
  end

  --[[

   * Returns the trigram ranks for the text sample
   *
   * @access  public
   * @return  array   trigram ranks in the text sample

--]]
  self.getTrigramRanks = function () 
    return self.trigramRanks
  end

  self.getBlockCount = function ()
    return #dbUnicodeBlocks
  end

  self.getUnicodeBlocks = function ()
    return self.unicodeBlocks
  end

  --[[

   * Executes the parsing operation
   *
   * Be sure to call the set*() functions to set options and the
   * prepare*() functions first to tell it what kind of data to compute
   *
   * Afterwards the get*() functions can be used to access the compiled
   * information.
   *
   * @access public

--]]
  self.analyze = function ()
    local len = #self.str
    local byteCounter = 0
    local a = ' '
    local b = ' '
    local dropone, c

    local blocksCount
    if self.compileUnicode then
      blocksCount = #dbUnicodeBlocks
    end

    -- trigram startup
    if self.compileTrigram then
      -- initialize them as blank so the parser will skip the first two
      -- (since it skips trigrams with more than  2 contiguous spaces)
      a = ' '
      b = ' '
      
      -- kludge
      -- if it finds a valid trigram to start and the start pad option is
      -- off, then set a variable that will be used to reduce this
      -- trigram after parsing has finished
      if not self.trigramPadStart then

        a = string.sub(self.str, byteCounter+1, byteCounter+1):lower()

        byteCounter = byteCounter + 1

        if a ~= ' ' then
          b = string.sub(self.str, byteCounter+1, byteCounter+1):lower()
          dropone = ' ' .. a .. b
        end

        byteCounter = 0
        a = ' '
        b = ' '
      end
    end

    local skippedCount = 0
    local unicodeChars = {}

    while (byteCounter < len) do

      c = string.sub(self.str, byteCounter+1, byteCounter+1):lower()
      byteCounter = byteCounter + 1

      -- language trigram detection
      if self.compileTrigram then
        if not (b == ' ' and (a == ' ' or c == ' ')) then
         
          local abc = a .. b .. c
          if self.trigram[abc] then
             self.trigram[abc] = self.trigram[abc] + 1
          else
             self.trigram[abc] =  1;
          end

        end

        a = b
        b = c
      end

      if (self.compileUnicode) then
        
        local charCode = string.byte(string.sub(c, 1, 1))

        if self.unicodeSkipAscii
          and string.match(c:lower(), "[a-z ]")
          and (charCode < 65 or charCode > 122 or (charCode > 90 and charCode < 97))
          and (c ~= "'") then

          skippedCount = skippedCount + 1
        else
          if unicodeChars[c] then
            unicodeChars[c] = unicodeChars[c] + 1
          else
            unicodeChars[c] = 1
          end
        end
      end
    end

    self.unicodeBlocks = {};

    if (self.compileUnicode) then

      local keys = {}
      for key, _ in pairs(unicodeChars) do
        keys[#keys + 1] = tostring(key)
      end
      local keysLength = #keys

      for i = keysLength, 1, -1 do
        local unicode = string.byte(string.sub(keys[i], 1, 1))
        
        local count = unicodeChars[keys[i]]

        local search = self.unicodeBlockName(unicode, blocksCount)

        local blockName = (search ~= -1) and search[3] or '[Malformatted]'

        if self.unicodeBlocks[blockName] then
          self.unicodeBlocks[blockName] = self.unicodeBlocks[blockName] + count
        else
          self.unicodeBlocks[blockName] = count
        end
      end
    end

    -- trigram cleanup
    if (self.compileTrigram) then
      -- pad the end
      if (b ~= ' ') then
        local ab = a .. b .. ' '
        if self.trigram[ab] then
          self.trigram[ab] = self.trigram[ab] + 1
        else
          self.trigram[ab] = 1
        end
      end

      -- perl compatibility; Language::Guess does not pad the beginning
      -- kludge
      if (type(dropone) ~= 'nil' and self.trigram[dropone] == 1) then
        self.trigram[dropone] = nil
      end

      local keys = {}
      for key, _ in pairs(self.trigram) do
        keys[#keys +1] = tostring(key)
      end

      if (self.trigram and #keys > 0) then
        self.trigramRanks = self.arrRank(self.trigram)
      else
        self.trigramRanks = {}
      end
    end
  end

  --[[

   * Sorts an array by value breaking ties alphabetically
   *
   * @access private
   * @param arr the array to sort

--]]

  self.bubleSort = function (arr) 
    -- should do the same as this perl statement:
    -- sort { $trigrams{$b} == $trigrams{$a} ?  $a cmp $b : $trigrams{$b} <=> $trigrams{$a} }

    -- needs to sort by both key and value at once
    -- using the key to break ties for the value

    -- converts array into an array of arrays of each key and value
    -- may be a better way of doing this
    local combined = {}

    for key in pairs(arr) do
      combined[#combined + 1] = {key, arr[key]}
    end

    table.sort(combined, self.sortFunc)

    local replacement = {}

    local length = #combined;

    for i = 1, length do
      replacement[combined[i][1]] = combined[i][2]
    end

    return replacement;
  end

  --[[

   * Converts a set of trigrams from frequencies to ranks
   *
   * Thresholds (cuts off) the list at $this->_threshold
   *
   * @access  protected
   * @param   arr     array of trgram
   * @return  object  ranks of trigrams

--]]
  self.arrRank = function (arr)

    -- sorts alphabetically first as a standard way of breaking rank ties
    arr = self.bubleSort(arr);

    local rank = {}
    local i = 0

    for key in pairs(arr) do
      rank[key] = i
      i = i + 1

      -- cut off at a standard threshold
      if (i >= self.threshold) then
        break;
      end
    end

    return rank
  end

  --[[

   * Sort function used by bubble sort
   *
   * Callback function for usort().
   *
   * @access   private
   * @param    a    first param passed by usort()
   * @param    b    second param passed by usort()
   * @return   int  1 if $a is greater, -1 if not
   *
   * @see      bubleSort()

--]]
  self.sortFunc =  function (a, b) 
    -- each is actually a key/value pair, so that it can compare using both
    local aKey = a[1]
    local aValue = a[2]
    local bKey = b[1]
    local bValue = b[2];

    -- if the values are the same, break ties using the key
    if aValue == bValue then
      local ts = {aKey, bKey}
      table.sort(ts)
      return ts[2] == aKey --and -1 or 1
    else 
      return (aValue > bValue) --and -1 or 1
    end
  end

  self.unicodeBlockName = function (unicode, blockCount)
    if (unicode <= tonumber(dbUnicodeBlocks[1][2])) then
      return dbUnicodeBlocks[1]
    end

    local high = blockCount and (blockCount - 1) or #dbUnicodeBlocks
    local low = 1
    local mid
    while (low <= high) do
      mid = math.floor((low + high) / 2)
      if (unicode < tonumber(dbUnicodeBlocks[mid+1][1])) then
        high = mid - 1;
      elseif (unicode > tonumber(dbUnicodeBlocks[mid+1][2])) then
        low = mid + 1;
      else 
        return dbUnicodeBlocks[mid+1];
      end
    end

    return -1
  end

  return self
end
