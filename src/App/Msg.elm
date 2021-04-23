module App.Msg exposing (Msg(..))

import App


type Msg
    = NoOp
    | SetC12csAdvances App.C12c String
    | SetC12csInitial App.C12c String
