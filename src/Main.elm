module Main exposing (main)

import App exposing (Model)
import App.Msg as Msg exposing (Msg)
import App.UI
import Browser
import Browser.Navigation as Navigation
import Cmd.Extra
import List.Extra
import Url


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


init : flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url _ =
    { character = App.emptyCharacter
    }
        |> Cmd.Extra.withNoCmd


view : Model -> Browser.Document Msg
view model =
    { body = [ App.UI.view model ]
    , title = ""
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.NoOp ->
            Cmd.Extra.withNoCmd model

        Msg.SetC12csAdvances c12c str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 && value <= 99 then
                        App.setC12c value c12c model.character.c12csAdvances
                            |> asC12csAdvancesIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    if String.isEmpty str then
                        App.setC12c 0 c12c model.character.c12csAdvances
                            |> asC12csAdvancesIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

        Msg.SetC12csInitial c12c str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 && value <= 99 then
                        App.setC12c value c12c model.character.c12csInitial
                            |> asC12csInitialIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    if String.isEmpty str then
                        App.setC12c 0 c12c model.character.c12csInitial
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
                [ App.emptySkill ]
                |> asAdvancedSkillsIn model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetAdvancedSkillC12c index str ->
            case App.c12cFromString str of
                Just c12c ->
                    List.Extra.updateAt
                        index
                        (\skill ->
                            { skill | c12c = c12c }
                        )
                        model.character.advancedSkills
                        |> asAdvancedSkillsIn model.character
                        |> asCharacterIn model
                        |> Cmd.Extra.withNoCmd

                Nothing ->
                    Cmd.Extra.withNoCmd model


asC12csAdvancesIn : App.Character -> App.C12cs -> App.Character
asC12csAdvancesIn character c12cs =
    { character | c12csAdvances = c12cs }


asC12csInitialIn : App.Character -> App.C12cs -> App.Character
asC12csInitialIn character c12cs =
    { character | c12csInitial = c12cs }


asCharacterIn : App.Model -> App.Character -> App.Model
asCharacterIn model character =
    { model | character = character }


asBasicSkillsIn : App.Character -> List App.Skill -> App.Character
asBasicSkillsIn character skills =
    { character | basicSkills = skills }


asAdvancedSkillsIn : App.Character -> List App.Skill -> App.Character
asAdvancedSkillsIn character skills =
    { character | advancedSkills = skills }
