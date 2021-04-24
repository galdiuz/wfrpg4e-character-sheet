module App.UI exposing (view)

import App exposing (Model)
import App.Css
import App.Msg as Msg exposing (Msg)
import Html exposing (Html)
import Html.Attributes as HA
import Html.Attributes.Extra as HAE
import Html.Events as Events


view : Model -> Html Msg
view model =
    Html.div
        []
        [ Html.node "style" [] [ Html.text App.Css.css ]
        , viewExperience model
        , viewC12cs model
        , viewBasicSkills model
        , viewAdvancedSkills model
        ]


viewC12cs : App.Model -> Html Msg
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
                            [ App.getC12cs model.character
                                |> App.getC12c c12c
                                |> String.fromInt
                                |> Html.text
                            ]
                    )
                    App.allC12cs
                )
            )
        ]


viewC12csInputRow : App.C12cs -> (App.C12c -> String -> Msg) -> List (Html Msg)
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


type alias TextInputData msg =
    { onInput : String -> msg
    , value : String
    }


viewTextInput : TextInputData msg -> Html msg
viewTextInput data =
    Html.input
        [ HA.type_ "text"
        , HA.class "text-input"
        , HA.value data.value
        , Events.onInput data.onInput
        ]
        []


type alias NumberInputData msg =
    { onInput : String -> msg
    , value : Int
    }


viewNumberInput : NumberInputData msg -> Html msg
viewNumberInput data =
    Html.input
        [ HA.type_ "number"
        , HA.class "number-input"
        , HA.value (String.fromInt data.value)
        , Events.onInput data.onInput
        ]
        []


type alias ButtonData msg =
    { onClick : msg
    , text : String
    }


viewButton : ButtonData msg -> Html msg
viewButton data =
    Html.button
        [ Events.onClick data.onClick
        ]
        [ Html.text data.text ]


viewExperience : App.Model -> Html Msg
viewExperience model =
    Html.div
        []
        [ Html.text "Spent: "
        , App.spentExp model.character
            |> String.fromInt
            |> Html.text
        ]


viewBasicSkills : App.Model -> Html Msg
viewBasicSkills model =
    Html.table
        []
        (List.append
            [ Html.tr
                []
                [ Html.th [] [ Html.text "Name" ]
                , Html.th [ HA.colspan 2 ] [ Html.text "Characteristic" ]
                , Html.th [] [ Html.text "Adv" ]
                , Html.th [] [ Html.text "Skill" ]
                ]
            ]
            (List.indexedMap (viewBasicSkillRow model) model.character.basicSkills)
        )


viewBasicSkillRow : App.Model -> Int -> App.Skill -> Html Msg
viewBasicSkillRow model index skill =
    Html.tr
        []
        [ Html.td
            []
            [ Html.text skill.name ]
        , Html.td
            []
            [ Html.text (App.c12cToString skill.c12c) ]
        , Html.td
            []
            [ App.getC12cs model.character
                |> App.getC12c skill.c12c
                |> String.fromInt
                |> Html.text
            ]
        , viewNumberInput
            { onInput = Msg.SetBasicSkillAdvances index
            , value = skill.advances
            }
        , Html.td
            []
            [ App.skillValue model.character skill
                |> String.fromInt
                |> Html.text
            ]
        ]


viewAdvancedSkills : Model -> Html Msg
viewAdvancedSkills model =
    Html.table
        []
        (List.concat
            [ [ Html.tr
                []
                [ Html.th [] [ Html.text "Name" ]
                , Html.th [ HA.colspan 2 ] [ Html.text "Characteristic" ]
                , Html.th [] [ Html.text "Adv" ]
                , Html.th [] [ Html.text "Skill" ]
                ]
              ]
            , (List.indexedMap (viewAdvancedSkillRow model) model.character.advancedSkills)
            , [ viewButton
                { onClick = Msg.AddAdvancedSkill
                , text = "Add"
                }
              ]
            ]
        )


viewAdvancedSkillRow : App.Model -> Int -> App.Skill -> Html Msg
viewAdvancedSkillRow model index skill =
    Html.tr
        []
        [ Html.td
            []
            [ viewTextInput
                { onInput = Msg.SetAdvancedSkillName index
                , value = skill.name
                }
            ]
        , Html.td
            []
            [ viewC12cSelect index skill
            ]
        , Html.td
            []
            [ App.getC12cs model.character
                |> App.getC12c skill.c12c
                |> String.fromInt
                |> Html.text
            ]
        , viewNumberInput
            { onInput = Msg.SetAdvancedSkillAdvances index
            , value = skill.advances
            }
        , Html.td
            []
            [ App.skillValue model.character skill
                |> String.fromInt
                |> Html.text
            ]
        ]


viewC12cSelect : Int -> App.Skill -> Html Msg
viewC12cSelect index skill =
    viewSelect
        { options = App.allC12cs
        , label = App.c12cToString
        , value = App.c12cToString
        , selected = Just skill.c12c
        , onInput = Msg.SetAdvancedSkillC12c index
        }


type alias SelectData item msg =
    { options : List item
    , label : item -> String
    , value : item -> String
    , selected : Maybe item
    , onInput : String -> msg
    }


viewSelect : SelectData a msg -> Html msg
viewSelect data =
    Html.select
        [ Events.onInput (data.onInput)
        ]
        (List.map
            (\option ->
                Html.option
                    [ HA.selected (data.selected == Just option)
                    ]
                    [ Html.text (data.label option)
                    ]
            )
            data.options
        )
