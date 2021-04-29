module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation
import Character
import Cmd.Extra
import Dict exposing (Dict)
import Draggable
import Draggable.Events
import File
import File.Download
import File.Select
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
        , Draggable.subscriptions Msg.DragMsg model.ui.drag
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
            , Json.Encode.encode 0 (Character.encodeCharacter model.character)
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
            case Json.Decode.decodeString Character.decodeCharacter str of
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
            Ui.updateWindowWidth model.ui x
                |> asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetDragPosition ( dx, dy ) ->
            let
                ( x, y ) =
                    model.ui.dragPosition
            in
            ( round (toFloat x + dx)
            , round (toFloat y + dy)
            )
                |> asDragPositionIn model.ui
                |> Ui.updateDraggedCard
                |> asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetDragElement cardType ->
            Just cardType
                |> asDraggedCardIn model.ui
                |> asUiIn model
                |> Cmd.Extra.withCmd
                    (Browser.Dom.getElement (Ui.cardId cardType)
                        |> Task.map .element
                        |> Task.attempt
                            (Result.map (Msg.SetDragElementData)
                                >> Result.withDefault Msg.NoOp
                            )
                    )
                |> Cmd.Extra.addCmds
                    (List.map
                        (\card ->
                            Browser.Dom.getElement (Ui.cardId card)
                                |> Task.map .element
                                |> Task.attempt
                                    (Result.map (Msg.SetCardData card)
                                        >> Result.withDefault Msg.NoOp
                                    )
                        )
                        Ui.allCards
                    )

        Msg.SetCardData card data ->
            Dict.insert
                (Ui.cardId card)
                (round data.height)
                model.ui.cardHeights
                |> asCardHeightsIn model.ui
                |> asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetDragElementData data ->
            ( round (data.x)
            , round (data.y)
            )
                |> asDragPositionIn model.ui
                |> asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.ClearDragElementOnClick _ ->
            Nothing
                |> asDraggedCardIn model.ui
                |> asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.ClearDragElementOnDragEnd ->
            Nothing
                |> asDraggedCardIn model.ui
                |> asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.DragMsg dragMsg ->
            Draggable.update dragConfig dragMsg model.ui
                |> Tuple.mapFirst (asUiIn model)

        Msg.AddTrapping ->
            List.append
                model.character.trappings
                [ Character.emptyTrapping ]
                |> asTrappingsIn model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetTrappingName index str ->
            List.Extra.updateAt
                index
                (\trapping ->
                    { trapping | name = str }
                )
                model.character.trappings
                |> asTrappingsIn model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetTrappingEncumbrance index str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 && value <= 99 then
                        List.Extra.updateAt
                            index
                            (\trapping ->
                                { trapping | encumbrance = value }
                            )
                            model.character.trappings
                            |> asTrappingsIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    if String.isEmpty str then
                        List.Extra.updateAt
                            index
                            (\trapping ->
                                { trapping | encumbrance = 0 }
                            )
                            model.character.trappings
                            |> asTrappingsIn model.character
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

        Msg.SetWealthGold str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 then
                        Character.setGold model.character value
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    if String.isEmpty str then
                        Character.setGold model.character 0
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

        Msg.SetWealthSilver str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 then
                        Character.setSilver model.character value
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    if String.isEmpty str then
                        Character.setSilver model.character 0
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

        Msg.SetWealthBrass str ->
            case String.toInt str of
                Just value ->
                    if value >= 0 then
                        Character.setBrass model.character value
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

                Nothing ->
                    if String.isEmpty str then
                        Character.setBrass model.character 0
                            |> asCharacterIn model
                            |> Cmd.Extra.withNoCmd

                    else
                        Cmd.Extra.withNoCmd model

        Msg.ConvertAllSilverToGold ->
            Character.convertAllSilverToGold model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertOneSilverToGold ->
            Character.convertOneSilverToGold model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertAllSilverToBrass ->
            Character.convertAllSilverToBrass model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertOneSilverToBrass ->
            Character.convertOneSilverToBrass model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertAllGoldToSilver ->
            Character.convertAllGoldToSilver model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertOneGoldToSilver ->
            Character.convertOneGoldToSilver model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertAllBrassToSilver ->
            Character.convertAllBrassToSilver model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertOneBrassToSilver ->
            Character.convertOneBrassToSilver model.character
                |> asCharacterIn model
                |> Cmd.Extra.withNoCmd


dragConfig : Draggable.Config Ui.Card Msg
dragConfig =
    Draggable.customConfig
        [ Draggable.Events.onDragBy Msg.SetDragPosition
        , Draggable.Events.onMouseDown Msg.SetDragElement
        , Draggable.Events.onDragEnd Msg.ClearDragElementOnDragEnd
        , Draggable.Events.onClick Msg.ClearDragElementOnClick
        ]


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


asUiIn : Model -> Ui.Ui -> Model
asUiIn model ui =
    { model | ui = ui }


asWindowWidthIn : Ui.Ui -> Int -> Ui.Ui
asWindowWidthIn ui width =
    { ui | windowWidth = width }


asDragPositionIn : Ui.Ui -> ( Int, Int ) -> Ui.Ui
asDragPositionIn ui dragPosition =
    { ui | dragPosition = dragPosition }


asDraggedCardIn : Ui.Ui -> Maybe Ui.Card -> Ui.Ui
asDraggedCardIn ui card =
    { ui | draggedCard = card }


asCardHeightsIn : Ui.Ui -> Dict String Int -> Ui.Ui
asCardHeightsIn ui cardHeights =
    { ui | cardHeights = cardHeights }


asTrappingsIn : Character.Character -> List Character.Trapping -> Character.Character
asTrappingsIn character trappings =
    { character | trappings = trappings }
