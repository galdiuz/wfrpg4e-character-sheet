module Ui exposing (..)

import Dict exposing (Dict)
import Draggable
import Icons
import List.Extra


type alias Ui =
    { cardHeights : Dict String Int
    , cardStates : Dict String CardState
    , columns : List (List Card)
    , columnPositions : Dict Int ( Int, Int )
    , drag : Draggable.State Card
    , dragPosition : ( Int, Int )
    , draggedCard : Maybe Card
    , movingCards : Dict String ( Int, Int )
    , spellStates : Dict Int CardState
    , theme : Theme
    , windowWidth : Int
    }


columnId : Int -> String
columnId index =
    "column-" ++ String.fromInt index


emptyUi : Ui
emptyUi =
    { cardHeights = Dict.empty
    , cardStates = Dict.empty
    , columns = []
    , columnPositions = Dict.empty
    , drag = Draggable.init
    , dragPosition = ( 0, 0 )
    , draggedCard = Nothing
    , movingCards = Dict.empty
    , spellStates = Dict.empty
    , theme = Dark
    , windowWidth = 0
    }


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


setMovingCard : Card -> ( Int, Int ) -> Ui -> Ui
setMovingCard card position ui =
    { ui
        | movingCards =
            Dict.insert
                (cardId card)
                position
                ui.movingCards
    }


removeMovingCard : Card -> Ui -> Ui
removeMovingCard card ui =
    { ui
        | movingCards =
            Dict.remove
                (cardId card)
                ui.movingCards
    }


isCardFloating : Ui -> Card -> Bool
isCardFloating ui card =
    ui.draggedCard == Just card
    && ui.dragPosition /= ( 0, 0 )
    || Dict.member (cardId card) ui.movingCards


getFloatingCardPosition : Ui -> Card -> Int -> ( Int, Int )
getFloatingCardPosition ui card index =
    case ( Dict.get (cardId card) ui.movingCards, Dict.get index ui.columnPositions ) of
        ( Just cardPos, Just columnPos ) ->
            ( Tuple.first cardPos - Tuple.first columnPos
            , Tuple.second cardPos - Tuple.second columnPos
            )

        ( _, Just columnPos ) ->
            ( Tuple.first ui.dragPosition - Tuple.first columnPos
            , Tuple.second ui.dragPosition - Tuple.second columnPos
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
