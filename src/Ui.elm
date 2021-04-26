module Ui exposing (..)


type alias Ui =
    { columns : List (List Card)
    }


emptyUi =
    { columns =
        [ [ Information
          , C12cs
          , Experience
          ]
        , [ Skills
          , Talents
          ]
        ]
    }


type Card
    = C12cs
    | Experience
    | Information
    | Skills
    | Talents


cardTitle : Card -> String
cardTitle card =
    case card of
        C12cs -> "Characteristics"
        Experience -> "Experience"
        Information -> "Information"
        Skills -> "Skills"
        Talents -> "Talents"
