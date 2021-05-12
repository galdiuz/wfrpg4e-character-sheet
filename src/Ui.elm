module Ui exposing (..)

import Dict exposing (Dict)
import Draggable
import Icons
import List.Extra


type alias Ui =
    { cardHeights : Dict String Int
    , cardStates : Dict String CardState
    , columns : List (List Card)
    , drag : Draggable.State Card
    , dragPosition : ( Int, Int )
    , draggedCard : Maybe Card
    , windowWidth : Int
    }


emptyUi : Ui
emptyUi =
    { cardHeights = Dict.empty
    , cardStates = Dict.empty
    , columns = []
    , drag = Draggable.init
    , draggedCard = Nothing
    , dragPosition = ( 0, 0 )
    , windowWidth = 0
    }


type Card
    = Armour
    | C12cs
    | Experience
    | Information
    | Skills
    | Talents
    | Trappings
    | Wealth
    | Weapons
    | Wounds


allCards : List Card
allCards =
    [ Armour
    , C12cs
    , Experience
    , Information
    , Skills
    , Talents
    , Trappings
    , Wealth
    , Weapons
    , Wounds
    ]


cardId : Card -> String
cardId card =
    case card of
        Armour -> "armour"
        C12cs -> "characteristics"
        Experience -> "experience"
        Information -> "information"
        Skills -> "skills"
        Talents -> "talents"
        Trappings -> "trappings"
        Wealth -> "wealth"
        Weapons -> "weapons"
        Wounds -> "wounds"


cardTitle : Card -> String
cardTitle card =
    case card of
        Armour -> "Armour"
        C12cs -> "Characteristics"
        Experience -> "Experience"
        Information -> "Information"
        Skills -> "Skills"
        Talents -> "Talents"
        Trappings -> "Trappings"
        Wealth -> "Wealth"
        Weapons -> "Weapons"
        Wounds -> "Wounds"


cardIcon : Card -> String
cardIcon card =
    case card of
        Armour -> Icons.breastplate
        C12cs -> Icons.skills
        Experience -> Icons.wisdom
        Information -> Icons.character
        Skills -> Icons.graduateCap
        Talents -> Icons.ribbonMedal
        Trappings -> Icons.bag
        Wealth -> Icons.coins
        Weapons -> Icons.axeSword
        Wounds -> Icons.wound


type CardState
    = Collapsed
    | Open


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
                                ( 24, [] )
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
    ui.windowWidth // columnCount ui.windowWidth - 4


updateWindowWidth : Ui -> Int -> Ui
updateWindowWidth ui width =
    if ui.windowWidth == 0 || columnCount ui.windowWidth /= columnCount width then
        { ui
            | columns = calculateColumns width
            , windowWidth = width
        }

    else
        { ui | windowWidth = width }


setWindowWidth : Int -> Ui ->  Ui
setWindowWidth width ui =
    { ui | windowWidth = width }


setDragPosition : ( Int, Int ) -> Ui -> Ui
setDragPosition dragPosition ui =
    { ui | dragPosition = dragPosition }


setDraggedCard : Maybe Card -> Ui -> Ui
setDraggedCard card ui =
    { ui | draggedCard = card }


setCardHeight : Card -> Int -> Ui -> Ui
setCardHeight card height ui =
    { ui
        | cardHeights =
            Dict.insert
                (cardId card)
                height
                ui.cardHeights
    }


getCardState : Card -> Ui -> CardState
getCardState card ui =
    Dict.get (cardId card) ui.cardStates
        |> Maybe.withDefault Open


setCardState : CardState -> Card -> Ui -> Ui
setCardState state card ui =
    { ui
        | cardStates =
            Dict.insert
                (cardId card)
                state
                ui.cardStates
    }


toggleCardState : Card -> Ui -> Ui
toggleCardState card ui =
    case getCardState card ui of
        Open ->
            setCardState Collapsed card ui

        Collapsed ->
            setCardState Open card ui


collapseAllCards : Ui -> Ui
collapseAllCards ui =
    List.foldl
        (setCardState Collapsed)
        ui
        allCards


expandAllCards : Ui -> Ui
expandAllCards ui =
    List.foldl
        (setCardState Open)
        ui
        allCards
