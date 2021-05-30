module Css.Base_Source exposing (class, declarations)

import Webbhuset.Css as Css
import Webbhuset.Css.Selector as Selector


class : String -> (List Css.Nested -> Css.Declaration)
class name =
    Css.select (Css.class name)


typography =
    { large = Css.fontSize (Css.px 20)
    , regular = Css.fontSize (Css.px 16)
    , small = Css.fontSize (Css.px 14)
    }


declarations : List Css.Declaration
declarations =
    [ Css.select Css.anyElement
        [ Css.boxSizing Css.inherit
        , Css.fontFamily [ Css.quote "Times New Roman" ]
        , Css.onAfter
            [ Css.boxSizing Css.inherit
            ]
        , Css.onBefore
            [ Css.boxSizing Css.inherit
            ]
        ]
    , Css.select (Css.element "body")
        [ Css.boxSizing Css.borderBox
        ]
    , Css.select (Css.element "input")
        [ Css.hasAttribute "type=number"
            [ Css.appearance (Css.str "textfield")
            ]
        , Css.onPseudoElement "-webkit-outer-spin-button"
            [ Css.appearance Css.none
            ]
        , Css.onPseudoElement "-webkit-inner-spin-button"
            [ Css.appearance Css.none
            ]
        , Css.onPseudoElement "-webkit-calendar-picker-indicator"
            [ Css.display Css.none
            ]
        ]


    -- Layout
    , class "column"
        [ Css.display Css.flex
        , Css.flexDirection Css.column
        , Css.gap (Css.px 4)
        ]
    , class "row"
        [ Css.alignItems Css.center
        , Css.display Css.flex
        , Css.flexDirection Css.row
        , Css.gap (Css.px 8)
        , Css.justifyContent Css.spaceBetween
        ]


    -- Animations
    , class "fading"
        [ Css.opacity 0.0
        , Css.transition "opacity 0.5s ease-in-out"
        ]
    , class "transparent"
        [ Css.opacity 0.2
        ]
    , class "floating"
        [ Css.position Css.absolute
        , Css.width (Css.percent 100)
        , Css.zIndex 10
        ]
    , class "moving"
        [ Css.transitionDuration (Css.seconds 1)
        , Css.transitionProperty "top, left"
        , Css.transitionTimingFunction (Css.cubicBezier 0.22 1 0.36 1)
        ]


    -- Components
    , class "button"
        [ Css.borderRadius (Css.px 4)
        , Css.borderStyle Css.solid
        , Css.borderWidth (Css.px 1)
        , Css.padding2 (Css.px 1) (Css.px 6)
        , typography.regular
        , Css.transitionDuration (Css.seconds 0.15)
        , Css.transitionProperty "background-color, color"
        , Css.transitionTimingFunction (Css.str "ease-in-out")
        , Css.whiteSpace Css.nowrap
        , Css.width (Css.percent 100)
        ]
    , class "input"
        [ Css.backgroundColor Css.inherit
        , Css.borderRadius (Css.px 2)
        , Css.borderStyle (Css.str "solid solid dashed")
        , Css.borderWidth (Css.px 1)
        , typography.small
        , Css.transition "border-color 0.15s ease-in-out"
        , Css.width (Css.percent 100)
        ]
    , class "label"
        [ typography.small
        ]
    , class "select"
        [ Css.backgroundColor Css.inherit
        , Css.width (Css.percent 100)
        , typography.small
        ]
    , class "textarea"
        [ Css.position Css.relative
        , Css.onChild (Css.anyElement)
            [ Css.maxHeight (Css.px 80)
            , Css.overflow Css.auto
            , Css.padding (Css.px 1)
            , Css.property "overflow-wrap" (Css.str "anywhere")
            , Css.whiteSpace (Css.str "break-spaces")
            , typography.small
            ]
        , Css.onChild (Css.element "div")
            [ Css.visibility Css.hidden
            ]
        , Css.onChild (Css.element "textarea")
            [ Css.backgroundColor Css.inherit
            , Css.height (Css.percent 100)
            , Css.left (Css.num 0)
            , Css.position Css.absolute
            , Css.top (Css.num 0)
            , Css.width (Css.percent 100)
            , Css.property "resize" Css.none
            ]
        ]


    -- Specific elements
    , class "card"
        [ Css.backgroundColor (Css.gray 255)
        , Css.borderRadius (Css.px 4)
        , Css.borderStyle Css.solid
        , Css.borderWidth (Css.px 0)
        , Css.margin4 (Css.px 4) (Css.px 2) (Css.px 4) (Css.px 8)
        ]
    , class "card-content"
        [ Css.overflowY Css.hidden
        , Css.transitionDuration (Css.seconds 0.35)
        , Css.transitionProperty "max-height, opacity, padding"
        , Css.transitionTimingFunction (Css.cubicBezier 0.4 0 0.2 1)
        ]
    , class "card-content-collapsed"
        [ Css.maxHeight (Css.px 0)
        , Css.paddingBottom (Css.px 0)
        , Css.paddingTop (Css.px 0)
        , Css.opacity 0
        ]
    , class "card-content-inner"
        [ Css.padding (Css.px 8)
        , Css.transformOrigin (Css.str "top")
        , Css.transitionDuration (Css.seconds 0.35)
        , Css.transitionProperty "transform"
        , Css.transitionTimingFunction (Css.cubicBezier 0.4 0 0.2 1)
        ]
    , class "card-content-inner-collapsed"
        [ Css.transform "scale(1, 0)"
        ]
    , class "card-header"
        [ Css.borderTopRightRadius (Css.px 4)
        , Css.fontWeight (Css.num 700)
        , Css.padding (Css.px 4)
        , Css.position Css.relative
        , typography.large
        ]
    , class "card-header-icon"
        [ Css.alignItems Css.center
        , Css.backgroundColor (Css.gray 255)
        , Css.borderRadius (Css.percent 50)
        , Css.borderStyle Css.solid
        , Css.borderWidth (Css.px 1)
        , Css.display Css.flex
        , Css.height (Css.px 40)
        , Css.fontSize (Css.px 34)
        , Css.justifyContent Css.center
        , Css.left (Css.px -6)
        , Css.position Css.absolute
        , Css.width (Css.px 40)
        , Css.zIndex 1
        ]
    , class "card-header-title"
        [ Css.paddingLeft (Css.px 36)
        , Css.flex1 (Css.num 1)
        ]
    , class "content"
        [ Css.display Css.flex
        , Css.flex1 (Css.num 1)
        , Css.flexDirection Css.row
        , Css.gap (Css.px 4)
        , Css.position Css.relative
        ]
    , class "cursor-move"
        [ Css.cursor (Css.str "move")
        ]
    , class "cursor-sort"
        [ Css.cursor (Css.str "ns-resize")
        ]
    , class "header"
        [ Css.padding (Css.px 2)
        ]
    , class "list-row"
        [ Css.onNthChild "odd"
            [ Css.backgroundColor (Css.gray 222)
            ]
        ]
    ]
