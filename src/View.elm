module View exposing (view)

import Model exposing (Model)
import Css
import Character as Character
import Msg as Msg exposing (Msg)
import Ui
import Draggable
import Html exposing (Html)
import Html.Attributes as HA
import Html.Attributes.Extra as HAE
import Html.Events as Events


view : Model -> Html Msg
view model =
    Html.div
        []
        [ Html.node "style" [] [ Html.text Css.css ]
        , viewHeader
        , viewContent model
        , viewDraggedCard model
        ]


viewDraggedCard model =
    case model.ui.draggedCard of
        Just card ->
            Html.div
                [ HA.style "position" "absolute"
                , HA.style "left" (String.fromInt (Tuple.first model.ui.position) ++ "px")
                , HA.style "top" (String.fromInt (Tuple.second model.ui.position) ++ "px")
                ]
                [ viewCard model card ]

        Nothing ->
            Html.text ""


viewHeader : Html Msg
viewHeader =
    Html.div
        []
        [ viewFile
        ]


viewContent : Model -> Html Msg
viewContent model =
    Html.div
        [ HA.class "content"
        , HA.style "flex-direction" "row"
        ]
        (List.map
            (\cards ->
                Html.div
                    [ HA.style "width" "50%"
                    ]
                    (List.map
                        (\card ->
                            Html.div
                                [ HAE.attributeIf
                                    (Just card == model.ui.draggedCard)
                                    (HA.style "opacity" "0.2")
                                , HA.id (Ui.cardId card)
                                ]
                                [ viewCard model card ]
                        )
                        cards
                    )
            )
            model.ui.columns
        )


viewCard : Model -> Ui.Card -> Html Msg
viewCard model card =
    Html.div
        [ HA.class "card"
        ]
        [ Html.div
            []
            [ Html.text (Ui.cardTitle card)
            , Html.span
                (List.append
                    [ Draggable.mouseTrigger card Msg.DragMsg
                    , HA.style "cursor" "move"
                    ]
                    (Draggable.touchTriggers card Msg.DragMsg)
                )
                [ Html.text "Drag" ]
            ]
        , case card of
            Ui.C12cs ->
                viewC12cs model

            Ui.Experience ->
                viewExperience model

            Ui.Information ->
                viewInformation model

            Ui.Skills ->
                viewSkills model

            Ui.Talents ->
                viewTalents model
        ]


viewFile : Html Msg
viewFile =
    Html.div
        []
        [ viewButton
            { onClick = Msg.Save
            , text = "Save"
            }
        , viewButton
            { onClick = Msg.Load
            , text = "Load"
            }
        ]


viewInformation : Model -> Html Msg
viewInformation model =
    Html.div
        []
        [ Html.text "Name"
        , viewTextInput
            { onInput = Msg.SetInformation "name"
            , value = model.character.info.name
            }
        , Html.text "Species"
        , viewTextInput
            { onInput = Msg.SetInformation "species"
            , value = model.character.info.species
            }
        , Html.text "Class"
        , viewTextInput
            { onInput = Msg.SetInformation "class"
            , value = model.character.info.class
            }
        , Html.text "Career Path"
        , viewTextInput
            { onInput = Msg.SetInformation "careerPath"
            , value = model.character.info.careerPath
            }
        , Html.text "Career"
        , viewTextInput
            { onInput = Msg.SetInformation "career"
            , value = model.character.info.career
            }
        , Html.text "Status"
        , viewTextInput
            { onInput = Msg.SetInformation "status"
            , value = model.character.info.status
            }
        , Html.text "Age"
        , viewTextInput
            { onInput = Msg.SetInformation "age"
            , value = model.character.info.age
            }
        , Html.text "Height"
        , viewTextInput
            { onInput = Msg.SetInformation "height"
            , value = model.character.info.height
            }
        , Html.text "Hair"
        , viewTextInput
            { onInput = Msg.SetInformation "hair"
            , value = model.character.info.hair
            }
        , Html.text "Eyes"
        , viewTextInput
            { onInput = Msg.SetInformation "eyes"
            , value = model.character.info.eyes
            }
        ]


viewC12cs : Model -> Html Msg
viewC12cs model =
    Html.div
        [ HA.style "display" "grid"
        , HA.style "flex-wrap" "wrap"
        ]
        (List.map (viewC12c model) Character.allC12cs)


viewC12c model c12c =
    Html.div
        []
        [ Html.text (Character.c12cToFullString c12c)
        , viewNumberInput
            { onInput = Msg.SetC12csInitial c12c
            , value = Character.getC12c c12c model.character.c12csInitial
            }
        , viewNumberInput
            { onInput = Msg.SetC12csAdvances c12c
            , value = Character.getC12c c12c model.character.c12csAdvances
            }
        , Character.getC12cs model.character
            |> Character.getC12c c12c
            |> String.fromInt
            |> Html.text
        ]


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


viewTextareaInput : TextInputData msg -> Html msg
viewTextareaInput data =
    Html.textarea
        [ HA.class "textarea-input"
        , HA.value data.value
        , HA.attribute "rows" "1"
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


viewExperience : Model -> Html Msg
viewExperience model =
    Html.div
        []
        [ viewExperienceTable model
        , viewAdjustments model
        ]


viewExperienceTable : Model -> Html Msg
viewExperienceTable model =
    Html.table
        []
        [ Html.tr
            []
            [ Html.th [] [ Html.text "Total" ]
            , Html.th [] [ Html.text "Spent" ]
            , Html.th [] [ Html.text "Current" ]
            ]
        , Html.tr
            []
            [ Html.td
                []
                [ viewNumberInput
                    { onInput = Msg.SetExperience
                    , value = model.character.experience
                    }
                ]
            , Html.td
                []
                [ Character.spentExp model.character
                    |> String.fromInt
                    |> Html.text
                ]
            , Html.td
                []
                [ Character.currentExp model.character
                    |> String.fromInt
                    |> Html.text
                ]
            ]
        ]


viewSkills : Model -> Html Msg
viewSkills model =
    Html.div
        []
        [ viewBasicSkills model
        , viewAdvancedSkills model
        ]


viewBasicSkills : Model -> Html Msg
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


viewBasicSkillRow : Model -> Int -> Character.Skill -> Html Msg
viewBasicSkillRow model index skill =
    Html.tr
        []
        [ Html.td
            []
            [ Html.text skill.name ]
        , Html.td
            []
            [ Html.text (Character.c12cToString skill.c12c) ]
        , Html.td
            []
            [ Character.getC12cs model.character
                |> Character.getC12c skill.c12c
                |> String.fromInt
                |> Html.text
            ]
        , viewNumberInput
            { onInput = Msg.SetBasicSkillAdvances index
            , value = skill.advances
            }
        , Html.td
            []
            [ Character.skillValue model.character skill
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


viewAdvancedSkillRow : Model -> Int -> Character.Skill -> Html Msg
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
            [ Character.getC12cs model.character
                |> Character.getC12c skill.c12c
                |> String.fromInt
                |> Html.text
            ]
        , viewNumberInput
            { onInput = Msg.SetAdvancedSkillAdvances index
            , value = skill.advances
            }
        , Html.td
            []
            [ Character.skillValue model.character skill
                |> String.fromInt
                |> Html.text
            ]
        ]


viewC12cSelect : Int -> Character.Skill -> Html Msg
viewC12cSelect index skill =
    viewSelect
        { options = Character.allC12cs
        , label = Character.c12cToString
        , value = Character.c12cToString
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


viewTalents : Model -> Html Msg
viewTalents model =
    Html.table
        []
        (List.concat
            [ [ Html.tr
                []
                [ Html.th [] [ Html.text "Name" ]
                , Html.th [] [ Html.text "Times taken" ]
                , Html.th [] [ Html.text "Description" ]
                ]
              ]
            , List.indexedMap viewTalentRow model.character.talents
            , [ viewButton
                { onClick = Msg.AddTalent
                , text = "Add"
                }
              ]
            ]
        )


viewTalentRow : Int -> Character.Talent -> Html Msg
viewTalentRow index talent =
    Html.tr
        []
        [ Html.td
            []
            [ viewTextInput
                { onInput = Msg.SetTalentName index
                , value = talent.name
                }
            ]
        , Html.td
            []
            [ viewNumberInput
                { onInput = Msg.SetTalentTimesTaken index
                , value = talent.timesTaken
                }
            ]
        , Html.td
            []
            [ viewTextareaInput
                { onInput = Msg.SetTalentDescription index
                , value = talent.description
                }
            ]
        ]


viewAdjustments : Model -> Html Msg
viewAdjustments model =
    Html.table
        []
        (List.concat
            [ [ Html.tr
                []
                [ Html.th [] [ Html.text "Value" ]
                , Html.th [] [ Html.text "Description" ]
                ]
              ]
            , List.indexedMap viewAdjustmentRow model.character.expAdjustments
            , [ viewButton
                { onClick = Msg.AddExpAdjustment
                , text = "Add"
                }
              ]
            ]
        )


viewAdjustmentRow : Int -> Character.ExpAdjustment -> Html Msg
viewAdjustmentRow index adjustment =
    Html.tr
        []
        [ Html.td
            []
            [ viewNumberInput
                { onInput = Msg.SetExpAdjustmentValue index
                , value = adjustment.value
                }
            ]
        , Html.td
            []
            [ viewTextareaInput
                { onInput = Msg.SetExpAdjustmentDescription index
                , value = adjustment.description
                }
            ]
        ]
