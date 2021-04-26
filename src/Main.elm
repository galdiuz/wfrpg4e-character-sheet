module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation
import Character
import Cmd.Extra
import Draggable
import File
import File.Download
import File.Select
import Json
import Json.Decode
import Json.Encode
import List.Extra
import Model exposing (Model)
import Msg as Msg exposing (Msg)
import Task
import Ui
import Url
import View


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = \_ -> Msg.NoOp
        , onUrlChange = \_ -> Msg.NoOp
        }


init : flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url _ =
    { character = Character.emptyCharacter
    , drag = Draggable.init
    , position = ( 0, 0 )
    , windowWidth = 0
    , ui = Ui.emptyUi
    }
        |> Cmd.Extra.withCmd
            (Task.perform
                (\viewport ->
                    Msg.SetWindowSize
                        (floor viewport.scene.width)
                        (floor viewport.scene.height)
                )
                Browser.Dom.getViewport
            )


view : Model -> Browser.Document Msg
view model =
    { body = [ View.view model ]
    , title = ""
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize Msg.SetWindowSize
        , Draggable.subscriptions Msg.DragMsg model.drag
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.NoOp ->
            Cmd.Extra.withNoCmd model

        Msg.SetC12csAdvances c12c str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 && value <= 99 then
                        Character.setC12c value c12c model.character.c12csAdvances
                            |> asC12csAdvancesIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    if String.isEmpty str then
                        Character.setC12c 0 c12c model.character.c12csAdvances
                            |> asC12csAdvancesIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

        Msg.SetC12csInitial c12c str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 && value <= 99 then
                        Character.setC12c value c12c model.character.c12csInitial
                            |> asC12csInitialIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    if String.isEmpty str then
                        Character.setC12c 0 c12c model.character.c12csInitial
                            |> asC12csInitialIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

        Msg.SetAdvancedSkillAdvances index str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 && value <= 99 then
                        List.Extra.updateAt
                            index
                            (\skill ->
                                { skill | advances = value }
                            )
                            model.character.advancedSkills
                            |> asAdvancedSkillsIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    if String.isEmpty str then
                        List.Extra.updateAt
                            index
                            (\skill ->
                                { skill | advances = 0 }
                            )
                            model.character.advancedSkills
                            |> asAdvancedSkillsIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

        Msg.SetAdvancedSkillName index str ->
            List.Extra.updateAt
                index
                (\skill ->
                    { skill | name = str }
                )
                model.character.advancedSkills
                |> asAdvancedSkillsIn model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetBasicSkillAdvances index str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 && value <= 99 then
                        List.Extra.updateAt
                            index
                            (\skill ->
                                { skill | advances = value }
                            )
                            model.character.basicSkills
                            |> asBasicSkillsIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    if String.isEmpty str then
                        List.Extra.updateAt
                            index
                            (\skill ->
                                { skill | advances = 0 }
                            )
                            model.character.basicSkills
                            |> asBasicSkillsIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

        Msg.AddAdvancedSkill ->
            List.append
                model.character.advancedSkills
                [ Character.emptySkill ]
                |> asAdvancedSkillsIn model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetAdvancedSkillC12c index str ->
            case Character.c12cFromString str of
                Ok c12c ->
                    List.Extra.updateAt
                        index
                        (\skill ->
                            { skill | c12c = c12c }
                        )
                        model.character.advancedSkills
                        |> asAdvancedSkillsIn model.character
                        |> asCharacterIn model
                        |> Cmd.Extra.withNoCmd

                Err _ ->
                    Cmd.Extra.withNoCmd model

        Msg.AddTalent ->
            List.append
                model.character.talents
                [ Character.emptyTalent ]
                |> asTalentsIn model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetTalentTimesTaken index str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 && value <= 99 then
                        List.Extra.updateAt
                            index
                            (\talent ->
                                { talent | timesTaken = value }
                            )
                            model.character.talents
                            |> asTalentsIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    if String.isEmpty str then
                        List.Extra.updateAt
                            index
                            (\talents ->
                                { talents | timesTaken = 0 }
                            )
                            model.character.talents
                            |> asTalentsIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

        Msg.SetTalentName index str ->
            List.Extra.updateAt
                index
                (\talent ->
                    { talent | name = str }
                )
                model.character.talents
                |> asTalentsIn model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetTalentDescription index str ->
            List.Extra.updateAt
                index
                (\talent ->
                    { talent | description = str }
                )
                model.character.talents
                |> asTalentsIn model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetExperience str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 then
                        value
                            |> asExperienceIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    Cmd.Extra.withNoCmd model

        Msg.AddExpAdjustment ->
            List.append
                model.character.expAdjustments
                [ Character.emptyExpAdjustment ]
                |> asExpAdjustmentsIn model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetExpAdjustmentDescription index str ->
            List.Extra.updateAt
                index
                (\talent ->
                    { talent | description = str }
                )
                model.character.expAdjustments
                |> asExpAdjustmentsIn model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetExpAdjustmentValue index str ->
            case String.toInt str of
                Just value ->
                    List.Extra.updateAt
                        index
                        (\adjustment ->
                            { adjustment | value = value }
                        )
                        model.character.expAdjustments
                        |> asExpAdjustmentsIn model.character
                        |> asCharacterIn model
                        |> Cmd.Extra.withNoCmd

                Nothing ->
                    if String.isEmpty str then
                        List.Extra.updateAt
                            index
                            (\adjustment ->
                                { adjustment | value = 0 }
                            )
                            model.character.expAdjustments
                            |> asExpAdjustmentsIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

        Msg.Save ->
            ( model
            , Json.Encode.encode 0 (Json.encodeCharacter model.character)
                |> File.Download.string "file.json" "application/json"
            )

        Msg.Load ->
            ( model
            , File.Select.file [ "application/json" ] Msg.LoadFile
            )

        Msg.LoadFile file ->
            ( model
            , Task.perform Msg.LoadString (File.toString file)
            )

        Msg.LoadString str ->
            case Json.Decode.decodeString Json.decodeCharacter str of
                Ok character ->
                    character
                        |> asCharacterIn model
                        |> Cmd.Extra.withNoCmd

                Err err ->
                    Cmd.Extra.withNoCmd model

        Msg.SetInformation field value ->
            Character.setInformation field value model.character.info
                |> asInformationIn model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetWindowSize x y ->
            { model | windowWidth = x }
                |> Cmd.Extra.withNoCmd

        Msg.SetDragDelta ( dx, dy ) ->
            let
                ( x, y ) =
                    model.position
            in
            { model
                | position =
                    ( round (toFloat x + dx)
                    , round (toFloat y + dy)
                    )
            }
                |> Cmd.Extra.withNoCmd

        Msg.DragMsg dragMsg ->
            Draggable.update dragConfig dragMsg model


dragConfig : Draggable.Config String Msg
dragConfig =
    Draggable.basicConfig Msg.SetDragDelta


asCharacterIn : Model -> Character.Character -> Model
asCharacterIn model character =
    { model | character = character }


asC12csAdvancesIn : Character.Character -> Character.C12cs -> Character.Character
asC12csAdvancesIn character c12cs =
    { character | c12csAdvances = c12cs }


asC12csInitialIn : Character.Character -> Character.C12cs -> Character.Character
asC12csInitialIn character c12cs =
    { character | c12csInitial = c12cs }


asBasicSkillsIn : Character.Character -> List Character.Skill -> Character.Character
asBasicSkillsIn character skills =
    { character | basicSkills = skills }


asAdvancedSkillsIn : Character.Character -> List Character.Skill -> Character.Character
asAdvancedSkillsIn character skills =
    { character | advancedSkills = skills }


asTalentsIn : Character.Character -> List Character.Talent -> Character.Character
asTalentsIn character talents =
    { character | talents = talents }


asExpAdjustmentsIn : Character.Character -> List Character.ExpAdjustment -> Character.Character
asExpAdjustmentsIn character adjustments =
    { character | expAdjustments = adjustments }


asExperienceIn : Character.Character -> Int -> Character.Character
asExperienceIn character value =
    { character | experience = value }


asInformationIn : Character.Character -> Character.Information -> Character.Character
asInformationIn character info =
    { character | info = info }
