module Msg exposing (..)

import Character as Character exposing (Character)
import Draggable
import File
import PositionAndSize exposing (PositionAndSize)
import Ui


type Msg
    = NoOp
    | SavePressed
    | LoadPressed
    | FileLoaded File.File
    | FileParsed String
    | WindowSizeReceived Int Int
    | DragStarted Ui.DraggableElement
    | ElementDragged Draggable.Delta
    | DragMsgReceived (Draggable.Msg Ui.DraggableElement)
    | DragElementClicked Ui.DraggableElement
    | DragStopped
    | DraggedElementPositionAndSizeReceived Ui.DraggableElement PositionAndSize
    | DragStoppedElementPositionAndSizeReceived Ui.DraggableElement PositionAndSize
    | ElementFinishedMoving Ui.DraggableElement
    | CardPositionAndSizeReceived Ui.Card PositionAndSize
    | ColumnPositionAndSizeReceived Int PositionAndSize
    | ToggleCardStatePressed Ui.Card
    | SetAllCardStatesPressed Ui.CardState
    | CardContentHeightReceived Ui.Card Ui.CardState Int
    | CardToggleAnimationFramePassed Ui.Card Ui.CardState
    | CardToggleTimePassed Ui.Card
    | ButtonPressed (Character -> Character)
    | TextFieldChanged (String -> Character -> Character) String
    | NumberFieldChanged (Int -> Character -> Character) String
    | ToggleSpellStatePressed Int
    | RowPositionAndSizeReceived Ui.DraggableElement PositionAndSize
    | RowContainerPositionAndSizeReceived Ui.Card PositionAndSize
    | ToggleDeleteListRowPressed Ui.Card Int
    | DeleteListRowPressed Ui.Card Int
    | ListRowHeightReceived Ui.Card Int Int
    | ListRowDeleteAnimationFramePassed Ui.Card Int
    | ListRowDeleteTimePassed Ui.Card Int
