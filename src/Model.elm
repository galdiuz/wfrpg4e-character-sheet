module Model exposing (Model)

import Character
import Ui
import Draggable


type alias Model =
    { character : Character.Character
    , drag : Draggable.State String
    , position : ( Int, Int )
    , windowWidth : Int
    , ui : Ui.Ui
    }
