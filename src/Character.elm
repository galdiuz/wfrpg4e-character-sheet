module Character exposing (..)

import Data
import Json.Decode as Decode
import Json.Decode.Extra
import Json.Decode.Field as Field
import Json.Encode as Encode
import List.Extra
import OrderedDict exposing (OrderedDict)


type alias Character =
    { advancedSkills : OrderedDict Int Skill
    , armour : OrderedDict Int Armour
    , ap : Ap
    , basicSkills : List Skill
    , c12csAdvances : C12cs
    , c12csInitial : C12cs
    , corruption : Int
    , currentWounds : Int
    , expAdjustments : OrderedDict Int ExpAdjustment
    , experience : Int
    , extraWounds : Int
    , fate : Int
    , fortune : Int
    , info : Information
    , injuries : OrderedDict Int Injury
    , maxEncumbrance : Int
    , motivation : String
    , movement : Int
    , mutations : OrderedDict Int Mutation
    , notes : OrderedDict Int String
    , resilience : Int
    , resolve : Int
    , spells : OrderedDict Int Spell
    , talents : OrderedDict Int Talent
    , trappings : OrderedDict Int Trapping
    , wealth : Wealth
    , weapons : OrderedDict Int Weapon
    }


emptyCharacter : Character
emptyCharacter =
    { advancedSkills = OrderedDict.empty
    , armour = OrderedDict.empty
    , ap = emptyApLocations
    , basicSkills = basicSkillsList
    , c12csAdvances = emptyC12cs
    , c12csInitial = emptyC12cs
    , corruption = 0
    , currentWounds = 0
    , expAdjustments = OrderedDict.empty
    , experience = 0
    , extraWounds = 0
    , fate = 0
    , fortune = 0
    , info = emptyInformation
    , injuries = OrderedDict.empty
    , maxEncumbrance = 0
    , motivation = ""
    , movement = 0
    , mutations = OrderedDict.empty
    , notes = OrderedDict.empty
    , resilience = 0
    , resolve = 0
    , spells = OrderedDict.empty
    , talents = OrderedDict.empty
    , trappings = OrderedDict.empty
    , wealth = emptyWealth
    , weapons = OrderedDict.empty
    }


encodeCharacter : Character -> Encode.Value
encodeCharacter character =
    Encode.object
        [ ( "advancedSkills", Encode.list encodeSkill (OrderedDict.values character.advancedSkills) )
        , ( "armour", Encode.list encodeArmour (OrderedDict.values character.armour) )
        , ( "ap", encodeAp character.ap )
        , ( "basicSkills", Encode.list encodeSkill character.basicSkills )
        , ( "c12csAdvances", encodeC12cs character.c12csAdvances )
        , ( "c12csInitial", encodeC12cs character.c12csInitial )
        , ( "corruption", Encode.int character.corruption )
        , ( "currentWounds", Encode.int character.currentWounds )
        , ( "expAdjustments", Encode.list encodeExpAdjustment (OrderedDict.values character.expAdjustments) )
        , ( "experience", Encode.int character.experience )
        , ( "extraWounds", Encode.int character.extraWounds )
        , ( "fate", Encode.int character.fate )
        , ( "fortune", Encode.int character.fortune )
        , ( "info", encodeInformation character.info )
        , ( "injuries", Encode.list encodeInjury (OrderedDict.values character.injuries) )
        , ( "maxEncumbrance", Encode.int character.maxEncumbrance )
        , ( "motivation", Encode.string character.motivation )
        , ( "movement", Encode.int character.movement )
        , ( "mutations", Encode.list encodeMutation (OrderedDict.values character.mutations) )
        , ( "notes", Encode.list Encode.string (OrderedDict.values character.notes) )
        , ( "resilience", Encode.int character.resilience )
        , ( "resolve", Encode.int character.resolve )
        , ( "spells", Encode.list encodeSpell (OrderedDict.values character.spells) )
        , ( "talents", Encode.list encodeTalent (OrderedDict.values character.talents) )
        , ( "trappings", Encode.list encodeTrapping (OrderedDict.values character.trappings) )
        , ( "wealth", encodeWealth character.wealth )
        , ( "weapons", Encode.list encodeWeapon (OrderedDict.values character.weapons) )
        ]


decodeCharacter : Decode.Decoder Character
decodeCharacter =
    Field.require "advancedSkills" (OrderedDict.decode decodeSkill) <| \advancedSkills ->
    Field.require "armour" (OrderedDict.decode decodeArmour) <| \armour ->
    Field.require "ap" decodeAp <| \ap ->
    Field.require "basicSkills" (Decode.list decodeSkill) <| \basicSkills ->
    Field.require "c12csAdvances" decodeC12cs <| \c12csAdvances ->
    Field.require "c12csInitial" decodeC12cs <| \c12csInitial ->
    Field.require "corruption" Decode.int <| \corruption ->
    Field.require "currentWounds" Decode.int <| \currentWounds ->
    Field.require "expAdjustments" (OrderedDict.decode decodeExpAdjustment) <| \expAdjustments ->
    Field.require "experience" Decode.int <| \experience ->
    Field.require "extraWounds" Decode.int <| \extraWounds ->
    Field.require "fate" Decode.int <| \fate ->
    Field.require "fortune" Decode.int <| \fortune ->
    Field.require "info" decodeInformation <| \info ->
    Field.require "injuries" (OrderedDict.decode decodeInjury) <| \injuries ->
    Field.require "maxEncumbrance" Decode.int <| \maxEncumbrance ->
    Field.require "motivation" Decode.string <| \motivation ->
    Field.require "movement" Decode.int <| \movement ->
    Field.require "mutations" (OrderedDict.decode decodeMutation) <| \mutations ->
    Field.require "notes" (OrderedDict.decode Decode.string) <| \notes ->
    Field.require "resilience" Decode.int <| \resilience ->
    Field.require "resolve" Decode.int <| \resolve ->
    Field.require "spells" (OrderedDict.decode decodeSpell) <| \spells ->
    Field.require "talents" (OrderedDict.decode decodeTalent) <| \talents ->
    Field.require "trappings" (OrderedDict.decode decodeTrapping) <| \trappings ->
    Field.require "wealth" decodeWealth <| \wealth ->
    Field.require "weapons" (OrderedDict.decode decodeWeapon) <| \weapons ->
    Decode.succeed
        { advancedSkills = advancedSkills
        , armour = armour
        , ap = ap
        , basicSkills = basicSkills
        , c12csAdvances = c12csAdvances
        , c12csInitial = c12csInitial
        , corruption = corruption
        , currentWounds = currentWounds
        , expAdjustments = expAdjustments
        , experience = experience
        , extraWounds = extraWounds
        , fate = fate
        , fortune = fortune
        , info = info
        , injuries = injuries
        , maxEncumbrance = maxEncumbrance
        , motivation = motivation
        , movement = movement
        , mutations = mutations
        , notes = notes
        , resilience = resilience
        , resolve = resolve
        , spells = spells
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


type alias Ap =
    { body : Int
    , head : Int
    , leftArm : Int
    , leftLeg : Int
    , rightArm : Int
    , rightLeg : Int
    , shield : Int
    }


emptyApLocations : Ap
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
    { character | armour = OrderedDict.insert emptyArmour character.armour }


removeArmour : Int -> Character -> Character
removeArmour id character =
    { character | armour = OrderedDict.remove id character.armour }


setAp : BodyLocation -> Int -> Character -> Character
setAp location value ({ ap } as character) =
    { character
        | ap =
            case location of
                Body -> { ap | body = value }
                Head -> { ap | head = value }
                LeftArm -> { ap | leftArm = value }
                LeftLeg -> { ap | leftLeg = value }
                RightArm -> { ap | rightArm = value }
                RightLeg -> { ap | rightLeg = value }
                Shield -> { ap | shield = value }
    }


setArmourAp : Int -> Int -> Character -> Character
setArmourAp id value character =
    { character |
        armour =
            OrderedDict.update
                id
                (\armour ->
                    { armour | ap = max 0 value }
                )
                character.armour
    }


setArmourEncumbrance : Int -> Int -> Character -> Character
setArmourEncumbrance id value character =
    { character |
        armour =
            OrderedDict.update
                id
                (\armour ->
                    { armour | encumbrance = max 0 value }
                )
                character.armour
    }


setArmourLocations : Int -> String -> Character -> Character
setArmourLocations id value character =
    { character |
        armour =
            OrderedDict.update
                id
                (\armour ->
                    { armour | locations = value }
                )
                character.armour
    }


setArmourName : Int -> String -> Character -> Character
setArmourName id value character =
    { character |
        armour =
            OrderedDict.update
                id
                (\armour ->
                    { armour | name = value }
                )
                character.armour
    }


setArmourQualities : Int -> String -> Character -> Character
setArmourQualities id value character =
    { character |
        armour =
            OrderedDict.update
                id
                (\armour ->
                    { armour | qualities = value }
                )
                character.armour
    }


setArmourOrder : List Int -> Character -> Character
setArmourOrder order character =
    { character | armour = OrderedDict.setOrder order character.armour }


encodeArmour : Armour -> Encode.Value
encodeArmour armour =
    Encode.object
        [ ( "ap", Encode.int armour.ap )
        , ( "encumbrance", Encode.int armour.encumbrance )
        , ( "locations", Encode.string armour.locations )
        , ( "name", Encode.string armour.name )
        , ( "qualities", Encode.string armour.qualities )
        ]


encodeAp : Ap -> Encode.Value
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


decodeAp : Decode.Decoder Ap
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
        _ -> Err ("Cannot make characteristic from '" ++ str ++ "'.")


c12csCost : C12cs -> Int
c12csCost c12cs =
    allC12cs
        |> List.map (\c12c -> c12cCost (getC12c c12c c12cs))
        |> List.sum


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

----------------
-- Corruption --
----------------

type alias Mutation =
    { description : String
    , effect : String
    , kind : MutationKind
    }


type MutationKind
    = Mental
    | Physical


allMutationKinds =
    [ Physical
    , Mental
    ]


emptyMutation : Mutation
emptyMutation =
    { description = ""
    , effect = ""
    , kind = Physical
    }


mutationThreshold : Character -> Int
mutationThreshold character =
    getBonus (getC12c T (getC12cs character)) + getBonus (getC12c WP (getC12cs character))


mutationKindToString : MutationKind -> String
mutationKindToString kind =
    case kind of
        Mental -> "Mental"
        Physical -> "Physical"


mutationKindFromString : String -> Result String MutationKind
mutationKindFromString str =
    case str of
        "Mental" -> Ok Mental
        "Physical" -> Ok Physical
        _ -> Err ("Cannot make mutation kind from '" ++ str ++ "'.")


addMutation : Character -> Character
addMutation character =
    { character | mutations = OrderedDict.insert emptyMutation character.mutations }


removeMutation : Int -> Character -> Character
removeMutation id character =
    { character | mutations = OrderedDict.remove id character.mutations }


setCorruption : Int -> Character -> Character
setCorruption value character =
    { character | corruption = max 0 value }


setMutationDescription : Int -> String -> Character -> Character
setMutationDescription id value character =
    { character |
        mutations =
            OrderedDict.update
                id
                (\mutation ->
                    { mutation | description = value }
                )
                character.mutations
    }


setMutationEffect : Int -> String -> Character -> Character
setMutationEffect id value character =
    { character |
        mutations =
            OrderedDict.update
                id
                (\mutation ->
                    { mutation | effect = value }
                )
                character.mutations
    }


setMutationKind : Int -> MutationKind -> Character -> Character
setMutationKind id value character =
    { character |
        mutations =
            OrderedDict.update
                id
                (\mutation ->
                    { mutation | kind = value }
                )
                character.mutations
    }


setMutationKindFromString : Int -> String -> Character -> Character
setMutationKindFromString id str character =
    case mutationKindFromString str of
        Ok kind ->
            setMutationKind id kind character

        Err _ ->
            character


setMutationsOrder : List Int -> Character -> Character
setMutationsOrder order character =
    { character | mutations = OrderedDict.setOrder order character.mutations }


encodeMutation : Mutation -> Encode.Value
encodeMutation mutation =
    Encode.object
        [ ( "description", Encode.string mutation.description )
        , ( "effect", Encode.string mutation.effect )
        , ( "kind", Encode.string (mutationKindToString mutation.kind) )
        ]


decodeMutation : Decode.Decoder Mutation
decodeMutation =
    Decode.map3
        (\description effect kind ->
            { description = description
            , effect = effect
            , kind = kind
            }
        )
        (Decode.field "description" Decode.string)
        (Decode.field "effect" Decode.string)
        (Decode.field "kind" decodeMutationKind)


decodeMutationKind : Decode.Decoder MutationKind
decodeMutationKind =
    Decode.andThen
        (mutationKindFromString >> Json.Decode.Extra.fromResult)
        Decode.string

-----------------
-- Encumbrance --
-----------------

sumEncumbrance : OrderedDict Int { a | encumbrance : Int } -> Int
sumEncumbrance dict =
    OrderedDict.values dict
        |> List.map .encumbrance
        |> List.sum


totalEncumbrance : Character -> Int
totalEncumbrance character =
    List.sum
        [ sumEncumbrance character.armour
        , sumEncumbrance character.trappings
        , sumEncumbrance character.weapons
        ]


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
    adjustments
        |> List.map .value
        |> List.sum


currentExp : Character -> Int
currentExp character =
    character.experience - spentExp character


spentExp : Character -> Int
spentExp character =
    List.sum
        [ c12csCost character.c12csAdvances
        , skillsCost character.basicSkills
        , skillsCost (OrderedDict.values character.advancedSkills)
        , talentsCost (OrderedDict.values character.talents)
        , expAdjustmentsCost (OrderedDict.values character.expAdjustments)
        ]


addExpAdjustment : Character -> Character
addExpAdjustment character =
    { character | expAdjustments = OrderedDict.insert emptyExpAdjustment character.expAdjustments }


removeExpAdjustment : Int -> Character -> Character
removeExpAdjustment id character =
    { character | expAdjustments = OrderedDict.remove id character.expAdjustments }


setExperience : Int -> Character -> Character
setExperience value character =
    { character | experience = max 0 value }


setExpAdjustmentDescription : Int -> String -> Character -> Character
setExpAdjustmentDescription id value character =
    { character
        | expAdjustments =
            OrderedDict.update
                id
                (\expAdjustment ->
                    { expAdjustment | description = value }
                )
                character.expAdjustments
    }


setExpAdjustmentValue : Int -> Int -> Character -> Character
setExpAdjustmentValue id value character =
    { character
        | expAdjustments =
            OrderedDict.update
                id
                (\expAdjustment ->
                    { expAdjustment | value = value }
                )
                character.expAdjustments
    }


setExpAdjustmentsOrder : List Int -> Character -> Character
setExpAdjustmentsOrder order character =
    { character | expAdjustments = OrderedDict.setOrder order character.expAdjustments }


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
    { character | notes = OrderedDict.insert "" character.notes }


removeNote : Int -> Character -> Character
removeNote id character =
    { character | notes = OrderedDict.remove id character.notes }


setNote : Int -> String -> Character -> Character
setNote id value character =
    { character
        | notes =
            OrderedDict.update
                id
                (\_ -> value)
                character.notes
    }


setNotesOrder : List Int -> Character -> Character
setNotesOrder order character =
    { character | notes = OrderedDict.setOrder order character.notes }

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
    skills
        |> List.map .advances
        |> List.map skillCost
        |> List.sum


addAdvancedSkill : Character -> Character
addAdvancedSkill character =
    { character | advancedSkills = OrderedDict.insert emptySkill character.advancedSkills }


removeAdvancedSkill : Int -> Character -> Character
removeAdvancedSkill id character =
    { character | advancedSkills = OrderedDict.remove id character.advancedSkills }


setAdvancedSkillAdvances : Int -> Int -> Character -> Character
setAdvancedSkillAdvances id value character =
    { character
        | advancedSkills =
            OrderedDict.update
                id
                (\skill ->
                    { skill | advances = minMax 0 99 value }
                )
                character.advancedSkills
    }


setAdvancedSkillC12c : Int -> C12c -> Character -> Character
setAdvancedSkillC12c id value character =
    { character
        | advancedSkills =
            OrderedDict.update
                id
                (\skill ->
                    { skill | c12c = value }
                )
                character.advancedSkills
    }


setAdvancedSkillC12cFromString : Int -> String -> Character -> Character
setAdvancedSkillC12cFromString id str character =
    case c12cFromString str of
        Ok c12c ->
            setAdvancedSkillC12c id c12c character

        Err _ ->
            character


setAdvancedSkillName : Int -> String -> Character -> Character
setAdvancedSkillName id value character =
    { character
        | advancedSkills =
            OrderedDict.update
                id
                (\skill ->
                    { skill | name = value }
                )
                character.advancedSkills
    }


setAdvancedSkillsOrder : List Int -> Character -> Character
setAdvancedSkillsOrder order character =
    { character | advancedSkills = OrderedDict.setOrder order character.advancedSkills }


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

------------
-- Spells --
------------

type alias Spell =
    { cn : Int
    , duration : String
    , effect : String
    , name : String
    , range : String
    , target : String
    }


emptySpell : Spell
emptySpell =
    { cn = 0
    , duration = ""
    , effect = ""
    , name = ""
    , range = ""
    , target = ""
    }


addSpell : Character -> Character
addSpell character =
    { character | spells = OrderedDict.insert emptySpell character.spells }


removeSpell : Int -> Character -> Character
removeSpell id character =
    { character | spells = OrderedDict.remove id character.spells }


setSpellCn : Int -> Int -> Character -> Character
setSpellCn id value character =
    { character |
        spells =
            OrderedDict.update
                id
                (\spell ->
                    { spell | cn = max 0 value }
                )
                character.spells
    }


setSpellDuration : Int -> String -> Character -> Character
setSpellDuration id value character =
    { character |
        spells =
            OrderedDict.update
                id
                (\spell ->
                    { spell | duration = value }
                )
                character.spells
    }


setSpellEffect : Int -> String -> Character -> Character
setSpellEffect id value character =
    { character |
        spells =
            OrderedDict.update
                id
                (\spell ->
                    { spell | effect = value }
                )
                character.spells
    }


setSpellName : Int -> String -> Character -> Character
setSpellName id value character =
    { character |
        spells =
            OrderedDict.update
                id
                (\spell ->
                    { spell | name = value }
                )
                character.spells
    }


setSpellRange : Int -> String -> Character -> Character
setSpellRange id value character =
    { character |
        spells =
            OrderedDict.update
                id
                (\spell ->
                    { spell | range = value }
                )
                character.spells
    }


setSpellTarget : Int -> String -> Character -> Character
setSpellTarget id value character =
    { character |
        spells =
            OrderedDict.update
                id
                (\spell ->
                    { spell | target = value }
                )
                character.spells
    }


setSpellsOrder : List Int -> Character -> Character
setSpellsOrder order character =
    { character | spells = OrderedDict.setOrder order character.spells }


encodeSpell : Spell -> Encode.Value
encodeSpell spell =
    Encode.object
        [ ( "cn", Encode.int spell.cn )
        , ( "duration", Encode.string spell.duration )
        , ( "effect", Encode.string spell.effect )
        , ( "name", Encode.string spell.name )
        , ( "range", Encode.string spell.range )
        , ( "target", Encode.string spell.target )
        ]


decodeSpell : Decode.Decoder Spell
decodeSpell =
    Decode.map6
        (\cn duration effect name range target ->
            { cn = cn
            , duration = duration
            , effect = effect
            , name = name
            , range = range
            , target = target
            }
        )
        (Decode.field "cn" Decode.int)
        (Decode.field "duration" Decode.string)
        (Decode.field "effect" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "range" Decode.string)
        (Decode.field "target" Decode.string)

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
    talents
        |> List.map .timesTaken
        |> List.map (\timesTaken -> timesTaken * (timesTaken + 1) // 2 * 100)
        |> List.sum


addTalent : Character -> Character
addTalent character =
    { character | talents = OrderedDict.insert emptyTalent character.talents }


removeTalent : Int -> Character -> Character
removeTalent id character =
    { character | talents = OrderedDict.remove id character.talents }


setTalentDescription : Int -> String -> Character -> Character
setTalentDescription id value character =
    { character
        | talents =
            OrderedDict.update
                id
                (\talent ->
                    { talent | description = value }
                )
                character.talents
    }


setTalentName : Int -> String -> Character -> Character
setTalentName id value character =
    { character
        | talents =
            OrderedDict.update
                id
                (\talent ->
                    { talent | name = value }
                )
                character.talents
    }


setTalentTimesTaken : Int -> Int -> Character -> Character
setTalentTimesTaken id value character =
    { character
        | talents =
            OrderedDict.update
                id
                (\talent ->
                    { talent | timesTaken = minMax 0 99 value }
                )
                character.talents
    }


setTalentsOrder : List Int -> Character -> Character
setTalentsOrder order character =
    { character | talents = OrderedDict.setOrder order character.talents }


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
    { character | trappings = OrderedDict.insert emptyTrapping character.trappings }


removeTrapping : Int -> Character -> Character
removeTrapping id character =
    { character | trappings = OrderedDict.remove id character.trappings }


setTrappingEncumbrance : Int -> Int -> Character -> Character
setTrappingEncumbrance id value character =
    { character
        | trappings =
            OrderedDict.update
                id
                (\trapping ->
                    { trapping | encumbrance = minMax 0 99 value }
                )
                character.trappings
    }


setTrappingName : Int -> String -> Character -> Character
setTrappingName id value character =
    { character
        | trappings =
            OrderedDict.update
                id
                (\trapping ->
                    { trapping | name = value }
                )
                character.trappings
    }


setTrappingsOrder : List Int -> Character -> Character
setTrappingsOrder order character =
    { character | trappings = OrderedDict.setOrder order character.trappings }


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
    { character | weapons = OrderedDict.insert emptyWeapon character.weapons }


removeWeapon : Int -> Character -> Character
removeWeapon id character =
    { character | weapons = OrderedDict.remove id character.weapons }


setWeaponDamage : Int -> String -> Character -> Character
setWeaponDamage id value character =
    { character |
        weapons =
            OrderedDict.update
                id
                (\weapon ->
                    { weapon | damage = value }
                )
                character.weapons
    }


setWeaponEncumbrance : Int -> Int -> Character -> Character
setWeaponEncumbrance id value character =
    { character |
        weapons =
            OrderedDict.update
                id
                (\weapon ->
                    { weapon | encumbrance = minMax 0 99 value }
                )
                character.weapons
    }


setWeaponGroup : Int -> String -> Character -> Character
setWeaponGroup id value character =
    { character |
        weapons =
            OrderedDict.update
                id
                (\weapon ->
                    { weapon | group = value }
                )
                character.weapons
    }


setWeaponName : Int -> String -> Character -> Character
setWeaponName id value character =
    { character |
        weapons =
            OrderedDict.update
                id
                (\weapon ->
                    { weapon | name = value }
                )
                character.weapons
    }


setWeaponQualities : Int -> String -> Character -> Character
setWeaponQualities id value character =
    { character |
        weapons =
            OrderedDict.update
                id
                (\weapon ->
                    { weapon | qualities = value }
                )
                character.weapons
    }


setWeaponRange : Int -> String -> Character -> Character
setWeaponRange id value character =
    { character |
        weapons =
            OrderedDict.update
                id
                (\weapon ->
                    { weapon | range = value }
                )
                character.weapons
    }


setWeaponsOrder : List Int -> Character -> Character
setWeaponsOrder order character =
    { character | weapons = OrderedDict.setOrder order character.weapons }


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

type BodyLocation
    = Body
    | Head
    | LeftArm
    | LeftLeg
    | RightArm
    | RightLeg
    | Shield


type alias Injury =
    { description : String
    , location : BodyLocation
    }


emptyInjury : Injury
emptyInjury =
    { description = ""
    , location = Head
    }


bodyLocationToString : BodyLocation -> String
bodyLocationToString location =
    case location of
        Body -> "Body"
        Head -> "Head"
        LeftArm -> "Left Arm"
        LeftLeg -> "Left Leg"
        RightArm -> "Right Arm"
        RightLeg -> "Right Leg"
        Shield -> "Shield"


bodyLocationFromString : String -> Result String BodyLocation
bodyLocationFromString str =
    case str of
        "Body" -> Ok Body
        "Head" -> Ok Head
        "Left Arm" -> Ok LeftArm
        "Left Leg" -> Ok LeftLeg
        "Right Arm" -> Ok RightArm
        "Right Leg" -> Ok RightLeg
        "Shield" -> Ok Shield
        _ -> Err ("Cannot make mutation kind from '" ++ str ++ "'.")


injuryLocations : List BodyLocation
injuryLocations =
    [ Body
    , Head
    , LeftArm
    , LeftLeg
    , RightArm
    , RightLeg
    ]


getWounds : Character -> Int
getWounds character =
    let
        c12cBonus c12c =
            getBonus (getC12c c12c (getC12cs character))
    in
    c12cBonus S + c12cBonus T * 2 + c12cBonus WP + character.extraWounds


addInjury : Character -> Character
addInjury character =
    { character | injuries = OrderedDict.insert emptyInjury character.injuries }


removeInjury : Int -> Character -> Character
removeInjury id character =
    { character | injuries = OrderedDict.remove id character.injuries }


setCurrentWounds : Int -> Character -> Character
setCurrentWounds value character =
    { character | currentWounds = max 0 value }


setExtraWounds : Int -> Character -> Character
setExtraWounds value character =
    { character | extraWounds = max 0 value }


setInjuryDescription : Int -> String -> Character -> Character
setInjuryDescription id value character =
    { character |
        injuries =
            OrderedDict.update
                id
                (\injury ->
                    { injury | description = value }
                )
                character.injuries
    }


setInjuryLocation : Int -> BodyLocation -> Character -> Character
setInjuryLocation id value character =
    { character |
        injuries =
            OrderedDict.update
                id
                (\injury ->
                    { injury | location = value }
                )
                character.injuries
    }


setInjuryLocationFromString : Int -> String -> Character -> Character
setInjuryLocationFromString id str character =
    case bodyLocationFromString str of
        Ok location ->
            setInjuryLocation id location character

        Err _ ->
            character


setInjuriesOrder : List Int -> Character -> Character
setInjuriesOrder order character =
    { character | injuries = OrderedDict.setOrder order character.injuries }


encodeInjury : Injury -> Encode.Value
encodeInjury injury =
    Encode.object
        []


decodeInjury : Decode.Decoder Injury
decodeInjury =
    Decode.map2
        (\description location ->
            { description = description
            , location = location
            }
        )
        (Decode.field "description" Decode.string)
        (Decode.field "location" decodeBodyLocation)


decodeBodyLocation : Decode.Decoder BodyLocation
decodeBodyLocation =
    Decode.andThen
        (bodyLocationFromString >> Json.Decode.Extra.fromResult)
        Decode.string
