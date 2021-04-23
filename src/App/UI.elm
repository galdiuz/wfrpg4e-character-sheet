module App.UI exposing (view)

import App exposing (Model)
import App.Css
import App.Msg as Msg exposing (Msg)
import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as Events


view : Model -> Html Msg
view model =
    Html.div
        []
        [ Html.node "style" [] [ Html.text App.Css.css ]
        , viewC12cs model
        , viewExperience model
        ]


viewC12cs model =
    Html.table
        []
        [ Html.tr
            []
            (List.append
                [ Html.th [] []
                ]
                (List.map
                    (\c12c ->
                        Html.th
                            []
                            [ Html.text (App.c12cToString c12c) ]
                    )
                    App.allC12cs
                )
            )
        , Html.tr
            []
            (List.append
                [ Html.td
                    []
                    [ Html.text "Initial" ]
                ]
                (viewC12csInputRow model.character.c12csInitial Msg.SetC12csInitial)
            )
        , Html.tr
            []
            (List.append
                [ Html.td
                    []
                    [ Html.text "Advances" ]
                ]
                (viewC12csInputRow model.character.c12csAdvances Msg.SetC12csAdvances)
            )
        , Html.tr
            []
            (List.append
                [ Html.td
                    []
                    [ Html.text "Current" ]
                ]
                (List.map
                    (\c12c ->
                        Html.td
                            []
                            [ App.addC12cs model.character.c12csInitial model.character.c12csAdvances
                                |> App.getC12c c12c
                                |> String.fromInt
                                |> Html.text
                            ]
                    )
                    App.allC12cs
                )
            )
        ]


viewC12csInputRow c12cs onInput =
    List.map
        (\c12c ->
            Html.td
                []
                [ viewNumberInput
                    { onInput = onInput c12c
                    , value = App.getC12c c12c c12cs
                    }
                ]
        )
        App.allC12cs



viewNumberInput data =
    Html.input
        [ HA.type_ "number"
        , HA.class "number-input"
        , HA.value (String.fromInt data.value)
        , Events.onInput data.onInput
        ]
        []


viewExperience model =
    Html.div
        []
        [ Html.text "Spent: : "
        , App.c12csCost model.character.c12csAdvances
            |> String.fromInt
            |> Html.text
        ]
