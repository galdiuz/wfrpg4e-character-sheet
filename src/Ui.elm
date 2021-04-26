module Ui exposing (..)

import Draggable
import List.Extra


type alias Ui =
    { columns : List (List Card)
    , drag : Draggable.State Card
    , draggedCard : Maybe Card
    , position : ( Int, Int )
    , windowWidth : Int
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
    , drag = Draggable.init
    , draggedCard = Nothing
    , position = ( 0, 0 )
    , windowWidth = 0
    }


type Card
    = C12cs
    | Experience
    | Information
    | Skills
    | Talents


cardId : Card -> String
cardId card =
    case card of
        C12cs -> "characteristics"
        Experience -> "experience"
        Information -> "information"
        Skills -> "skills"
        Talents -> "talents"


cardTitle : Card -> String
cardTitle card =
    case card of
        C12cs -> "Characteristics"
        Experience -> "Experience"
        Information -> "Information"
        Skills -> "Skills"
        Talents -> "Talents"


calculateColumns : Ui -> Ui
calculateColumns ui =
    case ui.draggedCard of
        Just card ->
            let
                ( x, y ) =
                    ui.position

                ind =
                    getColumnIndex ui x
            in
            if cardColumn ui.columns card /= ind then
                { ui
                    | columns =
                        List.indexedMap
                            (\index cards ->
                                if ind == index then
                                    List.append
                                        (List.Extra.remove card cards)
                                        (List.singleton card)

                                else
                                    List.Extra.remove card cards
                            )
                            ui.columns
                }

            else
                ui

        Nothing ->
            ui


cardColumn : List (List Card) -> Card -> Int
cardColumn columns card =
    List.Extra.findIndex
        (List.member card)
        columns
        |> Maybe.withDefault 0


minColumnWidth : Int
minColumnWidth =
    400


columnCount : Int -> Int
columnCount width =
    max 1 (width // minColumnWidth)


getColumnIndex : Ui -> Int -> Int
getColumnIndex ui x =
    x // getColumnWidth ui


getColumnWidth : Ui -> Int
getColumnWidth ui =
    ui.windowWidth // columnCount ui.windowWidth
