module Msg exposing (..)

import Character as Character exposing (Character)
import Draggable
import File
import Ui


type Msg
    = NoOp
    | SavePressed
    | LoadPressed
    | FileLoaded File.File
    | FileParsed String
    | WindowSizeReceived Int Int
    | DragStarted Ui.Card
    | ElementDragged Draggable.Delta
    | DragMsgReceived (Draggable.Msg Ui.Card)
    | DragElementClicked Ui.Card
    | DragStopped
    | DraggedElementPositionAndSizeReceived Ui.Card PositionAndSize
    | DragStoppedElementPositionAndSizeReceived Ui.Card PositionAndSize
    | CardFinishedMoving Ui.Card
    | CardPositionAndSizeReceived Ui.Card PositionAndSize
    | ColumnPositionAndSizeReceived Int PositionAndSize
    | ToggleCardStatePressed Ui.Card
    | CollapseAllCardsPressed
    | ExpandAllCardsPressed
    | ButtonPressed (Character -> Character)
    | TextFieldChanged (String -> Character -> Character) String
    | NumberFieldChanged (Int -> Character -> Character) String


type alias PositionAndSize =
    { x : Float
    , y : Float
    , width : Float
    , height : Float
    }
