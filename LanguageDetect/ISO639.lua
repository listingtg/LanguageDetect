local Languages

Languages = {
  getCode2 = function(lang)
    return Languages.nameToCode2[lang:lower()]
  end,

  getCode3 = function(lang)
    return Languages.nameToCode3[lang:lower()]
  end,

  getName2 = function(code)
    return Languages.code2ToName[code:lower()]
  end,

  getName3 = function(code)
    return Languages.code3ToName[code:lower()]
  end,

  nameToCode2 = {
    albanian = "sq",
    arabic = "ar",
    azeri = "az",
    bengali = "bn",
    bulgarian = "bg",
    cebuano = nil,
    croatian = "hr",
    czech = "cs",
    danish = "da",
    dutch = "nl",
    english = "en",
    estonian = "et",
    farsi = "fa",
    finnish = "fi",
    french = "fr",
    german = "de",
    hausa = "ha",
    hawaiian = nil,
    hindi = "hi",
    hungarian = "hu",
    icelandic = "is",
    indonesian = "id",
    italian = "it",
    kazakh = "kk",
    kyrgyz = "ky",
    latin = "la",
    latvian = "lv",
    lithuanian = "lt",
    macedonian = "mk",
    mongolian = "mn",
    nepali = "ne",
    norwegian = "no",
    pashto = "ps",
    pidgin = nil,
    polish = "pl",
    portuguese = "pt",
    romanian = "ro",
    russian = "ru",
    serbian = "sr",
    slovak = "sk",
    slovene = "sl",
    somali = "so",
    spanish = "es",
    swahili = "sw",
    swedish = "sv",
    tagalog = "tl",
    turkish = "tr",
    ukrainian = "uk",
    urdu = "ur",
    uzbek = "uz",
    vietnamese = "vi",
    welsh = "cy"
  },

  nameToCode3 = {
    albanian = "sqi",
    arabic = "ara",
    azeri = "aze",
    bengali = "ben",
    bulgarian = "bul",
    cebuano = "ceb",
    croatian = "hrv",
    czech = "ces",
    danish = "dan",
    dutch = "nld",
    english = "eng",
    estonian = "est",
    farsi = "fas",
    finnish = "fin",
    french = "fra",
    german = "deu",
    hausa = "hau",
    hawaiian = "haw",
    hindi = "hin",
    hungarian = "hun",
    icelandic = "isl",
    indonesian = "ind",
    italian = "ita",
    kazakh = "kaz",
    kyrgyz = "kir",
    latin = "lat",
    latvian = "lav",
    lithuanian = "lit",
    macedonian = "mkd",
    mongolian = "mon",
    nepali = "nep",
    norwegian = "nor",
    pashto = "pus",
    pidgin = "crp",
    polish = "pol",
    portuguese = "por",
    romanian = "ron",
    russian = "rus",
    serbian = "srp",
    slovak = "slk",
    slovene = "slv",
    somali = "som",
    spanish = "spa",
    swahili = "swa",
    swedish = "swe",
    tagalog = "tgl",
    turkish = "tur",
    ukrainian = "ukr",
    urdu = "urd",
    uzbek = "uzb",
    vietnamese = "vie",
    welsh = "cym"
  },
  code2ToName = {
    ar = "arabic",
    az = "azeri",
    bg = "bulgarian",
    bn = "bengali",
    cs = "czech",
    cy = "welsh",
    da = "danish",
    de = "german",
    en = "english",
    es = "spanish",
    et = "estonian",
    fa = "farsi",
    fi = "finnish",
    fr = "french",
    ha = "hausa",
    hi = "hindi",
    hr = "croatian",
    hu = "hungarian",
    id = "indonesian",
    is = "icelandic",
    it = "italian",
    kk = "kazakh",
    ky = "kyrgyz",
    la = "latin",
    lt = "lithuanian",
    lv = "latvian",
    mk = "macedonian",
    mn = "mongolian",
    ne = "nepali",
    nl = "dutch",
    no = "norwegian",
    pl = "polish",
    ps = "pashto",
    pt = "portuguese",
    ro = "romanian",
    ru = "russian",
    sk = "slovak",
    sl = "slovene",
    so = "somali",
    sq = "albanian",
    sr = "serbian",
    sv = "swedish",
    sw = "swahili",
    tl = "tagalog",
    tr = "turkish",
    uk = "ukrainian",
    ur = "urdu",
    uz = "uzbek",
    vi = "vietnamese"
  },

  code3ToName = {
    ara = "arabic",
    aze = "azeri",
    ben = "bengali",
    bul = "bulgarian",
    ceb = "cebuano",
    ces = "czech",
    crp = "pidgin",
    cym = "welsh",
    dan = "danish",
    deu = "german",
    eng = "english",
    est = "estonian",
    fas = "farsi",
    fin = "finnish",
    fra = "french",
    hau = "hausa",
    haw = "hawaiian",
    hin = "hindi",
    hrv = "croatian",
    hun = "hungarian",
    ind = "indonesian",
    isl = "icelandic",
    ita = "italian",
    kaz = "kazakh",
    kir = "kyrgyz",
    lat = "latin",
    lav = "latvian",
    lit = "lithuanian",
    mkd = "macedonian",
    mon = "mongolian",
    nep = "nepali",
    nld = "dutch",
    nor = "norwegian",
    pol = "polish",
    por = "portuguese",
    pus = "pashto",
    rom = "romanian",
    rus = "russian",
    slk = "slovak",
    slv = "slovene",
    som = "somali",
    spa = "spanish",
    sqi = "albanian",
    srp = "serbian",
    swa = "swahili",
    swe = "swedish",
    tgl = "tagalog",
    tur = "turkish",
    ukr = "ukrainian",
    urd = "urdu",
    uzb = "uzbek",
    vie = "vietnamese"
  }
}

return Languages