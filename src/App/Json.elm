module App.Json exposing (..)

import App
import Json.Decode as Decode
import Json.Decode.Extra
import Json.Decode.Field as Field
import Json.Encode as Encode


encodeCharacter : App.Character -> Encode.Value
encodeCharacter character =
    Encode.object
        [ ( "c12csInitial", encodeC12cs character.c12csInitial )
        , ( "c12csAdvances", encodeC12cs character.c12csAdvances )
        , ( "basicSkills", Encode.list encodeSkill character.basicSkills )
        , ( "advancedSkills", Encode.list encodeSkill character.advancedSkills )
        , ( "talents", Encode.list encodeTalent character.talents )
        , ( "experience", Encode.int character.experience )
        , ( "expAdjustments", Encode.list encodeExpAdjustment character.expAdjustments )
        ]


encodeC12cs : App.C12cs -> Encode.Value
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


encodeSkill : App.Skill -> Encode.Value
encodeSkill skill =
    Encode.object
        [ ( "advances", Encode.int skill.advances )
        , ( "c12c", Encode.string (App.c12cToString skill.c12c) )
        , ( "name", Encode.string skill.name )
        ]


encodeTalent : App.Talent -> Encode.Value
encodeTalent talent =
    Encode.object
        [ ( "description", Encode.string talent.description )
        , ( "timesTaken", Encode.int talent.timesTaken )
        , ( "name", Encode.string talent.name )
        ]


encodeExpAdjustment : App.ExpAdjustment -> Encode.Value
encodeExpAdjustment adjustment =
    Encode.object
        [ ( "description", Encode.string adjustment.description )
        , ( "value", Encode.int adjustment.value )
        ]


decodeCharacter : Decode.Decoder App.Character
decodeCharacter =
    Field.require "c12csInitial" decodeC12cs <| \c12csInitial ->
    Field.require "c12csAdvances" decodeC12cs <| \c12csAdvances ->
    Field.require "basicSkills" (Decode.list decodeSkill) <| \basicSkills ->
    Field.require "advancedSkills" (Decode.list decodeSkill) <| \advancedSkills ->
    Field.require "talents" (Decode.list decodeTalent) <| \talents ->
    Field.require "experience" Decode.int <| \experience ->
    Field.require "expAdjustments" (Decode.list decodeExpAdjustment) <| \expAdjustments ->
    Decode.succeed
        { c12csInitial = c12csInitial
        , c12csAdvances = c12csAdvances
        , basicSkills = basicSkills
        , advancedSkills = advancedSkills
        , talents = talents
        , experience = experience
        , expAdjustments = expAdjustments
        }


decodeC12cs : Decode.Decoder App.C12cs
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


decodeSkill : Decode.Decoder App.Skill
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


decodeC12c : Decode.Decoder App.C12c
decodeC12c =
    Decode.andThen
        (App.c12cFromString >> Json.Decode.Extra.fromResult)
        Decode.string


decodeTalent : Decode.Decoder App.Talent
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


decodeExpAdjustment : Decode.Decoder App.ExpAdjustment
decodeExpAdjustment =
    Decode.map2
        (\description value ->
            { description = description
            , value = value
            }
        )
        (Decode.field "description" Decode.string)
        (Decode.field "value" Decode.int)
