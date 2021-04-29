module Character exposing (..)

import Json.Decode as Decode
import Json.Decode.Extra
import Json.Decode.Field as Field
import Json.Encode as Encode


type alias Character =
    { advancedSkills : List Skill
    , basicSkills : List Skill
    , c12csAdvances : C12cs
    , c12csInitial : C12cs
    , expAdjustments : List ExpAdjustment
    , experience : Int
    , info : Information
    , talents : List Talent
    , trappings : List Trapping
    , wealth : Wealth
    }


emptyCharacter : Character
emptyCharacter =
    { advancedSkills = []
    , basicSkills = basicSkillsList
    , c12csAdvances = emptyC12cs
    , c12csInitial = emptyC12cs
    , expAdjustments = []
    , experience = 0
    , info = emptyInformation
    , talents = []
    , trappings = []
    , wealth = emptyWealth
    }


encodeCharacter : Character -> Encode.Value
encodeCharacter character =
    Encode.object
        [ ( "advancedSkills", Encode.list encodeSkill character.advancedSkills )
        , ( "basicSkills", Encode.list encodeSkill character.basicSkills )
        , ( "c12csAdvances", encodeC12cs character.c12csAdvances )
        , ( "c12csInitial", encodeC12cs character.c12csInitial )
        , ( "expAdjustments", Encode.list encodeExpAdjustment character.expAdjustments )
        , ( "experience", Encode.int character.experience )
        , ( "info", encodeInformation character.info )
        , ( "talents", Encode.list encodeTalent character.talents )
        , ( "trappings", Encode.list encodeTrapping character.trappings )
        , ( "wealth", encodeWealth character.wealth )
        ]


decodeCharacter : Decode.Decoder Character
decodeCharacter =
    Field.require "advancedSkills" (Decode.list decodeSkill) <| \advancedSkills ->
    Field.require "basicSkills" (Decode.list decodeSkill) <| \basicSkills ->
    Field.require "c12csAdvances" decodeC12cs <| \c12csAdvances ->
    Field.require "c12csInitial" decodeC12cs <| \c12csInitial ->
    Field.require "expAdjustments" (Decode.list decodeExpAdjustment) <| \expAdjustments ->
    Field.require "experience" Decode.int <| \experience ->
    Field.require "info" decodeInformation <| \info ->
    Field.require "talents" (Decode.list decodeTalent) <| \talents ->
    Field.require "trappings" (Decode.list decodeTrapping) <| \trappings ->
    Field.require "wealth" decodeWealth <| \wealth ->
    Decode.succeed
        { advancedSkills = advancedSkills
        , basicSkills = basicSkills
        , c12csAdvances = c12csAdvances
        , c12csInitial = c12csInitial
        , expAdjustments = expAdjustments
        , experience = experience
        , info = info
        , talents = talents
        , trappings = trappings
        , wealth = wealth
        }

---------------------
-- Characteristics --
---------------------

type alias C12cs =
    { ws : Int
    , bs : Int
    , s : Int
    , t : Int
    , i : Int
    , ag : Int
    , dex : Int
    , int : Int
    , wp : Int
    , fel : Int
    }


type C12c
    = WS
    | BS
    | S
    | T
    | I
    | Ag
    | Dex
    | Int
    | WP
    | Fel


emptyC12cs : C12cs
emptyC12cs =
    { ws = 0
    , bs = 0
    , s = 0
    , t = 0
    , i = 0
    , ag = 0
    , dex = 0
    , int = 0
    , wp = 0
    , fel = 0
    }


allC12cs : List C12c
allC12cs =
    [ WS
    , BS
    , S
    , T
    , I
    , Ag
    , Dex
    , Int
    , WP
    , Fel
    ]


addC12cs : C12cs -> C12cs -> C12cs
addC12cs a b =
    { ws = a.ws + b.ws
    , bs = a.bs + b.bs
    , s = a.s + b.s
    , t = a.t + b.t
    , i = a.i + b.i
    , ag = a.ag + b.ag
    , dex = a.dex + b.dex
    , int = a.int + b.int
    , wp = a.wp + b.wp
    , fel = a.fel + b.fel
    }


getC12c : C12c -> C12cs -> Int
getC12c c12c c12cs =
    case c12c of
        WS -> c12cs.ws
        BS -> c12cs.bs
        S -> c12cs.s
        T -> c12cs.t
        I -> c12cs.i
        Ag -> c12cs.ag
        Dex -> c12cs.dex
        Int -> c12cs.int
        WP -> c12cs.wp
        Fel -> c12cs.fel


getC12cs : Character -> C12cs
getC12cs character =
    addC12cs character.c12csInitial character.c12csAdvances


setC12c : Int -> C12c -> C12cs -> C12cs
setC12c value c12c c12cs =
    case c12c of
        WS -> { c12cs | ws = value }
        BS -> { c12cs | bs = value }
        S -> { c12cs | s = value }
        T -> { c12cs | t = value }
        I -> { c12cs | i = value }
        Ag -> { c12cs | ag = value }
        Dex -> { c12cs | dex = value }
        Int -> { c12cs | int = value }
        WP -> { c12cs | wp = value }
        Fel -> { c12cs | fel = value }


c12cToString : C12c -> String
c12cToString c12c =
    case c12c of
        WS -> "WS"
        BS -> "BS"
        S -> "S"
        T -> "T"
        I -> "I"
        Ag -> "Ag"
        Dex -> "Dex"
        Int -> "Int"
        WP -> "WP"
        Fel -> "Fel"


c12cToFullString : C12c -> String
c12cToFullString c12c =
    case c12c of
        WS -> "Weapon Skill"
        BS -> "Ballistic Skill"
        S -> "Strength"
        T -> "Toughness"
        I -> "Initiative"
        Ag -> "Agility"
        Dex -> "Dexterity"
        Int -> "Intelligence"
        WP -> "Willpower"
        Fel -> "Fellowship"


c12cFromString : String -> Result String C12c
c12cFromString str =
    case str of
        "WS" -> Ok WS
        "BS" -> Ok BS
        "S" -> Ok S
        "T" -> Ok T
        "I" -> Ok I
        "Ag" -> Ok Ag
        "Dex" -> Ok Dex
        "Int" -> Ok Int
        "WP" -> Ok WP
        "Fel" -> Ok Fel
        _ -> Err ("Cannot make characteristic from '" ++ str ++ "'")


c12csCost : C12cs -> Int
c12csCost c12cs =
    List.foldl
        (\c12c total ->
            total + c12cCost (getC12c c12c c12cs)
        )
        0
        allC12cs


c12cCost : Int -> Int
c12cCost value =
    if value <= 5 then
        25 * value

    else if value <= 10 then
        30 * (value - 5) + 125

    else if value <= 15 then
        40 * (value - 10) + 275

    else if value <= 20 then
        50 * (value - 15) + 475

    else if value <= 25 then
        70 * (value - 20) + 725

    else if value <= 30 then
        90 * (value - 25) + 1075

    else if value <= 35 then
        120 * (value - 30) + 1525

    else if value <= 40 then
        150 * (value - 35) + 2125

    else if value <= 45 then
        190 * (value - 40) + 2875

    else
        230 * (value - 45) + 3825


encodeC12cs : C12cs -> Encode.Value
encodeC12cs c12cs =
    Encode.object
        [ ( "ws", Encode.int c12cs.ws )
        , ( "bs", Encode.int c12cs.bs )
        , ( "s", Encode.int c12cs.s )
        , ( "t", Encode.int c12cs.t )
        , ( "i", Encode.int c12cs.i )
        , ( "ag", Encode.int c12cs.ag )
        , ( "dex", Encode.int c12cs.dex )
        , ( "int", Encode.int c12cs.int )
        , ( "wp", Encode.int c12cs.wp )
        , ( "fel", Encode.int c12cs.fel )
        ]


decodeC12cs : Decode.Decoder C12cs
decodeC12cs =
    Field.require "ws" Decode.int <| \ws ->
    Field.require "bs" Decode.int <| \bs ->
    Field.require "s" Decode.int <| \s ->
    Field.require "t" Decode.int <| \t ->
    Field.require "i" Decode.int <| \i ->
    Field.require "ag" Decode.int <| \ag ->
    Field.require "dex" Decode.int <| \dex ->
    Field.require "int" Decode.int <| \int ->
    Field.require "wp" Decode.int <| \wp ->
    Field.require "fel" Decode.int <| \fel ->
    Decode.succeed
        { ws = ws
        , bs = bs
        , s = s
        , t = t
        , i = i
        , ag = ag
        , dex = dex
        , int = int
        , wp = wp
        , fel = fel
        }


decodeC12c : Decode.Decoder C12c
decodeC12c =
    Decode.andThen
        (c12cFromString >> Json.Decode.Extra.fromResult)
        Decode.string

----------------
-- Experience --
----------------

type alias ExpAdjustment =
    { description : String
    , value : Int
    }


emptyExpAdjustment : ExpAdjustment
emptyExpAdjustment =
    { description = ""
    , value = 0
    }


expAdjustmentsCost : List ExpAdjustment -> Int
expAdjustmentsCost adjustments =
    List.map .value adjustments
        |> List.foldl (+) 0


currentExp : Character -> Int
currentExp character =
    character.experience - spentExp character


spentExp : Character -> Int
spentExp character =
    List.foldl
        (+)
        0
        [ c12csCost character.c12csAdvances
        , skillsCost character.basicSkills
        , skillsCost character.advancedSkills
        , talentsCost character.talents
        , expAdjustmentsCost character.expAdjustments
        ]


encodeExpAdjustment : ExpAdjustment -> Encode.Value
encodeExpAdjustment adjustment =
    Encode.object
        [ ( "description", Encode.string adjustment.description )
        , ( "value", Encode.int adjustment.value )
        ]


decodeExpAdjustment : Decode.Decoder ExpAdjustment
decodeExpAdjustment =
    Decode.map2
        (\description value ->
            { description = description
            , value = value
            }
        )
        (Decode.field "description" Decode.string)
        (Decode.field "value" Decode.int)

-----------------
-- Information --
-----------------

type alias Information =
    { age : String
    , career : String
    , careerPath : String
    , class : String
    , eyes : String
    , hair : String
    , height : String
    , name : String
    , species : String
    , status : String
    }


emptyInformation : Information
emptyInformation =
    { age = ""
    , career = ""
    , careerPath = ""
    , class = ""
    , eyes = ""
    , hair = ""
    , height = ""
    , name = ""
    , species = ""
    , status = ""
    }


setInformation : String -> String -> Information -> Information
setInformation field value info =
    case field of
        "age" -> { info | age = value }
        "career" -> { info | career = value }
        "careerPath" -> { info | careerPath = value }
        "class" -> { info | class = value }
        "eyes" -> { info | eyes = value }
        "hair" -> { info | hair = value }
        "height" -> { info | height = value }
        "name" -> { info | name = value }
        "species" -> { info | species = value }
        "status" -> { info | status = value }
        _ -> info


encodeInformation : Information -> Encode.Value
encodeInformation info =
    Encode.object
        [ ( "age", Encode.string info.age )
        , ( "career", Encode.string info.career )
        , ( "careerPath", Encode.string info.careerPath )
        , ( "class", Encode.string info.class )
        , ( "eyes", Encode.string info.eyes )
        , ( "hair", Encode.string info.hair )
        , ( "height", Encode.string info.height )
        , ( "name", Encode.string info.name )
        , ( "species", Encode.string info.species )
        , ( "status", Encode.string info.status )
        ]


decodeInformation : Decode.Decoder Information
decodeInformation =
    Field.require "age" Decode.string <| \age ->
    Field.require "career" Decode.string <| \career ->
    Field.require "careerPath" Decode.string <| \careerPath ->
    Field.require "class" Decode.string <| \class ->
    Field.require "eyes" Decode.string <| \eyes ->
    Field.require "hair" Decode.string <| \hair ->
    Field.require "height" Decode.string <| \height ->
    Field.require "name" Decode.string <| \name ->
    Field.require "species" Decode.string <| \species ->
    Field.require "status" Decode.string <| \status ->
    Decode.succeed
        { age = age
        , career = career
        , careerPath = careerPath
        , class = class
        , eyes = eyes
        , hair = hair
        , height = height
        , name = name
        , species = species
        , status = status
        }

------------
-- Skills --
------------

type alias Skill =
    { advances : Int
    , c12c : C12c
    , name : String
    }


basicSkillsList : List Skill
basicSkillsList =
    [ { advances = 0
      , c12c = Dex
      , name = "Art"
      }
    , { advances = 0
      , c12c = Ag
      , name = "Athletics"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Bribery"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Charm"
      }
    , { advances = 0
      , c12c = WP
      , name = "Charm Animal"
      }
    , { advances = 0
      , c12c = S
      , name = "Climb"
      }
    , { advances = 0
      , c12c = WP
      , name = "Cool"
      }
    , { advances = 0
      , c12c = T
      , name = "Consume Alcohol"
      }
    , { advances = 0
      , c12c = Ag
      , name = "Dodge"
      }
    , { advances = 0
      , c12c = Ag
      , name = "Drive"
      }
    , { advances = 0
      , c12c = T
      , name = "Endurance"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Entertain"
      }
    , { advances = 0
      , c12c = Int
      , name = "Gamble"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Gossip"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Haggle"
      }
    , { advances = 0
      , c12c = S
      , name = "Intimidate"
      }
    , { advances = 0
      , c12c = I
      , name = "Intuition"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Leadership"
      }
    , { advances = 0
      , c12c = WS
      , name = "Melee (Basic)"
      }
    , { advances = 0
      , c12c = I
      , name = "Navigation"
      }
    , { advances = 0
      , c12c = Int
      , name = "Outdoor Survival"
      }
    , { advances = 0
      , c12c = I
      , name = "Perception"
      }
    , { advances = 0
      , c12c = Ag
      , name = "Ride"
      }
    , { advances = 0
      , c12c = S
      , name = "Row"
      }
    , { advances = 0
      , c12c = Ag
      , name = "Stealth"
      }
    ]


emptySkill : Skill
emptySkill =
    { advances = 0
    , c12c = WS
    , name = ""
    }


skillCost : Int -> Int
skillCost value =
    if value <= 5 then
        10 * value

    else if value <= 10 then
        15 * (value - 5) + 50

    else if value <= 15 then
        20 * (value - 10) + 125

    else if value <= 20 then
        30 * (value - 15) + 225

    else if value <= 25 then
        40 * (value - 20) + 375

    else if value <= 30 then
        60 * (value - 25) + 575

    else if value <= 35 then
        80 * (value - 30) + 875

    else if value <= 40 then
        110 * (value - 35) + 1275

    else if value <= 45 then
        140 * (value - 40) + 1825

    else
        180 * (value - 45) + 2525


skillValue : Character -> Skill -> Int
skillValue character skill =
    getC12c skill.c12c (getC12cs character) + skill.advances


skillsCost : List Skill -> Int
skillsCost skills =
    List.foldl
        (\skill total ->
            total + skillCost skill.advances
        )
        0
        skills


encodeSkill : Skill -> Encode.Value
encodeSkill skill =
    Encode.object
        [ ( "advances", Encode.int skill.advances )
        , ( "c12c", Encode.string (c12cToString skill.c12c) )
        , ( "name", Encode.string skill.name )
        ]


decodeSkill : Decode.Decoder Skill
decodeSkill =
    Decode.map3
        (\advances c12c name ->
            { advances = advances
            , c12c = c12c
            , name = name
            }
        )
        (Decode.field "advances" Decode.int)
        (Decode.field "c12c" decodeC12c)
        (Decode.field "name" Decode.string)

-------------
-- Talents --
-------------

type alias Talent =
    { description : String
    , timesTaken : Int
    , name : String
    }


emptyTalent : Talent
emptyTalent =
    { description = ""
    , timesTaken = 0
    , name = ""
    }


talentsCost : List Talent -> Int
talentsCost talents =
    List.foldl
        (\talent total ->
            total + (talent.timesTaken * (talent.timesTaken + 1) * 50)
        )
        0
        talents


encodeTalent : Talent -> Encode.Value
encodeTalent talent =
    Encode.object
        [ ( "description", Encode.string talent.description )
        , ( "timesTaken", Encode.int talent.timesTaken )
        , ( "name", Encode.string talent.name )
        ]


decodeTalent : Decode.Decoder Talent
decodeTalent =
    Decode.map3
        (\description timesTaken name ->
            { description = description
            , timesTaken = timesTaken
            , name = name
            }
        )
        (Decode.field "description" Decode.string)
        (Decode.field "timesTaken" Decode.int)
        (Decode.field "name" Decode.string)

---------------
-- Trappings --
---------------

type alias Trapping =
    { encumbrance : Int
    , name : String
    }


emptyTrapping : Trapping
emptyTrapping =
    { encumbrance = 0
    , name = ""
    }


encodeTrapping : Trapping -> Encode.Value
encodeTrapping trapping =
    Encode.object
        [ ( "encumbrance", Encode.int trapping.encumbrance )
        , ( "name", Encode.string trapping.name )
        ]


decodeTrapping : Decode.Decoder Trapping
decodeTrapping =
    Decode.map2
        (\encumbrance name ->
            { encumbrance = encumbrance
            , name = name
            }
        )
        (Decode.field "encumbrance" Decode.int)
        (Decode.field "name" Decode.string)

------------
-- Wealth --
------------

type alias Wealth =
    { brass : Int
    , gold : Int
    , silver : Int
    }


emptyWealth : Wealth
emptyWealth =
    { brass = 0
    , gold = 0
    , silver = 0
    }


setGold : Character -> Int -> Character
setGold ({ wealth } as character) value =
    { wealth | gold = value }
        |> setWealth character


setSilver : Character -> Int -> Character
setSilver ({ wealth } as character) value =
    { wealth | silver = value }
        |> setWealth character


setBrass : Character -> Int -> Character
setBrass ({ wealth } as character) value =
    { wealth | brass = value }
        |> setWealth character


setWealth : Character -> Wealth -> Character
setWealth character wealth =
    { character | wealth = wealth }


convertAllSilverToGold : Character -> Character
convertAllSilverToGold ({ wealth } as character) =
    { wealth
        | gold = wealth.gold + wealth.silver // 20
        , silver = modBy 20 wealth.silver
    }
        |> setWealth character


convertOneSilverToGold : Character -> Character
convertOneSilverToGold ({ wealth } as character) =
    if wealth.silver >= 20 then
        { wealth
            | gold = wealth.gold + 1
            , silver = wealth.silver - 20
        }
            |> setWealth character

    else
        character


convertAllBrassToSilver : Character -> Character
convertAllBrassToSilver ({ wealth } as character) =
    { wealth
        | brass = modBy 12 wealth.brass
        , silver = wealth.silver + wealth.brass // 12
    }
        |> setWealth character


convertOneBrassToSilver : Character -> Character
convertOneBrassToSilver ({ wealth } as character) =
    if wealth.brass >= 12 then
        { wealth
            | brass = wealth.brass - 12
            , silver = wealth.silver + 1
        }
            |> setWealth character

    else
        character


convertAllGoldToSilver : Character -> Character
convertAllGoldToSilver ({ wealth } as character) =
    { wealth
        | gold = 0
        , silver = wealth.silver + wealth.gold * 20
    }
        |> setWealth character


convertOneGoldToSilver : Character -> Character
convertOneGoldToSilver ({ wealth } as character) =
    if wealth.gold >= 1 then
        { wealth
            | gold = wealth.gold - 1
            , silver = wealth.silver + 20
        }
            |> setWealth character

    else
        character


convertAllSilverToBrass : Character -> Character
convertAllSilverToBrass ({ wealth } as character) =
    { wealth
        | brass = wealth.brass + wealth.silver * 12
        , silver = 0
    }
        |> setWealth character


convertOneSilverToBrass : Character -> Character
convertOneSilverToBrass ({ wealth } as character) =
    if wealth.silver >= 1 then
        { wealth
            | brass = wealth.brass + 12
            , silver = wealth.silver - 1
        }
            |> setWealth character

    else
        character


encodeWealth : Wealth -> Encode.Value
encodeWealth wealth =
    Encode.object
        [ ( "brass", Encode.int wealth.brass )
        , ( "gold", Encode.int wealth.gold )
        , ( "silver", Encode.int wealth.silver )
        ]


decodeWealth : Decode.Decoder Wealth
decodeWealth =
    Decode.map3
        (\brass gold silver ->
            { brass = brass
            , gold = gold
            , silver = silver
            }
        )
        (Decode.field "brass" Decode.int)
        (Decode.field "gold" Decode.int)
        (Decode.field "silver" Decode.int)
