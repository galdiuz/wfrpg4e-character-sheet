module Json exposing (..)

import Character as Character
import Json.Decode as Decode
import Json.Decode.Extra
import Json.Decode.Field as Field
import Json.Encode as Encode


encodeCharacter : Character.Character -> Encode.Value
encodeCharacter character =
    Encode.object
        [ ( "c12csInitial", encodeC12cs character.c12csInitial )
        , ( "c12csAdvances", encodeC12cs character.c12csAdvances )
        , ( "basicSkills", Encode.list encodeSkill character.basicSkills )
        , ( "advancedSkills", Encode.list encodeSkill character.advancedSkills )
        , ( "talents", Encode.list encodeTalent character.talents )
        , ( "experience", Encode.int character.experience )
        , ( "expAdjustments", Encode.list encodeExpAdjustment character.expAdjustments )
        , ( "info", encodeInformation character.info )
        , ( "trappings", Encode.list encodeTrapping character.trappings )
        , ( "wealth", encodeWealth character.wealth )
        ]


encodeC12cs : Character.C12cs -> Encode.Value
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


encodeInformation : Character.Information -> Encode.Value
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


encodeSkill : Character.Skill -> Encode.Value
encodeSkill skill =
    Encode.object
        [ ( "advances", Encode.int skill.advances )
        , ( "c12c", Encode.string (Character.c12cToString skill.c12c) )
        , ( "name", Encode.string skill.name )
        ]


encodeTalent : Character.Talent -> Encode.Value
encodeTalent talent =
    Encode.object
        [ ( "description", Encode.string talent.description )
        , ( "timesTaken", Encode.int talent.timesTaken )
        , ( "name", Encode.string talent.name )
        ]


encodeExpAdjustment : Character.ExpAdjustment -> Encode.Value
encodeExpAdjustment adjustment =
    Encode.object
        [ ( "description", Encode.string adjustment.description )
        , ( "value", Encode.int adjustment.value )
        ]


encodeTrapping : Character.Trapping -> Encode.Value
encodeTrapping trapping =
    Encode.object
        [ ( "encumbrance", Encode.int trapping.encumbrance )
        , ( "name", Encode.string trapping.name )
        ]


encodeWealth : Character.Wealth -> Encode.Value
encodeWealth wealth =
    Encode.object
        [ ( "brass", Encode.int wealth.brass )
        , ( "gold", Encode.int wealth.gold )
        , ( "silver", Encode.int wealth.silver )
        ]


decodeCharacter : Decode.Decoder Character.Character
decodeCharacter =
    Field.require "c12csInitial" decodeC12cs <| \c12csInitial ->
    Field.require "c12csAdvances" decodeC12cs <| \c12csAdvances ->
    Field.require "basicSkills" (Decode.list decodeSkill) <| \basicSkills ->
    Field.require "advancedSkills" (Decode.list decodeSkill) <| \advancedSkills ->
    Field.require "talents" (Decode.list decodeTalent) <| \talents ->
    Field.require "experience" Decode.int <| \experience ->
    Field.require "expAdjustments" (Decode.list decodeExpAdjustment) <| \expAdjustments ->
    Field.require "info" decodeInformation <| \info ->
    Field.require "trappings" (Decode.list decodeTrapping) <| \trappings ->
    Field.require "wealth" decodeWealth <| \wealth ->
    Decode.succeed
        { c12csInitial = c12csInitial
        , c12csAdvances = c12csAdvances
        , basicSkills = basicSkills
        , advancedSkills = advancedSkills
        , talents = talents
        , experience = experience
        , expAdjustments = expAdjustments
        , info = info
        , trappings = trappings
        , wealth = wealth
        }


decodeC12cs : Decode.Decoder Character.C12cs
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


decodeInformation : Decode.Decoder Character.Information
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


decodeSkill : Decode.Decoder Character.Skill
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


decodeC12c : Decode.Decoder Character.C12c
decodeC12c =
    Decode.andThen
        (Character.c12cFromString >> Json.Decode.Extra.fromResult)
        Decode.string


decodeTalent : Decode.Decoder Character.Talent
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


decodeExpAdjustment : Decode.Decoder Character.ExpAdjustment
decodeExpAdjustment =
    Decode.map2
        (\description value ->
            { description = description
            , value = value
            }
        )
        (Decode.field "description" Decode.string)
        (Decode.field "value" Decode.int)


decodeTrapping : Decode.Decoder Character.Trapping
decodeTrapping =
    Decode.map2
        (\encumbrance name ->
            { encumbrance = encumbrance
            , name = name
            }
        )
        (Decode.field "encumbrance" Decode.int)
        (Decode.field "name" Decode.string)


decodeWealth : Decode.Decoder Character.Wealth
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
