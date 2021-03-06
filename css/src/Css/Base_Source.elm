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
        , Css.onOuterSpinButton
            [ Css.appearance Css.none
            ]
        , Css.onInnerSpinButton
            [ Css.appearance Css.none
            ]
        , Css.onCalendarPickerIndicator
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
        , Css.transitionProperty (Css.str "top, left")
        , Css.transitionTimingFunction (Css.cubicBezier 0.22 1 0.36 1)
        ]


    -- Components
    , class "button"
        [ Css.borderRadius (Css.px 4)
        , Css.borderStyle Css.solid
        , Css.borderWidth (Css.px 1)
        , Css.display Css.flex
        , Css.justifyContent Css.center
        , Css.padding2 (Css.px 2) (Css.px 6)
        , typography.regular
        , Css.transitionDuration (Css.seconds 0.15)
        , Css.transitionProperty (Css.str "background-color, border-color, color")
        , Css.transitionTimingFunction (Css.str "ease-in-out")
        , Css.whiteSpace Css.nowrap
        , Css.width (Css.percent 100)
        , Css.onFocusVisible
            [ Css.outline Css.none
            ]
        ]
    , class "input"
        [ Css.backgroundColor Css.inherit
        , Css.borderRadius (Css.px 2)
        , Css.borderStyle (Css.str "solid solid dashed")
        , Css.borderWidth (Css.px 1)
        , typography.small
        , Css.transition "border-color 0.15s ease-in-out"
        , Css.width (Css.percent 100)
        , Css.onFocusVisible
            [ Css.outline Css.none
            ]
        ]
    , class "label"
        [ typography.small
        ]
    , class "select"
        [ Css.backgroundColor Css.inherit
        , Css.width (Css.percent 100)
        , Css.transition "border-color 0.15s ease-in-out"
        , typography.small
        , Css.onFocusVisible
            [ Css.outline Css.none
            ]
        ]
    , class "textarea"
        [ Css.position Css.relative
        , Css.onChild (Css.anyElement)
            [ Css.maxHeight (Css.px 80)
            , Css.overflow Css.auto
            , Css.padding (Css.px 1)
            , Css.overflowWrap Css.anywhere
            , Css.whiteSpace Css.breakSpaces
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
            , Css.resize Css.none
            , Css.top (Css.num 0)
            , Css.width (Css.percent 100)
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
    , class "collapsible"
        [ Css.overflowY Css.hidden
        , Css.transitionDuration (Css.seconds 0.35)
        , Css.transitionProperty (Css.str "max-height, opacity")
        , Css.transitionTimingFunction (Css.cubicBezier 0.4 0 0.2 1)
        ]
    , class "collapsible-collapsed"
        [ Css.maxHeight (Css.px 0)
        , Css.opacity 0
        ]
    , class "collapsible-inner"
        [ Css.transformOrigin (Css.str "top")
        , Css.transitionDuration (Css.seconds 0.35)
        , Css.transitionProperty (Css.str "transform")
        , Css.transitionTimingFunction (Css.cubicBezier 0.4 0 0.2 1)
        ]
    , class "collapsible-inner-collapsed"
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
        [ Css.transitionDuration (Css.seconds 0.5)
        , Css.transitionProperty (Css.str "background-color")
        , Css.transitionTimingFunction (Css.str "ease-in-out")
        , Css.onNthChild "odd"
            [ Css.backgroundColor (Css.gray 222)
            ]
        , Css.onHover
            [ Css.onDescendant (Css.class "list-row-delete")
                [ Css.display Css.flex ]
            ]
        , Css.onFocusWithin
            [ Css.onDescendant (Css.class "list-row-delete")
                [ Css.display Css.flex ]
            ]
        ]
    , class "list-row-delete"
        [ Css.display Css.none
        , Css.flexDirection Css.row
        , Css.gap (Css.px 4)
        , Css.justifyContent Css.spaceBetween
        , Css.padding2 (Css.px 2) (Css.px 4)
        , Css.position Css.absolute
        , Css.right (Css.px 0)
        , Css.top (Css.percent 100)
        , Css.zIndex 1
        , Css.onHover
            [ Css.display Css.flex ]
        ]
    , class "list-row-delete-confirm"
        [ Css.overflow Css.hidden
        , Css.transitionDuration (Css.seconds 0.35)
        , Css.transitionProperty (Css.str "width")
        , Css.transitionTimingFunction (Css.cubicBezier 0.4 0 0.2 1)
        , Css.width (Css.px 80)
        ]
    ]
