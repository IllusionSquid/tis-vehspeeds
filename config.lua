Config = {}
Config.Version = "1.0.0"

Config.SpeedTest = {
    TrackObject = "stt_prop_stunt_track_straight",
    TrackPos = vector3(195.03, -3263.48, 2000),
    Vehicles = { -- Add modelname here for the list of models to test when the command /speedtestlist is ran
        -- Compacts -----------------------------------------------------------------------------------------------------
        -- "asbo",
        -- "blista",
        -- "brioso",
        -- "club",
        -- "dilettante",
        -- "dilettante2",
        -- "issi2",
        -- "kanjo",
        -- "panto",
        -- "prairie",
        -- "rhapsody",
        -- "brioso2",
        -- "issi3",
        -- "issi4",
        -- "issi5",
        -- "issi6",
        -- "weevil",
        -- Coupes -------------------------------------------------------------------------------------------------------
        -- "cogcabrio",
        -- "exemplar",
        -- "f620",
        -- "felon",
        -- "felon2",
        -- "jackal",
        -- "oracle",
        -- "oracle2",
        -- "sentinel",
        -- "sentinel2",
        -- "windsor",
        -- "windsor2",
        -- "zion",
        -- "zion2",
        -- Muscle -------------------------------------------------------------------------------------------------------
        -- "blade",
        -- "buccaneer",
        -- "buccaneer2",
        -- "chino",
        -- "chino2",
        -- "clique",
        -- "coquette3",
        -- "deviant",
        -- "dominator",
        -- "dominator2",
        -- "dominator3",
        -- "dominator4",
        -- "dominator5",
        -- "dominator6",
        -- "dukes",
        -- "dukes2",
        -- "dukes3",
        -- "ellie",
        -- "faction",
        -- "faction2",
        -- "faction3",
        -- "gauntlet",
        -- "gauntlet2",
        -- "gauntlet3",
        -- "gauntlet4",
        -- "gauntlet5",
        -- "hermes",
        -- "hotknife",
        -- "hustler",
        -- "impaler",
        -- "impaler2",
        -- "impaler3",
        -- "impaler4",
        -- "imperator",
        -- "imperator2",
        -- "imperator3",
        -- "lurcher",
        -- "manana2",
        -- "moonbeam",
        -- "moonbeam2",
        -- "nightshade",
        -- "peyote2",
        -- "phoenix",
        -- "picador",
        -- "ratloader",
        -- "ratloader2",
        -- "ruiner",
        -- "ruiner2",
        -- "ruiner3",
        -- "sabregt",
        -- "sabregt2",
        -- "slamvan",
        -- "slamvan2",
        -- "slamvan3",
        -- "slamvan4",
        -- "slamvan5",
        -- "slamvan6",
        -- "stalion",
        -- "stalion2",
        -- "tampa",
        -- "tampa3",
        -- "tulip",
        -- "vamos",
        -- "vigero",
        -- "virgo",
        -- "virgo2",
        -- "virgo3",
        -- "voodoo",
        -- "voodoo2",
        -- "yosemite",
        -- "yosemite2",
        -- Off Road -----------------------------------------------------------------------------------------------------
        -- "bfinjection",
        -- "bifta",
        -- "blazer",
        -- "blazer2",
        -- "blazer3",
        -- "blazer4",
        -- "bodhi2",
        -- "brawler",
        -- "bruiser",
        -- "bruiser2",
        -- "bruiser3",
        -- "brutus",
        -- "brutus2",
        -- "brutus3",
        -- "caracara2",
        -- "dloader",
        -- "dubsta3",
        -- "dune",
        -- "dune2",
        -- "everon",
        -- "freecrawler",
        -- "hellion",
        -- "insurgent2",
        -- "kalahari",
        -- "kamacho",
        -- "marshall",
        -- "mesa3",
        -- "monster",
        -- "monster3",
        -- "monster4",
        -- "monster5",
        -- "outlaw",
        -- "rancherxl",
        -- "rebel",
        -- "rebel2",
        -- "riata",
        -- "sandking",
        -- "sandking2",
        -- "trophytruck",
        -- "trophytruck2",
        -- "vagrant",
        -- "verus",
        -- "winky",
        -- "yosemite3",
        -- Open Wheel ---------------------------------------------------------------------------------------------------
        -- "formula",
        -- "formula2",
        -- "openwheel1",
        -- "openwheel2",
        -- Sedan --------------------------------------------------------------------------------------------------------
        -- "asea",
        -- "asterope",
        -- "cog55",
        -- "cog552",
        -- "cognoscenti",
        -- "cognoscenti2",
        -- "emperor",
        -- "emperor2",
        -- "emperor3",
        -- "fugitive",
        -- "glendale",
        -- "glendale2",
        -- "ingot",
        -- "intruder",
        -- "limo2",
        -- "premier",
        -- "primo",
        -- "primo2",
        -- "regina",
        -- "romero",
        -- "schafter2",
        -- "schafter5",
        -- "schafter6",
        -- "stafford",
        -- "stanier",
        -- "stratum",
        -- "stretch",
        -- "superd",
        -- "surge",
        -- "tailgater",
        -- "warrener",
        -- "washington",
        -- Sport --------------------------------------------------------------------------------------------------------
        -- "alpha",
        -- "banshee",
        -- "bestiagts",
        -- "blista2",
        -- "blista3",
        -- "buffalo",
        -- "buffalo2",
        -- "buffalo3",
        -- "carbonizzare",
        -- "comet2",
        -- "comet3",
        -- "comet4",
        -- "comet5",
        -- "coquette",
        -- "coquette4",
        -- "drafter",
        -- "elegy",
        -- "elegy2",
        -- "feltzer2",
        -- "flashgt",
        -- "furoregt",
        -- "fusilade",
        -- "futo",
        -- "gb200",
        -- "hotring",
        -- "imorgon",
        -- "issi7",
        -- "italigto",
        -- "italirsx", -- IDK
        -- "jester",
        -- "jester2",
        -- "jester3",
        -- "jugular",
        -- "khamelion",
        -- "komoda",
        -- "kuruma",
        -- "kuruma2",
        -- "locust",
        -- "lynx",
        -- "massacro",
        -- "massacro2",
        -- "neo",
        -- "neon",
        -- "ninef",
        -- "ninef2",
        -- "omnis",
        -- "paragon",
        -- "paragon2",
        -- "pariah",
        -- "penumbra",
        -- "penumbra2",
        -- "raiden",
        -- "rapidgt",
        -- "rapidgt2",
        -- "revolter",
        -- "ruston",
        -- "schafter3",
        -- "schafter4",
        -- "schlagen",
        -- "schwarzer",
        -- "sentinel3",
        -- "seven70",
        -- "specter",
        -- "specter2",
        -- "streiter",
        -- "sugoi",
        -- "sultan",
        -- "sultan2",
        -- "surano",
        -- "tampa2",
        -- "tropos",
        -- "verlierer2",
        -- "vstr",
        -- "zr380",
        -- "zr3802",
        -- "zr3803",
        -- Sport Classic ------------------------------------------------------------------------------------------------
        -- "ardent",
        -- "btype",
        -- "btype2",
        -- "btype3",
        -- "casco",
        -- "cheburek",
        "cheetah2",
        "coquette2",
        "deluxo",
        "dynasty",
        "fagaloa",
        "feltzer3",
        "gt500",
        "infernus2",
        "jb700",
        "jb7002",
        "mamba",
        "manana",
        "michelli",
        "monroe",
        "nebula",
        "peyote",
        "peyote3",
        "pigalle",
        "rapidgt3",
        "retinue",
        "retinue2",
        "savestra",
        "stinger",
        "stingergt",
        "swinger",
        "torero",
        "tornado",
        "tornado2",
        "tornado3",
        "tornado4",
        "tornado5",
        "tornado6",
        "turismo2",
        "viseris",
        "z190",
        "zion3",
        "ztype",
        -- Super --------------------------------------------------------------------------------------------------------
        "adder",
        "autarch",
        "banshee2",
        "bullet",
        "cheetah",
        "cyclone",
        "deveste",
        "emerus",
        "entity2",
        "entityxf",
        "fmj",
        "furia",
        "gp1",
        "infernus",
        "italigtb",
        "italigtb2",
        "krieger",
        "le7b",
        "nero",
        "nero2",
        "osiris",
        "penetrator",
        "pfister811",
        "prototipo",
        "reaper",
        "s80",
        "sc1",
        "sheava",
        "sultanrs",
        "t20",
        "taipan",
        "tempesta",
        "tezeract",
        "thrax",
        "tigon",
        "turismor",
        "tyrant",
        "tyrus",
        "vacca",
        "vagner",
        "visione",
        "voltic",
        "xa21",
        "zentorno",
        "zorrusso",
        -- SUV ----------------------------------------------------------------------------------------------------------
        "baller",
        "baller2",
        "baller3",
        "baller4",
        "baller5",
        "baller6",
        "bjxl",
        "cavalcade",
        "cavalcade2",
        "contender",
        "dubsta",
        "dubsta2",
        "fq2",
        "granger",
        "gresley",
        "habanero",
        "huntley",
        "landstalker",
        "landstalker2",
        "mesa",
        "novak",
        "patriot",
        "patriot2",
        "radi",
        "rebla",
        "rocoto",
        "seminole",
        "seminole2",
        "serrano",
        "squaddie",
        "toros",
        "xls",
        "xls2",
    }
}

Config.VehicleClasses = {
    [0] = "Compacts",
    [1] = "Sedans",
    [2] = "SUVs",
    [3] = "Coupes",
    [4] = "Muscle",
    [5] = "Sports Classics",
    [6] = "Sports",
    [7] = "Super",
    [8] = "Motorcycles",
    [9] = "Off-road",
    [10] = "Industrial",
    [11] = "Utility",
    [12] = "Vans",
    [13] = "Cycles",
    [14] = "Boats",
    [15] = "Helicopters",
    [16] = "Planes",
    [17] = "Service",
    [18] = "Emergency",
    [19] = "Military",
    [20] = "Commercial",
    [21] = "Trains"
}