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
import Model exposing (Model)
import Msg as Msg exposing (Msg)
import OrderedDict exposing (OrderedDict)
import PositionAndSize exposing (PositionAndSize)
import Process
import String.Extra
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
                    Msg.WindowSizeReceived
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
        (List.append
            [ Browser.Events.onResize Msg.WindowSizeReceived
            , Draggable.subscriptions Msg.DragMsgReceived model.ui.drag
            ]
            (List.map
                (\( card, cardState ) ->
                    Browser.Events.onAnimationFrame (always (Msg.CardToggleAnimationFramePassed card cardState))
                )
                model.ui.cardsWaitingForFrame
            )
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.NoOp ->
            Cmd.Extra.withNoCmd model

        Msg.SavePressed ->
            ( model
            , Json.Encode.encode 0 (Character.encodeCharacter model.character)
                |> File.Download.string
                    (if String.Extra.isBlank model.character.info.name then
                        "character.json"
                     else
                         String.Extra.underscored model.character.info.name ++ ".json"
                    )
                    "application/json"
            )

        Msg.LoadPressed ->
            ( model
            , File.Select.file [ "application/json" ] Msg.FileLoaded
            )

        Msg.FileLoaded file ->
            ( model
            , Task.perform Msg.FileParsed (File.toString file)
            )

        Msg.FileParsed str ->
            case Json.Decode.decodeString Character.decodeCharacter str of
                Ok character ->
                    character
                        |> Model.asCharacterIn model
                        |> Cmd.Extra.withNoCmd

                Err err ->
                    Cmd.Extra.withNoCmd model

        Msg.WindowSizeReceived x y ->
            Ui.updateWindowWidth model.ui x
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.ElementDragged ( dx, dy ) ->
            let
                ( x, y ) =
                    model.ui.dragPosition
            in
            Ui.setDragPosition
                ( round (toFloat x + dx)
                , round (toFloat y + dy)
                )
                model.ui
                |> Ui.updateDraggedElement
                |> Model.asUiIn model
                |> updateCharacterFromUi

        Msg.DragStarted (Ui.Card draggedCard) ->
            model
                |> Cmd.Extra.withCmd
                    (getElementPositionAndSize
                        (Ui.cardId draggedCard)
                        (Msg.DraggedElementPositionAndSizeReceived (Ui.Card draggedCard))
                    )
                |> Cmd.Extra.addCmds
                    (List.map
                        (\card ->
                            getElementPositionAndSize
                                (Ui.cardId card)
                                (Msg.CardPositionAndSizeReceived card)
                        )
                        Ui.allCards
                    )
                |> Cmd.Extra.addCmds
                    (List.indexedMap
                        (\index _ ->
                            getElementPositionAndSize
                                (Ui.columnId index)
                                (Msg.ColumnPositionAndSizeReceived index)
                        )
                        model.ui.columns
                    )

        Msg.DragStarted ((Ui.Row card _) as element) ->
            model
                |> Cmd.Extra.withCmd
                    (getElementPositionAndSize
                        (Ui.draggableElementId element)
                        (Msg.DraggedElementPositionAndSizeReceived element)
                    )
                |> Cmd.Extra.addCmds
                    (getCharacterDictKeysFromCard model.character card
                        |> List.map
                            (\id ->
                                (getElementPositionAndSize
                                    (Ui.draggableElementId (Ui.Row card id))
                                    (Msg.RowPositionAndSizeReceived (Ui.Row card id))
                                )
                            )
                    )
                |> Cmd.Extra.addCmd
                    (getElementPositionAndSize
                        (Ui.rowContainerId card)
                        (Msg.RowContainerPositionAndSizeReceived card)
                    )

        Msg.DraggedElementPositionAndSizeReceived element data ->
            model.ui
                |> Ui.setDraggedElement (Just element)
                |> Ui.setDragHeight (round data.height)
                |> Ui.setDragPosition
                    ( round (data.x)
                    , round (data.y)
                    )
                |> Ui.removeMovingElement element
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.CardPositionAndSizeReceived card data ->
            Ui.setCardHeight card (round data.height) model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.ColumnPositionAndSizeReceived index data ->
            Ui.setColumnPosition index ( round data.x, round data.y ) model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.DragElementClicked _ ->
            Ui.setDraggedElement Nothing model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.DragStopped ->
            model
                |> Cmd.Extra.withCmd
                    (case model.ui.draggedElement of
                        Just element ->
                            getElementPositionAndSize
                                (Ui.draggableElementId element)
                                (Msg.DragStoppedElementPositionAndSizeReceived element)

                        _ ->
                            Cmd.none
                    )

        Msg.DragStoppedElementPositionAndSizeReceived element data ->
            model.ui
                |> Ui.setMovingElement element ( round data.x, round data.y )
                |> Ui.setDraggedElement Nothing
                |> Ui.setDragPosition ( 0, 0 )
                |> Model.asUiIn model
                |> Cmd.Extra.withCmd
                    (Process.sleep 1000
                        |> Task.perform (\_ -> Msg.ElementFinishedMoving element)
                    )

        Msg.ElementFinishedMoving element ->
            Ui.removeMovingElement element model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.DragMsgReceived dragMsg ->
            Draggable.update dragConfig dragMsg model.ui
                |> Tuple.mapFirst (Model.asUiIn model)

        Msg.ToggleCardStatePressed card ->
            model
                |> Cmd.Extra.withCmd
                    (getElementSceneHeight
                        (Ui.cardId card ++ "-content")
                        (Msg.CardContentHeightReceived
                            card
                            (Ui.invertCardState (Ui.getCardState card model.ui))
                        )
                    )

        Msg.SetAllCardStatesPressed cardState ->
            model
                |> Cmd.Extra.withCmds
                    (List.map
                        (\card ->
                            (getElementSceneHeight
                                (Ui.cardId card ++ "-content")
                                (Msg.CardContentHeightReceived
                                    card
                                    cardState
                                )
                            )
                        )
                        Ui.allCards
                    )

        Msg.CardContentHeightReceived card cardState height ->
            model.ui
                |> Ui.setCardContentHeight card height
                |> Ui.addCardWaitingForFrame card cardState
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.CardToggleAnimationFramePassed card cardState ->
            model.ui
                |> Ui.setCardState cardState card
                |> Ui.removeCardWaitingForFrame card
                |> Model.asUiIn model
                |> Cmd.Extra.withCmd
                    (Process.sleep 350
                        |> Task.perform (\_ -> Msg.CardToggleTimePassed card)
                    )

        Msg.CardToggleTimePassed card ->
            Ui.removeCardContentHeight card model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.ButtonPressed fn ->
            fn model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.TextFieldChanged setter str ->
            setter str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.NumberFieldChanged setter str ->
            parseIntAndSet
                { string = str
                , setter = setter
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.ToggleSpellStatePressed index ->
            Ui.toggleSpellState index model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.RowPositionAndSizeReceived element data ->
            Ui.setRowPosition element (round data.y + round (data.height / 2)) model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.RowContainerPositionAndSizeReceived card data ->
            Ui.setRowContainerPosition card data model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd


dragConfig : Draggable.Config Ui.DraggableElement Msg
dragConfig =
    Draggable.customConfig
        [ Draggable.Events.onDragBy Msg.ElementDragged
        , Draggable.Events.onMouseDown Msg.DragStarted
        , Draggable.Events.onDragEnd Msg.DragStopped
        , Draggable.Events.onClick Msg.DragElementClicked
        ]


parseIntAndSet :
    { string : String
    , setter : Int -> Character.Character -> Character.Character
    }
    -> Model
    -> Model
parseIntAndSet data model =
    case String.toInt data.string of
        Just value ->
            data.setter value model.character
                |> Model.asCharacterIn model

        Nothing ->
            if String.isEmpty data.string then
                data.setter 0 model.character
                    |> Model.asCharacterIn model

            else
                model


getElementPositionAndSize : String -> (PositionAndSize -> Msg) -> Cmd Msg
getElementPositionAndSize id toMsg =
    Browser.Dom.getElement id
        |> Task.map .element
        |> Task.attempt
            (Result.map toMsg >> Result.withDefault Msg.NoOp)


getElementSceneHeight : String -> (Int -> Msg) -> Cmd Msg
getElementSceneHeight id toMsg =
    Browser.Dom.getViewportOf id
        |> Task.map .scene
        |> Task.map .height
        |> Task.map round
        |> Task.attempt
            (Result.map toMsg >> Result.withDefault Msg.NoOp)


updateCharacterFromUi model =
    case model.ui.draggedElement of
        Just ((Ui.Row card _) as element) ->
            let
                uiOrder =
                    Dict.get (Ui.cardId card) model.ui.rowPositions
                        |> Maybe.withDefault Dict.empty
                        |> Dict.toList
                        |> List.sortBy Tuple.second
                        |> List.map Tuple.first

                charOrder =
                    getCharacterDictKeysFromCard model.character card
            in
            if uiOrder /= charOrder then
                setCharacterDictOrderFromCard uiOrder card model.character
                    |> Model.asCharacterIn model
                    |> Cmd.Extra.withNoCmd
            else
                model
                    |> Cmd.Extra.withCmds
                        (charOrder
                            |> List.map
                                (\id ->
                                    (getElementPositionAndSize
                                        (Ui.draggableElementId (Ui.Row card id))
                                        (Msg.RowPositionAndSizeReceived (Ui.Row card id))
                                    )
                                )
                        )

        _ ->
            model
                |> Cmd.Extra.withNoCmd


getCharacterDictKeysFromCard : Character.Character -> Ui.Card -> List Int
getCharacterDictKeysFromCard character card =
    case card of
        Ui.Armour ->
            OrderedDict.keys character.armour

        Ui.Corruption ->
            OrderedDict.keys character.mutations

        Ui.Experience ->
            OrderedDict.keys character.expAdjustments

        Ui.Notes ->
            OrderedDict.keys character.notes

        Ui.Skills ->
            OrderedDict.keys character.advancedSkills

        Ui.Spells ->
            OrderedDict.keys character.spells

        Ui.Talents ->
            OrderedDict.keys character.talents

        Ui.Trappings ->
            OrderedDict.keys character.trappings

        Ui.Weapons ->
            OrderedDict.keys character.weapons

        Ui.Wounds ->
            OrderedDict.keys character.injuries

        _ ->
            []


setCharacterDictOrderFromCard : List Int -> Ui.Card -> Character.Character -> Character.Character
setCharacterDictOrderFromCard order card character =
    case card of
        Ui.Armour ->
            Character.setArmourOrder order character

        Ui.Corruption ->
            Character.setMutationsOrder order character

        Ui.Experience ->
            Character.setExpAdjustmentsOrder order character

        Ui.Notes ->
            Character.setNotesOrder order character

        Ui.Skills ->
            Character.setAdvancedSkillsOrder order character

        Ui.Spells ->
            Character.setSpellsOrder order character

        Ui.Talents ->
            Character.setTalentsOrder order character

        Ui.Trappings ->
            Character.setTrappingsOrder order character

        Ui.Weapons ->
            Character.setWeaponsOrder order character

        Ui.Wounds ->
            Character.setInjuriesOrder order character

        _ ->
            character
