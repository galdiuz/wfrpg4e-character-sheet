module Ui exposing (..)

import Dict exposing (Dict)
import Draggable
import List.Extra


type alias Ui =
    { cardHeights : Dict String Int
    , columns : List (List Card)
    , drag : Draggable.State Card
    , dragPosition : ( Int, Int )
    , draggedCard : Maybe Card
    , windowWidth : Int
    }


emptyUi : Ui
emptyUi =
    { cardHeights = Dict.empty
    , columns = []
    , drag = Draggable.init
    , draggedCard = Nothing
    , dragPosition = ( 0, 0 )
    , windowWidth = 0
    }


type Card
    = C12cs
    | Experience
    | Information
    | Skills
    | Talents
    | Trappings
    | Wealth


allCards : List Card
allCards =
    [ C12cs
    , Experience
    , Information
    , Skills
    , Talents
    , Trappings
    , Wealth
    ]


type alias CardUi =
    { card : Card
    , height : Int
    , preferredColumn : Int
    , preferredRow : Int
    }


cardId : Card -> String
cardId card =
    case card of
        C12cs -> "characteristics"
        Experience -> "experience"
        Information -> "information"
        Skills -> "skills"
        Talents -> "talents"
        Trappings -> "trappings"
        Wealth -> "wealth"


cardTitle : Card -> String
cardTitle card =
    case card of
        C12cs -> "Characteristics"
        Experience -> "Experience"
        Information -> "Information"
        Skills -> "Skills"
        Talents -> "Talents"
        Trappings -> "Trappings"
        Wealth -> "Wealth"


calculateColumns : Int -> List (List Card)
calculateColumns width =
    List.Extra.indexedFoldl
        (\index card columns ->
            List.Extra.updateAt
                (modBy (columnCount width) index)
                (\cards ->
                    List.append cards [ card ]
                )
                columns
        )
        (List.repeat (columnCount width) [])
        allCards


updateDraggedCard : Ui -> Ui
updateDraggedCard ui =
    case ui.draggedCard of
        Just draggedCard ->
            { ui
                | columns =
                    ui.columns
                        |> List.map (List.filter ((/=) draggedCard))
                        |> List.Extra.updateAt
                            (getColumnIndex ui (Tuple.first ui.dragPosition + getColumnWidth ui // 2)
                                |> max 0
                                |> min (columnCount ui.windowWidth - 1)
                            )
                            (List.foldl
                                (\card (totalHeight, list) ->
                                    let
                                        cardHeight =
                                            Dict.get (cardId card) ui.cardHeights
                                                |> Maybe.withDefault 0
                                    in
                                    ( totalHeight + cardHeight
                                    , List.append
                                        list
                                        [ ( totalHeight + cardHeight // 2, card ) ]
                                    )
                                )
                                ( 0, [] )
                                >> Tuple.second
                                >> (::) ( Tuple.second ui.dragPosition, draggedCard )
                                >> List.sortBy Tuple.first
                                >> List.map Tuple.second
                            )
            }

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


updateWindowWidth : Ui -> Int -> Ui
updateWindowWidth ui width =
    if ui.windowWidth == 0 || columnCount ui.windowWidth /= columnCount width then
        { ui
            | columns = calculateColumns width
            , windowWidth = width
        }

    else
        { ui | windowWidth = width }
