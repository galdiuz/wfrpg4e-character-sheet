module Model exposing (Model)

import Character
import Ui
import Draggable


type alias Model =
    { character : Character.Character
    , ui : Ui.Ui
    }
