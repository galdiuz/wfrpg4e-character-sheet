module Css.Dark_Source exposing (declarations)

import Css.Base_Source exposing (class)
import Webbhuset.Css as Css
import Webbhuset.Css.Selector as Selector


color =
    { background =
        { backdrop = Css.gray 40
        , primary = Css.gray 56
        , secondary = Css.gray 72
        }
    , border =
        { default = Css.gray 96
        , focus = Css.gray 176
        , hover = Css.gray 128
        }
    , text =
        { primary = Css.gray 221
        , secondary = Css.gray 144
        }
    }


declarations : List Css.Declaration
declarations =
    [ Css.select Css.anyElement
        [ Css.color Css.inherit
        ]
    , Css.select (Css.element "body")
        [ Css.backgroundColor color.background.backdrop
        , Css.color color.text.primary
        ]
    , Css.select (Css.element "option")
        [ Css.backgroundColor color.background.backdrop
        ]


    -- Components
    , class "button"
        [ Css.backgroundColor color.background.backdrop
        , Css.onHover
            [ Css.backgroundColor color.text.primary
            , Css.color color.background.backdrop
            ]
        , Css.onFocusVisible
            [ Css.borderColor color.border.focus
            ]
        ]
    , class "input"
        [ Css.borderBottomColor color.border.default
        , Css.borderLeftColor (Css.rgba 0 0 0 0)
        , Css.borderRightColor (Css.rgba 0 0 0 0)
        , Css.borderTopColor (Css.rgba 0 0 0 0)
        , Css.onFocusVisible
            [ Css.borderColor color.border.focus
            ]
        , Css.onHover
            [ Css.onNot (Selector.select (Selector.element ":focus"))
                [ Css.borderColor color.border.hover
                ]
            ]
        ]
    , class "select"
        [ Css.onFocusVisible
            [ Css.borderColor color.border.focus
            ]
        ]
    , class "label"
        [ Css.color color.text.secondary
        , Css.onChild (Css.anyElement)
            [ Css.color color.text.primary ]
        ]


    -- Specific elements
    , class "card"
        [ Css.backgroundColor color.background.primary
        ]
    , class "card-header"
        [ Css.backgroundColor color.background.secondary
        ]
    , class "card-header-icon"
        [ Css.backgroundColor color.background.backdrop
        ]
    , class "list-row"
        [ Css.onNthChild "odd"
            [ Css.backgroundColor (Css.gray 48)
            ]
        ]
    ]
        |> List.append Css.Base_Source.declarations
