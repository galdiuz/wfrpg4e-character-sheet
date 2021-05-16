module Character exposing (..)

import Data
import Json.Decode as Decode
import Json.Decode.Extra
import Json.Decode.Field as Field
import Json.Encode as Encode
import List.Extra


type alias Character =
    { advancedSkills : List Skill
    , armour : List Armour
    , ap : ApLocations
    , basicSkills : List Skill
    , c12csAdvances : C12cs
    , c12csInitial : C12cs
    , currentWounds : Int
    , expAdjustments : List ExpAdjustment
    , experience : Int
    , extraWounds : Int
    , fate : Int
    , fortune : Int
    , info : Information
    , maxEncumbrance : Int
    , motivation : String
    , movement : Int
    , notes : List String
    , resilience : Int
    , resolve : Int
    , talents : List Talent
    , trappings : List Trapping
    , wealth : Wealth
    , weapons : List Weapon
    }


emptyCharacter : Character
emptyCharacter =
    { advancedSkills = []
    , armour = []
    , ap = emptyApLocations
    , basicSkills = basicSkillsList
    , c12csAdvances = emptyC12cs
    , c12csInitial = emptyC12cs
    , currentWounds = 0
    , expAdjustments = []
    , experience = 0
    , extraWounds = 0
    , fate = 0
    , fortune = 0
    , info = emptyInformation
    , maxEncumbrance = 0
    , motivation = ""
    , movement = 0
    , notes = []
    , resilience = 0
    , resolve = 0
    , talents = []
    , trappings = []
    , wealth = emptyWealth
    , weapons = []
    }


encodeCharacter : Character -> Encode.Value
encodeCharacter character =
    Encode.object
        [ ( "advancedSkills", Encode.list encodeSkill character.advancedSkills )
        , ( "armour", Encode.list encodeArmour character.armour )
        , ( "ap", encodeAp character.ap )
        , ( "basicSkills", Encode.list encodeSkill character.basicSkills )
        , ( "c12csAdvances", encodeC12cs character.c12csAdvances )
        , ( "c12csInitial", encodeC12cs character.c12csInitial )
        , ( "currentWounds", Encode.int character.currentWounds )
        , ( "expAdjustments", Encode.list encodeExpAdjustment character.expAdjustments )
        , ( "experience", Encode.int character.experience )
        , ( "extraWounds", Encode.int character.extraWounds )
        , ( "fate", Encode.int character.fate )
        , ( "fortune", Encode.int character.fortune )
        , ( "info", encodeInformation character.info )
        , ( "maxEncumbrance", Encode.int character.maxEncumbrance )
        , ( "motivation", Encode.string character.motivation )
        , ( "movement", Encode.int character.movement )
        , ( "notes", Encode.list Encode.string character.notes )
        , ( "resilience", Encode.int character.resilience )
        , ( "resolve", Encode.int character.resolve )
        , ( "talents", Encode.list encodeTalent character.talents )
        , ( "trappings", Encode.list encodeTrapping character.trappings )
        , ( "wealth", encodeWealth character.wealth )
        , ( "weapons", Encode.list encodeWeapon character.weapons )
        ]


decodeCharacter : Decode.Decoder Character
decodeCharacter =
    Field.require "advancedSkills" (Decode.list decodeSkill) <| \advancedSkills ->
    Field.require "armour" (Decode.list decodeArmour) <| \armour ->
    Field.require "ap" decodeAp <| \ap ->
    Field.require "basicSkills" (Decode.list decodeSkill) <| \basicSkills ->
    Field.require "c12csAdvances" decodeC12cs <| \c12csAdvances ->
    Field.require "c12csInitial" decodeC12cs <| \c12csInitial ->
    Field.require "currentWounds" Decode.int <| \currentWounds ->
    Field.require "expAdjustments" (Decode.list decodeExpAdjustment) <| \expAdjustments ->
    Field.require "experience" Decode.int <| \experience ->
    Field.require "extraWounds" Decode.int <| \extraWounds ->
    Field.require "fate" Decode.int <| \fate ->
    Field.require "fortune" Decode.int <| \fortune ->
    Field.require "info" decodeInformation <| \info ->
    Field.require "maxEncumbrance" Decode.int <| \maxEncumbrance ->
    Field.require "motivation" Decode.string <| \motivation ->
    Field.require "movement" Decode.int <| \movement ->
    Field.require "notes" (Decode.list Decode.string) <| \notes ->
    Field.require "resilience" Decode.int <| \resilience ->
    Field.require "resolve" Decode.int <| \resolve ->
    Field.require "talents" (Decode.list decodeTalent) <| \talents ->
    Field.require "trappings" (Decode.list decodeTrapping) <| \trappings ->
    Field.require "wealth" decodeWealth <| \wealth ->
    Field.require "weapons" (Decode.list decodeWeapon) <| \weapons ->
    Decode.succeed
        { advancedSkills = advancedSkills
        , armour = armour
        , ap = ap
        , basicSkills = basicSkills
        , c12csAdvances = c12csAdvances
        , c12csInitial = c12csInitial
        , currentWounds = currentWounds
        , expAdjustments = expAdjustments
        , experience = experience
        , extraWounds = extraWounds
        , fate = fate
        , fortune = fortune
        , info = info
        , maxEncumbrance = maxEncumbrance
        , motivation = motivation
        , movement = movement
        , notes = notes
        , resilience = resilience
        , resolve = resolve
        , talents = talents
        , trappings = trappings
        , wealth = wealth
        , weapons = weapons
        }


minMax : Int -> Int -> Int -> Int
minMax min max value =
    Basics.min max (Basics.max min value)


getBonus : Int -> Int
getBonus value =
    value // 10

------------
-- Armour --
------------

type alias Armour =
    { ap : Int
    , encumbrance : Int
    , locations : String
    , name : String
    , qualities : String
    }


emptyArmour : Armour
emptyArmour =
    { ap = 0
    , encumbrance = 0
    , locations = ""
    , name = ""
    , qualities = ""
    }


type ApLocation
    = Body
    | Head
    | LeftArm
    | LeftLeg
    | RightArm
    | RightLeg
    | Shield


type alias ApLocations =
    { body : Int
    , head : Int
    , leftArm : Int
    , leftLeg : Int
    , rightArm : Int
    , rightLeg : Int
    , shield : Int
    }


emptyApLocations : ApLocations
emptyApLocations =
    { body = 0
    , head = 0
    , leftArm = 0
    , leftLeg = 0
    , rightArm = 0
    , rightLeg = 0
    , shield = 0
    }


addArmour : Character -> Character
addArmour character =
    { character | armour = character.armour ++ [ emptyArmour ] }


setAp : ApLocation -> Int -> Character -> Character
setAp apLocation value ({ ap } as character) =
    { character
        | ap =
            case apLocation of
                Body -> { ap | body = value }
                Head -> { ap | head = value }
                LeftArm -> { ap | leftArm = value }
                LeftLeg -> { ap | leftLeg = value }
                RightArm -> { ap | rightArm = value }
                RightLeg -> { ap | rightLeg = value }
                Shield -> { ap | shield = value }
    }


setArmourAp : Int -> Int -> Character -> Character
setArmourAp index value character =
    { character |
        armour =
            List.Extra.updateAt
                index
                (\armour ->
                    { armour | ap = max 0 value }
                )
                character.armour
    }


setArmourEncumbrance : Int -> Int -> Character -> Character
setArmourEncumbrance index value character =
    { character |
        armour =
            List.Extra.updateAt
                index
                (\armour ->
                    { armour | encumbrance = max 0 value }
                )
                character.armour
    }


setArmourLocations : Int -> String -> Character -> Character
setArmourLocations index value character =
    { character |
        armour =
            List.Extra.updateAt
                index
                (\armour ->
                    { armour | locations = value }
                )
                character.armour
    }


setArmourName : Int -> String -> Character -> Character
setArmourName index value character =
    { character |
        armour =
            List.Extra.updateAt
                index
                (\armour ->
                    { armour | name = value }
                )
                character.armour
    }


setArmourQualities : Int -> String -> Character -> Character
setArmourQualities index value character =
    { character |
        armour =
            List.Extra.updateAt
                index
                (\armour ->
                    { armour | qualities = value }
                )
                character.armour
    }


encodeArmour : Armour -> Encode.Value
encodeArmour armour =
    Encode.object
        [ ( "ap", Encode.int armour.ap )
        , ( "encumbrance", Encode.int armour.encumbrance )
        , ( "locations", Encode.string armour.locations )
        , ( "name", Encode.string armour.name )
        , ( "qualities", Encode.string armour.qualities )
        ]


encodeAp : ApLocations -> Encode.Value
encodeAp ap =
    Encode.object
        [ ( "body", Encode.int ap.body )
        , ( "head", Encode.int ap.head )
        , ( "leftArm", Encode.int ap.leftArm )
        , ( "leftLeg", Encode.int ap.leftLeg )
        , ( "rightArm", Encode.int ap.rightArm )
        , ( "rightLeg", Encode.int ap.rightLeg )
        , ( "shield", Encode.int ap.shield )
        ]


decodeArmour : Decode.Decoder Armour
decodeArmour =
    Decode.map5
        (\ap encumbrance locations name qualities ->
            { ap = ap
            , encumbrance = encumbrance
            , locations = locations
            , name = name
            , qualities = qualities
            }
        )
        (Decode.field "ap" Decode.int)
        (Decode.field "encumbrance" Decode.int)
        (Decode.field "locations" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "qualities" Decode.string)


decodeAp : Decode.Decoder ApLocations
decodeAp =
    Decode.map7
        (\body head leftArm leftLeg rightArm rightLeg shield ->
            { body = body
            , head = head
            , leftArm = leftArm
            , leftLeg = leftLeg
            , rightArm = rightArm
            , rightLeg = rightLeg
            , shield = shield
            }
        )
        (Decode.field "body" Decode.int)
        (Decode.field "head" Decode.int)
        (Decode.field "leftArm" Decode.int)
        (Decode.field "leftLeg" Decode.int)
        (Decode.field "rightArm" Decode.int)
        (Decode.field "rightLeg" Decode.int)
        (Decode.field "shield" Decode.int)

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


setC12csAdvances : C12c -> Int -> Character -> Character
setC12csAdvances c12c value character =
    { character | c12csAdvances = setC12c (minMax 0 99 value) c12c character.c12csAdvances }


setC12csInitial : C12c -> Int -> Character -> Character
setC12csInitial c12c value character =
    { character | c12csInitial = setC12c (minMax 0 99 value) c12c character.c12csInitial }


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

-----------------
-- Encumbrance --
-----------------

armourEncumbrance : Character -> Int
armourEncumbrance character =
    List.foldl
        ((+) << .encumbrance)
        0
        character.armour


totalEncumbrance : Character -> Int
totalEncumbrance character =
    armourEncumbrance character + trappingsEncumbrance character + weaponEncumbrance character


trappingsEncumbrance : Character -> Int
trappingsEncumbrance character =
    List.foldl
        ((+) << .encumbrance)
        0
        character.trappings


weaponEncumbrance : Character -> Int
weaponEncumbrance character =
    List.foldl
        ((+) << .encumbrance)
        0
        character.weapons


setMaxEncumbrance : Int -> Character -> Character
setMaxEncumbrance value character =
    { character | maxEncumbrance = Basics.max 0 value }

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


addExpAdjustment : Character -> Character
addExpAdjustment character =
    { character | expAdjustments = character.expAdjustments ++ [ emptyExpAdjustment ] }


setExperience : Int -> Character -> Character
setExperience value character =
    { character | experience = max 0 value }


setExpAdjustmentDescription : Int -> String -> Character -> Character
setExpAdjustmentDescription index value character =
    { character
        | expAdjustments =
            List.Extra.updateAt
                index
                (\expAdjustment ->
                    { expAdjustment | description = value }
                )
                character.expAdjustments
    }


setExpAdjustmentValue : Int -> Int -> Character -> Character
setExpAdjustmentValue index value character =
    { character
        | expAdjustments =
            List.Extra.updateAt
                index
                (\expAdjustment ->
                    { expAdjustment | value = value }
                )
                character.expAdjustments
    }


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

-----------------------
-- Fate & Resilience --
-----------------------

setFate : Int -> Character -> Character
setFate value character =
    { character | fate = max 0 value }


setFortune : Int -> Character -> Character
setFortune value character =
    { character | fortune = max 0 value }


setMotivation : String -> Character -> Character
setMotivation value character =
    { character | motivation = value }


setResilience: Int -> Character -> Character
setResilience value character =
    { character | resilience = max 0 value }


setResolve : Int -> Character -> Character
setResolve value character =
    { character | resolve = max 0 value }

-----------------
-- Information --
-----------------

type alias Information =
    { age : String
    , career : String
    , careerLevel : String
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
    , careerLevel = ""
    , careerPath = ""
    , class = ""
    , eyes = ""
    , hair = ""
    , height = ""
    , name = ""
    , species = ""
    , status = ""
    }


type InformationField
    = Age
    | Career
    | CareerLevel
    | CareerPath
    | Class
    | Eyes
    | Hair
    | Height
    | Name
    | Species
    | Status


setInformation : InformationField -> String -> Character -> Character
setInformation field value ({ info } as character) =
    { character
        | info =
            case field of
                Age -> { info | age = value }
                Career -> { info | career = value }
                CareerLevel ->
                    { info
                        | careerLevel = value
                        , status =
                            Data.getStatus info.class info.career value
                                |> Maybe.withDefault info.status
                    }
                CareerPath -> { info | careerPath = value }
                Class -> { info | class = value }
                Eyes -> { info | eyes = value }
                Hair -> { info | hair = value }
                Height -> { info | height = value }
                Name -> { info | name = value }
                Species -> { info | species = value }
                Status -> { info | status = value }
    }


encodeInformation : Information -> Encode.Value
encodeInformation info =
    Encode.object
        [ ( "age", Encode.string info.age )
        , ( "career", Encode.string info.career )
        , ( "careerLevel", Encode.string info.careerLevel )
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
    Field.require "careerLevel" Decode.string <| \careerLevel ->
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
        , careerLevel = careerLevel
        , careerPath = careerPath
        , class = class
        , eyes = eyes
        , hair = hair
        , height = height
        , name = name
        , species = species
        , status = status
        }

--------------
-- Movement --
--------------

setMovement : Int -> Character -> Character
setMovement value character =
    { character | movement = max 0 value }


run : Character -> Int
run character =
    character.movement * 4


walk : Character -> Int
walk character =
    character.movement * 2

-----------
-- Notes --
-----------

addNote : Character -> Character
addNote character =
    { character | notes = character.notes ++ [ "" ] }


setNote : Int -> String -> Character -> Character
setNote index value character =
    { character
        | notes =
            List.Extra.setAt
                index
                value
                character.notes
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


addAdvancedSkill : Character -> Character
addAdvancedSkill character =
    { character | advancedSkills = character.advancedSkills ++ [ emptySkill ] }


setAdvancedSkillAdvances : Int -> Int -> Character -> Character
setAdvancedSkillAdvances index value character =
    { character
        | advancedSkills =
            List.Extra.updateAt
                index
                (\skill ->
                    { skill | advances = minMax 0 99 value }
                )
                character.advancedSkills
    }


setAdvancedSkillC12c : Int -> C12c -> Character -> Character
setAdvancedSkillC12c index value character =
    { character
        | advancedSkills =
            List.Extra.updateAt
                index
                (\skill ->
                    { skill | c12c = value }
                )
                character.advancedSkills
    }


setAdvancedSkillC12cFromString : Int -> String -> Character -> Character
setAdvancedSkillC12cFromString index str character =
    case c12cFromString str of
        Ok c12c ->
            setAdvancedSkillC12c index c12c character

        Err _ ->
            character


setAdvancedSkillName : Int -> String -> Character -> Character
setAdvancedSkillName index value character =
    { character
        | advancedSkills =
            List.Extra.updateAt
                index
                (\skill ->
                    { skill | name = value }
                )
                character.advancedSkills
    }


setBasicSkillAdvances : Int -> Int -> Character -> Character
setBasicSkillAdvances index value character =
    { character
        | basicSkills =
            List.Extra.updateAt
                index
                (\skill ->
                    { skill | advances = minMax 0 99 value }
                )
                character.basicSkills
    }


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


addTalent : Character -> Character
addTalent character =
    { character | talents = character.talents ++ [ emptyTalent ] }


setTalentDescription : Int -> String -> Character -> Character
setTalentDescription index value character =
    { character
        | talents =
            List.Extra.updateAt
                index
                (\talent ->
                    { talent | description = value }
                )
                character.talents
    }


setTalentName : Int -> String -> Character -> Character
setTalentName index value character =
    { character
        | talents =
            List.Extra.updateAt
                index
                (\talent ->
                    { talent | name = value }
                )
                character.talents
    }


setTalentTimesTaken : Int -> Int -> Character -> Character
setTalentTimesTaken index value character =
    { character
        | talents =
            List.Extra.updateAt
                index
                (\talent ->
                    { talent | timesTaken = minMax 0 99 value }
                )
                character.talents
    }


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


addTrapping : Character -> Character
addTrapping character =
    { character | trappings = character.trappings ++ [ emptyTrapping ] }


setTrappingEncumbrance : Int -> Int -> Character -> Character
setTrappingEncumbrance index value character =
    { character
        | trappings =
            List.Extra.updateAt
                index
                (\trapping ->
                    { trapping | encumbrance = minMax 0 99 value }
                )
                character.trappings
    }


setTrappingName : Int -> String -> Character -> Character
setTrappingName index value character =
    { character
        | trappings =
            List.Extra.updateAt
                index
                (\trapping ->
                    { trapping | name = value }
                )
                character.trappings
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


setGold : Int -> Character -> Character
setGold value ({ wealth } as character) =
    { wealth | gold = max 0 value }
        |> asWealthIn character


setSilver : Int -> Character -> Character
setSilver value ({ wealth } as character) =
    { wealth | silver = max 0 value }
        |> asWealthIn character


setBrass : Int -> Character -> Character
setBrass value ({ wealth } as character) =
    { wealth | brass = max 0 value }
        |> asWealthIn character


asWealthIn : Character -> Wealth -> Character
asWealthIn character wealth =
    { character | wealth = wealth }


convertAllSilverToGold : Character -> Character
convertAllSilverToGold ({ wealth } as character) =
    { wealth
        | gold = wealth.gold + wealth.silver // 20
        , silver = modBy 20 wealth.silver
    }
        |> asWealthIn character


convertOneSilverToGold : Character -> Character
convertOneSilverToGold ({ wealth } as character) =
    if wealth.silver >= 20 then
        { wealth
            | gold = wealth.gold + 1
            , silver = wealth.silver - 20
        }
            |> asWealthIn character

    else
        character


convertAllBrassToSilver : Character -> Character
convertAllBrassToSilver ({ wealth } as character) =
    { wealth
        | brass = modBy 12 wealth.brass
        , silver = wealth.silver + wealth.brass // 12
    }
        |> asWealthIn character


convertOneBrassToSilver : Character -> Character
convertOneBrassToSilver ({ wealth } as character) =
    if wealth.brass >= 12 then
        { wealth
            | brass = wealth.brass - 12
            , silver = wealth.silver + 1
        }
            |> asWealthIn character

    else
        character


convertAllGoldToSilver : Character -> Character
convertAllGoldToSilver ({ wealth } as character) =
    { wealth
        | gold = 0
        , silver = wealth.silver + wealth.gold * 20
    }
        |> asWealthIn character


convertOneGoldToSilver : Character -> Character
convertOneGoldToSilver ({ wealth } as character) =
    if wealth.gold >= 1 then
        { wealth
            | gold = wealth.gold - 1
            , silver = wealth.silver + 20
        }
            |> asWealthIn character

    else
        character


convertAllSilverToBrass : Character -> Character
convertAllSilverToBrass ({ wealth } as character) =
    { wealth
        | brass = wealth.brass + wealth.silver * 12
        , silver = 0
    }
        |> asWealthIn character


convertOneSilverToBrass : Character -> Character
convertOneSilverToBrass ({ wealth } as character) =
    if wealth.silver >= 1 then
        { wealth
            | brass = wealth.brass + 12
            , silver = wealth.silver - 1
        }
            |> asWealthIn character

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

-------------
-- Weapons --
-------------

type alias Weapon =
    { damage : String
    , encumbrance : Int
    , group : String
    , name : String
    , qualities : String
    , range : String
    }


emptyWeapon : Weapon
emptyWeapon =
    { damage = ""
    , encumbrance = 0
    , group = ""
    , name = ""
    , qualities = ""
    , range = ""
    }


addWeapon : Character -> Character
addWeapon character =
    { character | weapons = character.weapons ++ [ emptyWeapon ] }


setWeaponDamage : Int -> String -> Character -> Character
setWeaponDamage index value character =
    { character |
        weapons =
            List.Extra.updateAt
                index
                (\weapon ->
                    { weapon | damage = value }
                )
                character.weapons
    }


setWeaponEncumbrance : Int -> Int -> Character -> Character
setWeaponEncumbrance index value character =
    { character |
        weapons =
            List.Extra.updateAt
                index
                (\weapon ->
                    { weapon | encumbrance = minMax 0 99 value }
                )
                character.weapons
    }


setWeaponGroup : Int -> String -> Character -> Character
setWeaponGroup index value character =
    { character |
        weapons =
            List.Extra.updateAt
                index
                (\weapon ->
                    { weapon | group = value }
                )
                character.weapons
    }


setWeaponName : Int -> String -> Character -> Character
setWeaponName index value character =
    { character |
        weapons =
            List.Extra.updateAt
                index
                (\weapon ->
                    { weapon | name = value }
                )
                character.weapons
    }


setWeaponQualities : Int -> String -> Character -> Character
setWeaponQualities index value character =
    { character |
        weapons =
            List.Extra.updateAt
                index
                (\weapon ->
                    { weapon | qualities = value }
                )
                character.weapons
    }


setWeaponRange : Int -> String -> Character -> Character
setWeaponRange index value character =
    { character |
        weapons =
            List.Extra.updateAt
                index
                (\weapon ->
                    { weapon | range = value }
                )
                character.weapons
    }


encodeWeapon : Weapon -> Encode.Value
encodeWeapon weapon =
    Encode.object
        [ ( "damage", Encode.string weapon.damage )
        , ( "encumbrance", Encode.int weapon.encumbrance )
        , ( "group", Encode.string weapon.group )
        , ( "name", Encode.string weapon.name )
        , ( "qualities", Encode.string weapon.qualities )
        , ( "range", Encode.string weapon.range )
        ]


decodeWeapon : Decode.Decoder Weapon
decodeWeapon =
    Decode.map6
        (\damage encumbrance group name qualities range ->
            { damage = damage
            , encumbrance = encumbrance
            , group = group
            , name = name
            , qualities = qualities
            , range = range
            }
        )
        (Decode.field "damage" Decode.string)
        (Decode.field "encumbrance" Decode.int)
        (Decode.field "group" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "qualities" Decode.string)
        (Decode.field "range" Decode.string)

------------
-- Wounds --
------------

getWounds : Character -> Int
getWounds character =
    let
        c12cBonus c12c =
            getBonus (getC12c c12c (getC12cs character))
    in
    c12cBonus S + c12cBonus T * 2 + c12cBonus WP + character.extraWounds


setCurrentWounds : Int -> Character -> Character
setCurrentWounds value character =
    { character | currentWounds = max 0 value }


setExtraWounds : Int -> Character -> Character
setExtraWounds value character =
    { character | extraWounds = max 0 value }
