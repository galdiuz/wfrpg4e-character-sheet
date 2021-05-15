module View exposing (view)

import Character as Character
import Css
import Dict
import Draggable
import FontAwesome.Styles
import FontAwesome.Icon as FA
import FontAwesome.Regular
import FontAwesome.Solid
import Html exposing (Html)
import Html.Attributes as HA
import Html.Attributes.Extra as HAE
import Html.Events as Events
import Icons
import Model exposing (Model)
import Msg as Msg exposing (Msg)
import Ui
import Json.Decode as Decode
import Svg
import Svg.Attributes as SA



view : Model -> Html Msg
view model =
    Html.div
        []
        [ Html.node "style" [] [ Html.text Css.css ]
        , case model.ui.theme of
            Ui.Light ->
                Html.text ""

            Ui.Dark ->
                Html.node "style" [] [ Html.text Css.dark ]
        , FontAwesome.Styles.css
        , viewHeader
        , viewContent model
        ]


viewHeader : Html Msg
viewHeader =
    Html.div
        [ HA.style "display" "flex"
        , HA.style "justify-content" "space-between"
        ]
        [ viewFile
        , Html.div
            [ HA.style "display" "flex" ]
            [ viewButton
                { onClick = Msg.CollapseAllCardsPressed
                , text = "Collapse all"
                }
            , viewButton
                { onClick = Msg.ExpandAllCardsPressed
                , text = "Expand all"
                }
            ]
        ]


viewContent : Model -> Html Msg
viewContent model =
    Html.div
        [ HA.class "content"
        ]
        (List.indexedMap
            (\index cards ->
                Html.div
                    [ HA.class "content-column"
                    , HA.id (Ui.columnId index)
                    ]
                    (List.map
                        (\card ->
                            [ Html.div
                                [ HAE.attributeIf
                                    (Just card == model.ui.draggedCard)
                                    (HA.class  "card-container-transparent")
                                , HAE.attributeIf
                                    (Dict.member (Ui.cardId card) model.ui.movingCards)
                                    (HA.class  "card-container-fading")
                                , HA.id (Ui.cardId card)
                                ]
                                [ viewCard model card ]

                            , if Ui.isCardFloating model.ui card then
                                let
                                    ( left, top ) =
                                        Ui.getFloatingCardPosition model.ui card index
                                in
                                Html.div
                                    [ HA.class "card-container-floating"
                                    , HAE.attributeIf
                                        (Dict.member (Ui.cardId card) model.ui.movingCards)
                                        (HA.class "card-container-moving")
                                    , HA.style "left" (String.fromInt left ++ "px")
                                    , HA.style "top" (String.fromInt top ++ "px")
                                    ]
                                    [ viewCard model card ]

                              else
                                  Html.text ""
                            ]
                        )
                        cards
                        |> List.concat
                    )
            )
            model.ui.columns
        )


viewCard : Model -> Ui.Card -> Html Msg
viewCard model card =
    Html.div
        [ HA.class "card" ]
        [ Html.div
            [ HA.class "card-header" ]
            [ Html.div
                [ HA.class "card-header-icon"
                , Draggable.mouseTrigger card Msg.DragMsgReceived
                ]
                [ Icons.view (Ui.cardIcon card) ]
            , Html.span
                [ HA.class "card-header-title"
                , Draggable.mouseTrigger card Msg.DragMsgReceived
                ]
                [ Html.text (Ui.cardTitle card)
                ]
            , Html.div
                [ HA.class "card-header-buttons" ]
                [ Html.div
                    []
                    [ Html.button
                        [ HA.class "button-style"
                        , Events.onClick (Msg.ToggleCardStatePressed card)
                        ]
                        [ case Ui.getCardState card model.ui of
                            Ui.Open ->
                                FA.viewIcon FontAwesome.Regular.windowMinimize

                            Ui.Collapsed ->
                                FA.viewIcon FontAwesome.Regular.windowMaximize
                        ]
                    ]
                ]
            ]
        , case Ui.getCardState card model.ui of
            Ui.Open ->
                Html.div
                    [ HA.class "card-content"
                    ]
                    [ case card of
                        Ui.Armour ->
                            viewArmour model

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

                        Ui.Trappings ->
                            viewTrappings model

                        Ui.Wealth ->
                            viewWealth model

                        Ui.Weapons ->
                            viewWeapons model

                        Ui.Wounds ->
                            viewWounds model
                    ]

            Ui.Collapsed ->
                Html.text ""
        ]


viewFile : Html Msg
viewFile =
    Html.div
        [ HA.style "display" "flex" ]
        [ Html.div
            [ HA.style "width" "50px" ]
            [ viewButton
                { onClick = Msg.SavePressed
                , text = "Save"
                }
            ]
        , Html.div
            [ HA.style "width" "50px" ]
            [ viewButton
                { onClick = Msg.LoadPressed
                , text = "Load"
                }
            ]
        ]


viewInformation : Model -> Html Msg
viewInformation model =
    Html.div
        [ HA.style "display" "flex"
        , HA.style "flex-flow" "column"
        , HA.style "gap" "8px"
        ]
        [ viewTextInputWithLabel
            { id = "information-name"
            , label = "Name"
            , onInput = Msg.TextFieldChanged (Character.setInformation Character.Name)
            , value = model.character.info.name
            }
        , Html.div
            [ HA.style "display" "flex"
            , HA.style "flex-flow" "row"
            , HA.style "gap" "8px"
            ]
            [ viewTextInputWithLabel
                { id = "information-species"
                , label = "Species"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Species)
                , value = model.character.info.species
                }
            , viewTextInputWithLabel
                { id = "information-class"
                , label = "Class"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Class)
                , value = model.character.info.class
                }
            ]
        , Html.div
            [ HA.style "display" "flex"
            , HA.style "flex-flow" "row"
            , HA.style "gap" "8px"
            ]
            [ viewTextInputWithLabel
                { id = "information-career-path"
                , label = "Career Path"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.CareerPath)
                , value = model.character.info.careerPath
                }
            , viewTextInputWithLabel
                { id = "information-career"
                , label = "Career"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Career)
                , value = model.character.info.career
                }
            , viewTextInputWithLabel
                { id = "information-status"
                , label = "Status"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Status)
                , value = model.character.info.status
                }
            ]
        , Html.div
            [ HA.style "display" "flex"
            , HA.style "flex-flow" "row"
            , HA.style "gap" "8px"
            ]
            [ viewTextInputWithLabel
                { id = "information-age"
                , label = "Age"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Age)
                , value = model.character.info.age
                }
            , viewTextInputWithLabel
                { id = "information-height"
                , label = "Height"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Height)
                , value = model.character.info.height
                }
            , viewTextInputWithLabel
                { id = "information-hair"
                , label = "Hair"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Hair)
                , value = model.character.info.hair
                }
            , viewTextInputWithLabel
                { id = "information-eyes"
                , label = "Eyes"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Eyes)
                , value = model.character.info.eyes
                }
            ]
        ]


viewC12cs : Model -> Html Msg
viewC12cs model =
    Html.div
        [ HA.class "grid"
        , HA.style "grid-template-columns" "2fr 1fr 1fr 1fr"
        ]
        (List.concat
            [ [ Html.span
                [ HA.class "label" ]
                [ Html.text "Characteristic" ]
              , Html.span
                [ HA.class "label" ]
                [ Html.text "Initial" ]
              , Html.span
                [ HA.class "label" ]
                [ Html.text "Advances" ]
              , Html.span
                [ HA.class "label" ]
                [ Html.text "Current" ]
              ]
            , List.map
                (\c12c ->
                    [ Html.span
                        []
                        [ Html.text (Character.c12cToFullString c12c) ]
                    , viewNumberInput
                        { onInput = Msg.NumberFieldChanged (Character.setC12csInitial c12c)
                        , value = Character.getC12c c12c model.character.c12csInitial
                        }
                    , viewNumberInput
                        { onInput = Msg.NumberFieldChanged (Character.setC12csAdvances c12c)
                        , value = Character.getC12c c12c model.character.c12csAdvances
                        }
                    , Html.span
                        []
                        [ Character.getC12cs model.character
                            |> Character.getC12c c12c
                            |> String.fromInt
                            |> Html.text
                        ]
                    ]
                )
                Character.allC12cs
                |> List.concat
            ]
        )


viewTextInput :
    { onInput : String -> msg
    , value : String
    }
    -> Html msg
viewTextInput data =
    Html.input
        [ HA.type_ "text"
        , HA.value data.value
        , Events.onInput data.onInput
        ]
        []


viewTextInputWithLabel :
    { id : String
    , label : String
    , onInput : String -> msg
    , value : String
    }
    -> Html msg
viewTextInputWithLabel data =
    Html.div
        [ HA.style "flex" "1" ]
        [ Html.label
            [ HA.class "label"
            , HA.for data.id
            ]
            [ Html.text data.label ]
        , Html.input
            [ HA.id data.id
            , HA.type_ "text"
            , HA.value data.value
            , Events.onInput data.onInput
            ]
            []
        ]


viewTextareaInput :
    { onInput : String -> msg
    , value : String
    }
    -> Html msg
viewTextareaInput data =
    Html.textarea
        [ HA.attribute "rows" "1"
        , HA.value data.value
        , Events.onInput data.onInput
        ]
        []


viewNumberInput :
    { onInput : String -> msg
    , value : Int
    }
    -> Html msg
viewNumberInput data =
    Html.input
        [ HA.type_ "number"
        , HA.value (String.fromInt data.value)
        , Events.onInput data.onInput
        ]
        []


viewNumberInputWithLabel :
    { id: String
    , label : String
    , onInput : String -> msg
    , value : Int
    }
    -> Html msg
viewNumberInputWithLabel data =
    Html.div
        [ HA.style "flex" "1" ]
        [ Html.label
            [ HA.class "label"
            , HA.for data.id
            ]
            [ Html.text data.label ]
        , Html.input
            [ HA.id data.id
            , HA.type_ "number"
            , HA.value (String.fromInt data.value)
            , Events.onInput data.onInput
            ]
            []
        ]


type alias ButtonData msg =
    { onClick : msg
    , text : String
    }


viewButton : ButtonData msg -> Html msg
viewButton data =
    Html.button
        [ HA.class "button-style"
        , Events.onClick data.onClick
        , HA.style "width" "100%"
        ]
        [ Html.text data.text ]


viewExperience : Model -> Html Msg
viewExperience model =
    Html.div
        [ HA.style "display" "flex"
        , HA.style "flex-flow" "column"
        , HA.style "gap" "16px"
        ]
        [ viewExperienceTable model
        , viewAdjustments model
        ]


viewExperienceTable : Model -> Html Msg
viewExperienceTable model =
    Html.div
        [ HA.style "display" "flex"
        , HA.style "gap" "8px"
        ]
        [ viewNumberInputWithLabel
            { id = "experience-total"
            , label = "Total"
            , onInput = Msg.NumberFieldChanged (Character.setExperience)
            , value = model.character.experience
            }
        , Html.div
            [ HA.style "flex" "1" ]
            [ Html.span
                [ HA.class "label" ]
                [ Html.text "Spent" ]
            , Html.div
                []
                [ Character.spentExp model.character
                    |> String.fromInt
                    |> Html.text
                ]
            ]
        , Html.div
            [ HA.style "flex" "1" ]
            [ Html.span
                [ HA.class "label" ]
                [ Html.text "Current" ]
            , Html.div
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
        [ HA.class "grid"
        , HA.style "grid-template-columns" "[name] auto [c12c] 15% [c12c-value] 15% [adv] 20% [skill] 10%"
        ]
        (List.concat
            [ [ Html.span
                [ HA.style "font-size" "18px"
                , HA.style "grid-column" "span 5"
                ]
                [ Html.text "Basic skills" ]
              ]
            , [ Html.span
                [ HA.class "label" ]
                [ Html.text "Name" ]
              , Html.span
                [ HA.class "label"
                , HA.style "grid-column" "span 2"
                ]
                [ Html.text "Characteristic" ]
              , Html.span
                [ HA.class "label" ]
                [ Html.text "Advances" ]
              , Html.span
                [ HA.class "label" ]
                [ Html.text "Skill" ]
              ]
            , List.indexedMap
                (\index skill ->
                    [ Html.span
                        []
                        [ Html.text skill.name ]
                    , Html.span
                        []
                        [ Html.text (Character.c12cToString skill.c12c) ]
                    , Html.span
                        []
                        [ Character.getC12cs model.character
                            |> Character.getC12c skill.c12c
                            |> String.fromInt
                            |> Html.text
                        ]
                    , viewNumberInput
                        { onInput = Msg.NumberFieldChanged (Character.setBasicSkillAdvances index)
                        , value = skill.advances
                        }
                    , Html.span
                        []
                        [ Character.skillValue model.character skill
                            |> String.fromInt
                            |> Html.text
                        ]
                    ]
                )
                model.character.basicSkills
                |> List.concat
            , [ Html.span
                [ HA.style "grid-column" "span 5"
                , HA.style "margin-top" "10px"
                , HA.style "font-size" "18px"
                ]
                [ Html.text "Grouped & Advanced Skills" ]
              ]
            , [ Html.span
                [ HA.class "label" ]
                [ Html.text "Name" ]
              , Html.span
                [ HA.class "label"
                , HA.style "grid-column" "span 2"
                ]
                [ Html.text "Characteristic" ]
              , Html.span
                [ HA.class "label" ]
                [ Html.text "Advances" ]
              , Html.span
                [ HA.class "label" ]
                [ Html.text "Skill" ]
              ]
            , List.indexedMap
                (\index skill ->
                    [ Html.span
                        []
                        [ viewTextInput
                            { onInput = Msg.TextFieldChanged (Character.setAdvancedSkillName index)
                            , value = skill.name
                            }
                        ]
                    , Html.div
                        []
                        [ viewC12cSelect index skill
                        ]
                    , Html.span
                        []
                        [ Character.getC12cs model.character
                            |> Character.getC12c skill.c12c
                            |> String.fromInt
                            |> Html.text
                        ]
                    , viewNumberInput
                        { onInput = Msg.NumberFieldChanged (Character.setAdvancedSkillAdvances index)
                        , value = skill.advances
                        }
                    , Html.span
                        []
                        [ Character.skillValue model.character skill
                            |> String.fromInt
                            |> Html.text
                        ]
                    ]
                )
                model.character.advancedSkills
                |> List.concat
            , [ Html.div
                [ HA.style "grid-column" "span 5"
                ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.addAdvancedSkill)
                    , text = "Add"
                    }
                ]
              ]
            ]
        )


viewC12cSelect : Int -> Character.Skill -> Html Msg
viewC12cSelect index skill =
    viewSelect
        { options = Character.allC12cs
        , label = Character.c12cToString
        , value = Character.c12cToString
        , selected = Just skill.c12c
        , onInput = Msg.TextFieldChanged (Character.setAdvancedSkillC12cFromString index)
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
    Html.div
        [ HA.class "grid"
        , HA.style "grid-template-columns" "[name] 35% [times-taken] 25% [description] auto"
        ]
        (List.concat
            [ [ Html.span
                [ HA.class "label" ]
                [ Html.text "Name" ]
              , Html.span
                [ HA.class "label" ]
                [ Html.text "Times taken" ]
              , Html.span
                [ HA.class "label" ]
                [ Html.text "Description" ]
              ]
            , List.indexedMap
                (\index talent ->
                    [ viewTextInput
                        { onInput = Msg.TextFieldChanged (Character.setTalentName index)
                        , value = talent.name
                        }
                    , viewNumberInput
                        { onInput = Msg.NumberFieldChanged (Character.setTalentTimesTaken index)
                        , value = talent.timesTaken
                        }
                    , viewTextareaInput
                        { onInput = Msg.TextFieldChanged (Character.setTalentDescription index)
                        , value = talent.description
                        }
                    ]
                )
                model.character.talents
                |> List.concat
            , [ Html.div
                [ HA.style "grid-column" "span 3" ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.addTalent)
                    , text = "Add"
                    }
                ]
              ]
            ]
        )


viewAdjustments : Model -> Html Msg
viewAdjustments model =
    Html.div
        [ HA.class "grid"
        , HA.style "grid-template-columns" "[value] 20% [description] auto"
        ]
        (List.concat
            [ [ Html.span
                [ HA.class "label" ]
                [ Html.text "Value" ]
              , Html.span
                [ HA.class "label" ]
                [ Html.text "Description" ]
              ]
            , List.indexedMap
                (\index adjustment ->
                    [ viewNumberInput
                        { onInput = Msg.NumberFieldChanged (Character.setExpAdjustmentValue index)
                        , value = adjustment.value
                        }
                    , viewTextareaInput
                        { onInput = Msg.TextFieldChanged (Character.setExpAdjustmentDescription index)
                        , value = adjustment.description
                        }
                    ]
                )
                model.character.expAdjustments
                |> List.concat
            , [ Html.div
                [ HA.style "grid-column" "span 2"
                ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.addExpAdjustment)
                    , text = "Add"
                    }
                ]
              ]
            ]
        )


viewTrappings : Model -> Html Msg
viewTrappings model =
    Html.div
        [ HA.class "grid"
        , HA.style "grid-template-columns" "[name] auto [enc] 40px"
        ]
        (List.concat
            [ [ Html.div
                [ HA.class "label"
                , HA.style "grid-column" "name"
                ]
                [ Html.text "Name" ]
              , Html.div
                [ HA.class "label"
                , HA.style "grid-column" "enc"
                ]
                [ Html.text "Enc" ]
              ]
            , (List.indexedMap
                (\index trapping ->
                    [ Html.div
                        [ HA.style "grid-column" "name" ]
                        [ viewTextInput
                            { onInput = Msg.TextFieldChanged (Character.setTrappingName index)
                            , value = trapping.name
                            }
                        ]
                    , Html.div
                        [ HA.style "grid-column" "enc" ]
                        [ viewNumberInput
                            { onInput = Msg.NumberFieldChanged (Character.setTrappingEncumbrance index)
                            , value = trapping.encumbrance
                            }
                        ]
                    ]
                )
                model.character.trappings
                |> List.concat
              )
            , [ Html.div
                [ HA.style "grid-column" "span 2" ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.addTrapping)
                    , text = "Add"
                    }
                ]
              ]
            ]
        )


viewWealth : Model -> Html Msg
viewWealth model =
    Html.div
        [ HA.class "grid"
        , HA.style "grid-template-columns" "2fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 2fr"
        , HA.style "row-gap" "4px"
        ]
        [ Html.div
            [ HA.style "grid-column" "span 3" ]
            [ viewNumberInputWithLabel
                { id = "wealth-gold"
                , label = "Gold Crowns"
                , onInput = Msg.NumberFieldChanged (Character.setGold)
                , value = model.character.wealth.gold
                }
            ]
        , Html.div
            [ HA.style "grid-column" "span 4" ]
            [ viewNumberInputWithLabel
                { id = "wealth-silver"
                , label = "Silver Shillings"
                , onInput = Msg.NumberFieldChanged (Character.setSilver)
                , value = model.character.wealth.silver
                }
            ]
        , Html.div
            [ HA.style "grid-column" "span 3" ]
            [ viewNumberInputWithLabel
                { id = "wealth-brass"
                , label = "Brass Pennies"
                , onInput = Msg.NumberFieldChanged (Character.setBrass)
                , value = model.character.wealth.brass
                }
            ]
        , Html.div
            [ HA.style "grid-column" "2"
            ]
            [ viewButton
                { onClick = Msg.ButtonPressed (Character.convertOneGoldToSilver)
                , text = ">"
                }
            ]
        , viewButton
            { onClick = Msg.ButtonPressed (Character.convertAllGoldToSilver)
            , text = ">>"
            }
        , viewButton
            { onClick = Msg.ButtonPressed (Character.convertAllSilverToGold)
            , text = "<<"
            }
        , viewButton
            { onClick = Msg.ButtonPressed (Character.convertOneSilverToGold)
            , text = "<"
            }
        , viewButton
            { onClick = Msg.ButtonPressed (Character.convertOneSilverToBrass)
            , text = ">"
            }
        , viewButton
            { onClick = Msg.ButtonPressed (Character.convertAllSilverToBrass)
            , text = ">>"
            }
        , viewButton
            { onClick = Msg.ButtonPressed (Character.convertAllBrassToSilver)
            , text = "<<"
            }
        , viewButton
            { onClick = Msg.ButtonPressed (Character.convertOneBrassToSilver)
            , text = "<"
            }
        ]


viewWeapons : Model -> Html Msg
viewWeapons model =
    Html.div
        []
        (List.concat
            [ (List.indexedMap
                  (\index weapon ->
                    Html.div
                        -- Name     Damage Range
                        -- Group Enc Qualities
                        [ HA.style "display" "flex"
                        , HA.style "flex-flow" "row wrap"
                        ]
                        [ Html.div
                            [ HA.style "width" "50%"
                            ]
                            [ Html.text "Name"
                            , viewTextInput
                                { onInput = Msg.TextFieldChanged (Character.setWeaponName index)
                                , value = weapon.name
                                }
                            ]
                        , Html.div
                            [ HA.style "width" "25%"
                            ]
                            [ Html.text "Damage"
                            , viewTextInput
                                { onInput = Msg.TextFieldChanged (Character.setWeaponDamage index)
                                , value = weapon.damage
                                }
                            ]
                        , Html.div
                            [ HA.style "width" "25%"
                            ]
                            [ Html.text "Group"
                            , viewTextInput
                                { onInput = Msg.TextFieldChanged (Character.setWeaponGroup index)
                                , value = weapon.group
                                }
                            ]
                        , Html.div
                            [ HA.style "width" "25%"
                            ]
                            [ Html.text "Encumbrance"
                            , viewNumberInput
                                { onInput = Msg.NumberFieldChanged (Character.setWeaponEncumbrance index)
                                , value = weapon.encumbrance
                                }
                            ]
                        , Html.div
                            [ HA.style "width" "25%"
                            ]
                            [ Html.text "Range/Reach"
                            , viewTextInput
                                { onInput = Msg.TextFieldChanged (Character.setWeaponRange index)
                                , value = weapon.range
                                }
                            ]
                        , Html.div
                            [ HA.style "width" "50%"
                            ]
                            [ Html.text "Qualities"
                            , viewTextInput
                                { onInput = Msg.TextFieldChanged (Character.setWeaponQualities index)
                                , value = weapon.qualities
                                }
                            ]
                        ]
                  )
                model.character.weapons
              )
            , [ viewButton
                { onClick = Msg.ButtonPressed (Character.addWeapon)
                , text = "Add"
                }
              ]
            ]
        )


viewArmour : Model -> Html Msg
viewArmour model =
    Html.div
        [ HA.style "display" "flex"
        , HA.style "flex-flow" "column"
        , HA.style "gap" "16px"
        ]
        [ Html.div
            [ HA.style "display" "flex"
            , HA.style "flex-flow" "column"
            , HA.style "gap" "8px"
            ]
            [ Html.div
                [ HA.style "display" "flex"
                , HA.style "flex-flow" "row"
                , HA.style "gap" "8px"
                ]
                [ viewNumberInputWithLabel
                    { id = "ap-left-arm"
                    , label = "Left arm (10-24)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.LeftArm)
                    , value = model.character.ap.leftArm
                    }
                , viewNumberInputWithLabel
                    { id = "ap-head"
                    , label = "Head (01-09)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.Head)
                    , value = model.character.ap.head
                    }
                , viewNumberInputWithLabel
                    { id = "ap-right-arm"
                    , label = "Right arm (10-24)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.RightArm)
                    , value = model.character.ap.rightArm
                    }
                ]
            , Html.div
                [ HA.style "display" "flex"
                , HA.style "flex-flow" "row"
                , HA.style "gap" "8px"
                ]
                [ viewNumberInputWithLabel
                    { id = "ap-shield"
                    , label = "Shield"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.Shield)
                    , value = model.character.ap.shield
                    }
                , viewNumberInputWithLabel
                    { id = "ap-left-leg"
                    , label = "Left leg (80-89)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.LeftLeg)
                    , value = model.character.ap.leftLeg
                    }
                , viewNumberInputWithLabel
                    { id = "ap-body"
                    , label = "Body (45-79)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.Body)
                    , value = model.character.ap.body
                    }
                , viewNumberInputWithLabel
                    { id = "ap-right-leg"
                    , label = "Right leg (90-00)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.RightLeg)
                    , value = model.character.ap.rightLeg
                    }
                ]
            ]
        , Html.div
            [ HA.class "grid"
            , HA.style "grid-template-columns" "[name] auto [locations] auto [enc] 40px [ap] 40px [qualities] auto"
            ]
            (List.concat
                [ [ Html.span
                    [ HA.class "label" ]
                    [ Html.text "Name" ]
                  , Html.span
                    [ HA.class "label" ]
                    [ Html.text "Locations" ]
                  , Html.span
                    [ HA.class "label" ]
                    [ Html.text "Enc" ]
                  , Html.span
                    [ HA.class "label" ]
                    [ Html.text "AP" ]
                  , Html.span
                    [ HA.class "label" ]
                    [ Html.text "Qualities" ]
                  ]
                , (List.indexedMap
                    (\index armour ->
                        [ viewTextInput
                            { onInput = Msg.TextFieldChanged (Character.setArmourName index)
                            , value = armour.name
                            }
                        , viewTextInput
                            { onInput = Msg.TextFieldChanged (Character.setArmourLocations index)
                            , value = armour.locations
                            }
                        , viewNumberInput
                            { onInput = Msg.NumberFieldChanged (Character.setArmourEncumbrance index)
                            , value = armour.encumbrance
                            }
                        , viewNumberInput
                            { onInput = Msg.NumberFieldChanged (Character.setArmourAp index)
                            , value = armour.ap
                            }
                        , viewTextInput
                            { onInput = Msg.TextFieldChanged (Character.setArmourQualities index)
                            , value = armour.qualities
                            }
                        ]
                    )
                    model.character.armour
                    |> List.concat
                  )
                , [ Html.div
                    [ HA.style "grid-column" "span 5" ]
                    [ viewButton
                        { onClick = Msg.ButtonPressed (Character.addArmour)
                        , text = "Add"
                        }
                    ]
                  ]
                ]
            )
        ]


viewWounds : Model -> Html Msg
viewWounds model =
    Html.div
        [ HA.style "display" "flex"
        , HA.style "flex-flow" "row"
        , HA.style "justify-content" "space-between"
        , HA.style "align-items" "flex-end"
        , HA.style "gap" "8px"
        ]
        [ Html.div
            [ HA.style "flex" "1" ]
            [ Html.div
                [ HA.class "label" ]
                [ Html.text "SB" ]
            , Character.getC12cs model.character
                |> Character.getC12c Character.S
                |> Character.getBonus
                |> String.fromInt
                |> Html.text
            ]
        , Html.div
            []
            [ Html.text "+" ]
        , Html.div
            [ HA.style "flex" "1" ]
            [ Html.div
                [ HA.class "label" ]
                [ Html.text "TBx2" ]
            , Character.getC12cs model.character
                |> Character.getC12c Character.T
                |> Character.getBonus
                |> (*) 2
                |> String.fromInt
                |> Html.text
            ]
        , Html.div
            []
            [ Html.text "+" ]
        , Html.div
            [ HA.style "flex" "1" ]
            [ Html.div
                [ HA.class "label" ]
                [ Html.text "WP" ]
            , Character.getC12cs model.character
                |> Character.getC12c Character.WP
                |> Character.getBonus
                |> String.fromInt
                |> Html.text
            ]
        , Html.div
            []
            [ Html.text "+" ]
        , viewNumberInputWithLabel
            { id = "wounds-extra"
            , label = "Extra"
            , onInput = Msg.NumberFieldChanged (Character.setExtraWounds)
            , value = model.character.extraWounds
            }
        , Html.div
            []
            [ Html.text "=" ]
        , Html.div
            [ HA.style "flex" "1" ]
            [ Html.div
                [ HA.class "label" ]
                [ Html.text "Total" ]
            , Character.getWounds model.character
                |> String.fromInt
                |> Html.text
            ]
        , viewNumberInputWithLabel
            { id = "wounds-current"
            , label = "Current"
            , onInput = Msg.NumberFieldChanged (Character.setCurrentWounds)
            , value = model.character.currentWounds
            }
        ]
