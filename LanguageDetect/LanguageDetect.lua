--[[

 *
 * Detects the language of a given piece of text.
 *
 * Attempts to detect the language of a sample of text by correlating ranked
 * 3-gram frequencies to a table of 3-gram frequencies of known languages.
 *
 * Implements a version of a technique originally proposed by Cavnar & Trenkle
 * (1994): "N-Gram-Based Text Categorization"
 *
 * Largely inspired from the PHP Pear Package Text_LanguageDetect by Nicholas Pisarro
 * Licence: http://www.debian.org/misc/bsd.license BSD
 *
 * @author github.com/listingtg
 * @author Francois-Guillaume Ribreau - @FGRibreau
 * @author Ruslan Zavackiy - @Chaoser
 *
 * @see https://github.com/listingtg/LanguageDetect


--]]

local dbLang = require('LanguageDetect.data.lang')
local Parser = require('LanguageDetect.Parser')
local ISO639 = require('LanguageDetect.ISO639')

return function(languageType)
  local self = {}

  --[[

   * The trigram data for comparison
   *
   * Will be loaded on start from $this->_db_filename
   *
   * May be set to a PEAR_Error object if there is an error during its
   * initialization
   *
   * @local      array
   * @access   private

  --]]
  self.langDb = {}

  --[[

   * The size of the trigram data arrays
   *
   * @local     int
   * @access  private

  --]]
  self.threshold = 300

  self.useUnicodeNarrowing = true

  --[[

   * Constructor
   *
   * Load the language database.
   *

  --]]
  self.langDb = dbLang['trigram']
  self.unicodeMap = dbLang['trigram-unicodemap']

  self.languageType = languageType
  




  --[[

   * Returns the number of languages that this object can detect
   *
   * @access public
   * @return int the number of languages

  --]]
  self.getLanguageCount = function()
    return #self.getLanguages()
  end

  self.setLanguageType = function (type)
    self.languageType = type
    return self.languageType
  end

  --[[

   * Returns the list of detectable languages
   *
   * @access public
   * @return object the names of the languages known to this object

  --]]
  self.getLanguages = function()
    local keys = {}
    for key, _ in pairs(self.langDb) do
      keys[#keys + 1] = tostring(key)
    end
    return keys
  end

  --[[

   * Calculates a linear rank-order distance statistic between two sets of
   * ranked trigrams
   *
   * Sums the differences in rank for each trigram. If the trigram does not
   * appear in both, consider it a difference of $this->_threshold.
   *
   * This distance measure was proposed by Cavnar & Trenkle (1994). Despite
   * its simplicity it has been shown to be highly accurate for language
   * identification tasks.
   *
   * @access  private
   * @param   arr1  the reference set of trigram ranks
   * @param   arr2  the target set of trigram ranks
   * @return  int   the sum of the differences between the ranks of
   *                the two trigram sets

  --]]
  self.distance = function(arr1, arr2)

    local me = self
    local sumdist = 0
      
    local keys = {}
    for key, _ in pairs(arr2) do
      keys[#keys + 1] = tostring(key)
    end

    for i = #keys, 1, -1 do
      sumdist = sumdist + (arr1[keys[i]] and (math.abs(arr2[keys[i]] - arr1[keys[i]])) or me.threshold)
    end

    return sumdist
  end

  --[[

   * Normalizes the score returned by _distance()
   *
   * Different if perl compatible or not
   *
   * @access  private
   * @param   score       the score from _distance()
   * @param   baseCount   the number of trigrams being considered
   * @return  number      the normalized score
   *
   * @see     distance()

  --]]
  self.normalizeScore = function (score, baseCount)
    return 1 - (score / (baseCount or self.threshold) / self.threshold)
  end

  --[[

   * Detects the closeness of a sample of text to the known languages
   *
   * Calculates the statistical difference between the text and
   * the trigrams for each language, normalizes the score then
   * returns results for all languages in sorted order
   *
   * If perl compatible, the score is 300-0, 0 being most similar.
   * Otherwise, it's 0-1 with 1 being most similar.
   *
   * The $sample text should be at least a few sentences in length;
   * should be ascii-7 or utf8 encoded, if another and the mbstring extension
   * is present it will try to detect and convert. However, experience has
   * shown that mb_detect_encoding() *does not work very well* with at least
   * some types of encoding.
   *
   * @access  public
   * @param   sample  a sample of text to compare.
   * @param   limit  if specified, return an array of the most likely
   *                  $limit languages and their scores.
   * @return  Array   sorted array of language scores, blank array if no
   *                  useable text was found, or PEAR_Error if error
   *                  with the object setup
   *
   * @see     distance()

  --]]
  self.detect  = function(sample, limit)
    local me = self
    local scores = {}

    limit = tonumber(limit) or 0

    if sample == '' or #sample < 3 then
      return {}
    end

    local sampleObj = Parser(sample)
    sampleObj.setPadStart(true)
    sampleObj.analyze()

    local trigramFreqs = sampleObj.getTrigramRanks()
   
    local trigramCount = 0
    for key, _ in pairs(trigramFreqs) do
      trigramCount = trigramCount + 1
    end

    if trigramCount == 0 then
      return {}
    end

    local keys = {}
    
    if self.useUnicodeNarrowing then
      
      local blocks = sampleObj.getUnicodeBlocks()
      local languages = {}
      for language, _ in pairs(blocks) do
        languages[#languages + 1] = tostring(language)
      end
      local keysLength = #languages
      for i = keysLength, 1, -1 do
        if self.unicodeMap[languages[i]] then
          for lang, _ in pairs(self.unicodeMap[languages[i]]) do
            local found = false
            for _, key in pairs(keys) do
              if key == lang then
                found = true
                break
              end
            end
            if not found then
              keys[#keys + 1] = lang
            end
          end
        end
      end
    else
      keys = me.getLanguages()
    end
    for i = #keys, 1, -1 do
      local score = me.normalizeScore(me.distance(me.langDb[keys[i]], trigramFreqs), trigramCount)
      if score then
        scores[#scores + 1] = {keys[i], score}
      end
    end

    -- Sort the array
    table.sort(scores, function (a, b)
      return b[2] < a[2]
    end)
    local scoresLength = #scores

    if scoresLength == 0 then
      return {}
    end

    if me.languageType == 'iso2' then
      for i = scoresLength, 1, -1 do
        scores[i][1] = ISO639.getCode2(scores[i][1]);
      end
    elseif me.languageType == 'iso3' then
      for i = scoresLength, 1, -1 do
        scores[i][1] = ISO639.getCode3(scores[i][1]);
      end
    end

    -- limit the number of returned scores
    if limit > 0 then
      local subscores = {}
      for _, value in pairs(scores) do
        if #subscores < limit then
          subscores[#subscores + 1] = value
        else
          break
        end
      end    
      return subscores
    end
    return scores
  end
  
  return self
end
