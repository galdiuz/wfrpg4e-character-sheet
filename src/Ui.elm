module Ui exposing (..)

import Dict exposing (Dict)
import Draggable
import Icons
import List.Extra
import PositionAndSize exposing (PositionAndSize)


type alias Ui =
    { cardContentHeights : Dict String Int
    , cardHeights : Dict String Int
    , cardStates : Dict String CardState
    , cardsWaitingForFrame : List ( Card, CardState )
    , columns : List (List Card)
    , columnPositions : Dict Int ( Int, Int )
    , drag : Draggable.State DraggableElement
    , dragHeight : Int
    , dragPosition : ( Int, Int )
    , draggedElement : Maybe DraggableElement
    , movingElements : Dict String ( Int, Int )
    , rowContainerPositions : Dict String PositionAndSize
    , rowPositions : Dict String (Dict Int Int)
    , spellStates : Dict Int CardState
    , theme : Theme
    , windowWidth : Int
    }


emptyUi : Ui
emptyUi =
    { cardContentHeights = Dict.empty
    , cardHeights = Dict.empty
    , cardStates = Dict.empty
    , cardsWaitingForFrame = []
    , columns = []
    , columnPositions = Dict.empty
    , drag = Draggable.init
    , dragHeight = 0
    , dragPosition = ( 0, 0 )
    , draggedElement = Nothing
    , movingElements = Dict.empty
    , rowContainerPositions = Dict.empty
    , rowPositions = Dict.empty
    , spellStates = Dict.empty
    , theme = Dark
    , windowWidth = 0
    }


minMax : Int -> Int -> Int -> Int
minMax min max value =
    Basics.min max (Basics.max min value)


columnId : Int -> String
columnId index =
    "column-" ++ String.fromInt index


type DraggableElement
    = Card Card
    | Row Card Int


type Theme
    = Dark
    | Light


type Card
    = Armour
    | C12cs
    | Corruption
    | Encumbrance
    | Experience
    | Fate
    | Information
    | Movement
    | Notes
    | Skills
    | Spells
    | Talents
    | Trappings
    | Wealth
    | Weapons
    | Wounds


allCards : List Card
allCards =
    [ Armour
    , C12cs
    , Corruption
    , Encumbrance
    , Experience
    , Fate
    , Information
    , Movement
    , Notes
    , Skills
    , Spells
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
        Corruption -> "corruption"
        Encumbrance -> "encumbrance"
        Experience -> "experience"
        Fate -> "fate"
        Information -> "information"
        Movement -> "movement"
        Notes -> "notes"
        Skills -> "skills"
        Spells -> "spells"
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
        Corruption -> "Corruption & Mutations"
        Encumbrance -> "Encumbrance"
        Experience -> "Experience"
        Fate -> "Fate & Resilience"
        Information -> "Information"
        Movement -> "Movement"
        Notes -> "Notes"
        Skills -> "Skills"
        Spells -> "Spells & Prayers"
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
        Corruption -> Icons.tentacle
        Encumbrance -> Icons.weight
        Experience -> Icons.wisdom
        Fate -> Icons.sparkles
        Information -> Icons.character
        Movement -> Icons.run
        Notes -> Icons.notebook
        Skills -> Icons.graduateCap
        Spells -> Icons.spellBook
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


updateDraggedElement : Ui -> Ui
updateDraggedElement ui =
    case ui.draggedElement of
        Just (Card draggedCard) ->
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

        Just (Row card id) ->
            { ui
                | rowPositions =
                    Dict.update
                        (cardId card)
                        (\maybeDict ->
                            Maybe.withDefault Dict.empty maybeDict
                                |> Dict.insert
                                    id
                                    (Tuple.second ui.dragPosition + ui.dragHeight // 2)
                                |> Just
                        )
                        ui.rowPositions
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


setDragHeight : Int -> Ui -> Ui
setDragHeight height ui =
    { ui | dragHeight = height }


setDragPosition : ( Int, Int ) -> Ui -> Ui
setDragPosition dragPosition ui =
    { ui | dragPosition = dragPosition }


setDraggedElement : Maybe DraggableElement -> Ui -> Ui
setDraggedElement element ui =
    { ui | draggedElement = element }


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


invertCardState : CardState -> CardState
invertCardState state =
    case state of
        Open -> Collapsed
        Collapsed -> Open


setCardState : CardState -> Card -> Ui -> Ui
setCardState state card ui =
    { ui
        | cardStates =
            Dict.insert
                (cardId card)
                state
                ui.cardStates
    }


setMovingElement : DraggableElement -> ( Int, Int ) -> Ui -> Ui
setMovingElement element position ui =
    { ui
        | movingElements =
            Dict.insert
                (draggableElementId element)
                position
                ui.movingElements
    }


removeMovingElement : DraggableElement -> Ui -> Ui
removeMovingElement element ui =
    { ui
        | movingElements =
            Dict.remove
                (draggableElementId element)
                ui.movingElements
    }


draggableElementId : DraggableElement -> String
draggableElementId element =
    case element of
        Card card ->
            cardId card

        Row card id ->
            (cardId card) ++ "-row-" ++ String.fromInt id


draggableElementCardId : DraggableElement -> String
draggableElementCardId element =
    case element of
        Card _ ->
            ""

        Row card _ ->
            cardId card


draggableElementRowId : DraggableElement -> Int
draggableElementRowId element =
    case element of
        Card _ ->
            0

        Row _ id ->
            id


rowContainerId : Card -> String
rowContainerId card =
    cardId card ++ "-rows"


isElementFloating : Ui -> DraggableElement -> Bool
isElementFloating ui element =
    ui.draggedElement == Just element
    && ui.dragPosition /= ( 0, 0 )
    || Dict.member (draggableElementId element) ui.movingElements


getFloatingCardPosition : Ui -> Card -> Int -> ( Int, Int )
getFloatingCardPosition ui card index =
    case ( Dict.get (cardId card) ui.movingElements, Dict.get index ui.columnPositions ) of
        ( Just cardPos, Just columnPos ) ->
            ( Tuple.first cardPos - Tuple.first columnPos
            , Tuple.second cardPos - Tuple.second columnPos
            )

        ( Nothing, Just columnPos ) ->
            ( minMax
                (negate (Tuple.first columnPos))
                (if index + 1 == List.length ui.columns then
                    0
                 else
                     minColumnWidth * 2
                )
                (Tuple.first ui.dragPosition - Tuple.first columnPos)
            , max
                0
                (Tuple.second ui.dragPosition - Tuple.second columnPos)
            )

        _ ->
            ( 0, 0 )


setColumnPosition : Int -> ( Int, Int ) -> Ui -> Ui
setColumnPosition index position ui =
    { ui
        | columnPositions =
            Dict.insert
                index
                position
                ui.columnPositions
    }


getSpellState : Int -> Ui -> CardState
getSpellState index ui =
    Dict.get index ui.spellStates
        |> Maybe.withDefault Collapsed


setSpellState : CardState -> Int -> Ui -> Ui
setSpellState state index ui =
    { ui | spellStates = Dict.insert index state ui.spellStates }


toggleSpellState : Int -> Ui -> Ui
toggleSpellState index ui =
    case getSpellState index ui of
        Open ->
            setSpellState Collapsed index ui

        Collapsed ->
            setSpellState Open index ui


setCardContentHeight : Card -> Int -> Ui -> Ui
setCardContentHeight card height ui =
    { ui
        | cardContentHeights =
            Dict.insert
                (cardId card)
                height
                ui.cardContentHeights
    }


removeCardContentHeight : Card -> Ui -> Ui
removeCardContentHeight card ui =
    { ui
        | cardContentHeights =
            Dict.remove
                (cardId card)
                ui.cardContentHeights
    }


addCardWaitingForFrame : Card -> CardState -> Ui -> Ui
addCardWaitingForFrame card cardState ui =
    { ui
        | cardsWaitingForFrame =
            ui.cardsWaitingForFrame ++ [ ( card, cardState ) ]
                |> List.Extra.uniqueBy (Tuple.first >> cardId)
    }


removeCardWaitingForFrame : Card -> Ui -> Ui
removeCardWaitingForFrame card ui =
    { ui
        | cardsWaitingForFrame =
            List.filter
                (Tuple.first >> (/=) card)
                ui.cardsWaitingForFrame
    }


setRowPosition : DraggableElement -> Int -> Ui -> Ui
setRowPosition element position ui =
    { ui
        | rowPositions =
            Dict.update
                (draggableElementCardId element)
                (\maybeDict ->
                    Maybe.withDefault Dict.empty maybeDict
                        |> Dict.insert
                            (draggableElementRowId element)
                            position
                        |> Just
                )
                ui.rowPositions
    }


setRowContainerPosition : Card -> PositionAndSize -> Ui -> Ui
setRowContainerPosition card position ui =
    { ui
        | rowContainerPositions =
            Dict.insert
                (cardId card)
                position
                ui.rowContainerPositions
    }


getFloatingRowPosition : Ui -> DraggableElement -> ( Int, Int )
getFloatingRowPosition ui element =
    let
        maybeRowPos =
            Dict.get (draggableElementId element) ui.movingElements

        maybeContainerPos =
            Dict.get (draggableElementCardId element) ui.rowContainerPositions
    in
    case ( maybeRowPos, maybeContainerPos ) of
        ( Just rowPos, Just containerPos ) ->
            ( Tuple.first rowPos - round containerPos.x
            , Tuple.second rowPos - round containerPos.y
            )

        ( Nothing, Just containerPos ) ->
            ( Tuple.first ui.dragPosition - round containerPos.x
            , minMax
                0
                (round containerPos.height - ui.dragHeight)
                (Tuple.second ui.dragPosition - round containerPos.y)
            )

        _ ->
            ( 0, 0 )
