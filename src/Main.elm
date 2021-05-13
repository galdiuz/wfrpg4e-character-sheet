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
import Process
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
        [ Browser.Events.onResize Msg.WindowSizeReceived
        , Draggable.subscriptions Msg.DragMsgReceived model.ui.drag
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.NoOp ->
            Cmd.Extra.withNoCmd model

        Msg.SavePressed ->
            ( model
            , Json.Encode.encode 0 (Character.encodeCharacter model.character)
                |> File.Download.string "file.json" "application/json"
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
                |> Ui.updateDraggedCard
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.DragStarted draggedCard ->
            model
                |> Cmd.Extra.withCmd
                    (getElementPositionAndSize
                        (Ui.cardId draggedCard)
                        (Msg.DraggedElementPositionAndSizeReceived draggedCard)
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

        Msg.DraggedElementPositionAndSizeReceived card data ->
            model.ui
                |> Ui.setDraggedCard (Just card)
                |> Ui.setDragPosition
                    ( round (data.x)
                    , round (data.y)
                    )
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
            Ui.setDraggedCard Nothing model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.DragStopped ->
            model
                |> Cmd.Extra.withCmd
                    (case model.ui.draggedCard of
                        Just card ->
                            getElementPositionAndSize
                                (Ui.cardId card)
                                (Msg.DragStoppedElementPositionAndSizeReceived card)

                        Nothing ->
                            Cmd.none
                    )

        Msg.DragStoppedElementPositionAndSizeReceived card data ->
            model.ui
                |> Ui.setMovingCard card ( round data.x, round data.y )
                |> Ui.setDraggedCard Nothing
                |> Ui.setDragPosition ( 0, 0 )
                |> Model.asUiIn model
                |> Cmd.Extra.withCmd
                    (Process.sleep 1000
                        |> Task.perform (\_ -> Msg.CardFinishedMoving card)
                    )

        Msg.CardFinishedMoving card ->
            Ui.removeMovingCard card model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.DragMsgReceived dragMsg ->
            Draggable.update dragConfig dragMsg model.ui
                |> Tuple.mapFirst (Model.asUiIn model)

        Msg.ToggleCardStatePressed card ->
            Ui.toggleCardState card model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.CollapseAllCardsPressed ->
            Ui.collapseAllCards model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.ExpandAllCardsPressed ->
            Ui.expandAllCards model.ui
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


dragConfig : Draggable.Config Ui.Card Msg
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


getElementPositionAndSize : String -> (Msg.PositionAndSize -> Msg) -> Cmd Msg
getElementPositionAndSize id toMsg =
    Browser.Dom.getElement id
        |> Task.map .element
        |> Task.attempt
            (Result.map toMsg >> Result.withDefault Msg.NoOp)
