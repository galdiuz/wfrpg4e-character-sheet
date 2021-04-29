module Model exposing (..)

import Character
import Ui
import Draggable


type alias Model =
    { character : Character.Character
    , ui : Ui.Ui
    }


asCharacterIn : Model -> Character.Character -> Model
asCharacterIn model character =
    { model | character = character }


asUiIn : Model -> Ui.Ui -> Model
asUiIn model ui =
    { model | ui = ui }
