module View exposing (view)

import Character as Character
import Css
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
        , Html.node "style" [] [ Html.text Css.dark ]
        , FontAwesome.Styles.css
        , viewHeader
        , viewContent model
        , viewDraggedCard model
        ]


viewDraggedCard model =
    case model.ui.draggedCard of
        Just card ->
            Html.div
                [ HA.style "position" "absolute"
                , HA.style "left" (String.fromInt (Tuple.first model.ui.dragPosition) ++ "px")
                , HA.style "top" (String.fromInt (Tuple.second model.ui.dragPosition) ++ "px")
                , HA.style "width" (String.fromInt (Ui.getColumnWidth model.ui) ++ "px")
                ]
                [ viewCard model card ]

        Nothing ->
            Html.text ""


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
                { onClick = Msg.CollapseAllCards
                , text = "Collapse all"
                }
            , viewButton
                { onClick = Msg.ExpandAllCards
                , text = "Expand all"
                }
            ]
        ]


viewContent : Model -> Html Msg
viewContent model =
    Html.div
        [ HA.class "content"
        ]
        (List.map
            (\cards ->
                Html.div
                    [ HA.class "content-column"
                    , HA.style "width" (String.fromInt (Ui.getColumnWidth model.ui) ++ "px")
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
        [ HA.class "card" ]
        [ Html.div
            [ HA.class "card-header" ]
            [ Html.div
                [ HA.class "card-header-icon" ]
                [ Icons.view (Ui.cardIcon card) ]
            , Html.span
                [ HA.class "card-header-title" ]
                [ Html.text (Ui.cardTitle card)
                ]
            , Html.div
                [ HA.class "card-header-buttons" ]
                [ Html.div
                    [ Draggable.mouseTrigger card Msg.DragMsg
                    , HA.class "button-style"
                    , HA.style "cursor" "move"
                    ]
                    [ FA.viewIcon FontAwesome.Solid.arrowsAlt ]
                , Html.div
                    []
                    [ Html.button
                        [ Events.onClick (Msg.ToggleCardState card)
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
                { onClick = Msg.Save
                , text = "Save"
                }
            ]
        , Html.div
            [ HA.style "width" "50px" ]
            [ viewButton
                { onClick = Msg.Load
                , text = "Load"
                }
            ]
        ]


viewInformation : Model -> Html Msg
viewInformation model =
    Html.div
        [ HA.style "display" "flex"
        , HA.style "flex-flow" "row wrap"
        ]
        [ Html.text "Name"
        , viewTextInput
            { onInput = Msg.SetInformation "name"
            , value = model.character.info.name
            }
        , Html.div
            [ HA.style "width" "50%" ]
            [ Html.text "Species"
            , viewTextInput
                { onInput = Msg.SetInformation "species"
                , value = model.character.info.species
                }
            ]
        , Html.div
            [ HA.style "width" "50%" ]
            [ Html.text "Class"
            , viewTextInput
                { onInput = Msg.SetInformation "class"
                , value = model.character.info.class
                }
            ]
        , Html.div
            [ HA.style "width" "33%" ]
            [ Html.text "Career Path"
            , viewTextInput
                { onInput = Msg.SetInformation "careerPath"
                , value = model.character.info.careerPath
                }
            ]
        , Html.div
            [ HA.style "width" "33%" ]
            [ Html.text "Career"
            , viewTextInput
                { onInput = Msg.SetInformation "career"
                , value = model.character.info.career
                }
            ]
        , Html.div
            [ HA.style "width" "33%" ]
            [ Html.text "Status"
            , viewTextInput
                { onInput = Msg.SetInformation "status"
                , value = model.character.info.status
                }
            ]
        , Html.div
            [ HA.style "width" "20%" ]
            [ Html.text "Age"
            , viewTextInput
                { onInput = Msg.SetInformation "age"
                , value = model.character.info.age
                }
            ]
        , Html.div
            [ HA.style "width" "20%" ]
            [ Html.text "Height"
            , viewTextInput
                { onInput = Msg.SetInformation "height"
                , value = model.character.info.height
                }
            ]
        , Html.div
            [ HA.style "width" "30%" ]
            [ Html.text "Hair"
            , viewTextInput
                { onInput = Msg.SetInformation "hair"
                , value = model.character.info.hair
                }
            ]
        , Html.div
            [ HA.style "width" "30%" ]
            [ Html.text "Eyes"
            , viewTextInput
                { onInput = Msg.SetInformation "eyes"
                , value = model.character.info.eyes
                }
            ]
        ]


viewC12cs : Model -> Html Msg
viewC12cs model =
    Html.div
        [ HA.style "display" "grid"
        , HA.style "grid-template-columns" "40% 20% 20% 20%"
        ]
        (List.concat
            [ [ Html.span
                []
                [ Html.text "Characteristic" ]
              , Html.span
                []
                [ Html.text "Initial" ]
              , Html.span
                []
                [ Html.text "Advances" ]
              , Html.span
                []
                [ Html.text "Current" ]
              ]
            , List.map
                (\c12c ->
                    [ Html.span
                        []
                        [ Html.text (Character.c12cToFullString c12c) ]
                    , viewNumberInput
                        { onInput = Msg.SetC12csInitial c12c
                        , value = Character.getC12c c12c model.character.c12csInitial
                        }
                    , viewNumberInput
                        { onInput = Msg.SetC12csAdvances c12c
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


type alias TextInputData msg =
    { onInput : String -> msg
    , value : String
    }


viewTextInput : TextInputData msg -> Html msg
viewTextInput data =
    Html.input
        [ HA.type_ "text"
        , HA.value data.value
        , Events.onInput data.onInput
        ]
        []


viewTextareaInput : TextInputData msg -> Html msg
viewTextareaInput data =
    Html.textarea
        [ HA.attribute "rows" "1"
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
        , HA.style "width" "100%"
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
    Html.div
        [ HA.style "display" "flex" ]
        [ Html.div
            [ HA.style "width" "33%" ]
            [ Html.text "Total"
            , viewNumberInput
                { onInput = Msg.SetExperience
                , value = model.character.experience
                }
            ]
        , Html.div
            [ HA.style "width" "33%" ]
            [ Html.div
                []
                [ Html.text "Spent" ]
            , Html.div
                []
                [ Character.spentExp model.character
                    |> String.fromInt
                    |> Html.text
                ]
            ]
        , Html.div
            [ HA.style "width" "33%" ]
            [ Html.text "Current"
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
        [ HA.style "display" "grid"
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
                []
                [ Html.text "Name" ]
              , Html.span
                [ HA.style "grid-column" "span 2"
                ]
                [ Html.text "Characteristic" ]
              , Html.span
                []
                [ Html.text "Advances" ]
              , Html.span
                []
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
                        { onInput = Msg.SetBasicSkillAdvances index
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
                []
                [ Html.text "Name" ]
              , Html.span
                [ HA.style "grid-column" "span 2"
                ]
                [ Html.text "Characteristic" ]
              , Html.span
                []
                [ Html.text "Advances" ]
              , Html.span
                []
                [ Html.text "Skill" ]
              ]
            , List.indexedMap
                (\index skill ->
                    [ Html.span
                        []
                        [ viewTextInput
                            { onInput = Msg.SetAdvancedSkillName index
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
                        { onInput = Msg.SetAdvancedSkillAdvances index
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
                    { onClick = Msg.AddAdvancedSkill
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
    Html.div
        [ HA.style "display" "grid"
        , HA.style "grid-template-columns" "[name] 35% [times-taken] 25% [description] auto"
        ]
        (List.concat
            [ [ Html.span
                []
                [ Html.text "Name" ]
              , Html.span
                []
                [ Html.text "Times taken" ]
              , Html.span
                []
                [ Html.text "Description" ]
              ]
            , List.indexedMap
                (\index talent ->
                    [ viewTextInput
                        { onInput = Msg.SetTalentName index
                        , value = talent.name
                        }
                    , viewNumberInput
                        { onInput = Msg.SetTalentTimesTaken index
                        , value = talent.timesTaken
                        }
                    , viewTextareaInput
                        { onInput = Msg.SetTalentDescription index
                        , value = talent.description
                        }
                    ]
                )
                model.character.talents
                |> List.concat
            , [ Html.div
                [ HA.style "grid-column" "span 3" ]
                [ viewButton
                    { onClick = Msg.AddTalent
                    , text = "Add"
                    }
                ]
              ]
            ]
        )


viewAdjustments : Model -> Html Msg
viewAdjustments model =
    Html.div
        [ HA.style "display" "grid"
        , HA.style "grid-template-columns" "[value] 20% [description] auto"
        ]
        (List.concat
            [ [ Html.span
                []
                [ Html.text "Value" ]
              , Html.span
                []
                [ Html.text "Description" ]
              ]
            , List.indexedMap
                (\index adjustment ->
                    [ viewNumberInput
                        { onInput = Msg.SetExpAdjustmentValue index
                        , value = adjustment.value
                        }
                    , viewTextareaInput
                        { onInput = Msg.SetExpAdjustmentDescription index
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
                    { onClick = Msg.AddExpAdjustment
                    , text = "Add"
                    }
                ]
              ]
            ]
        )


viewTrappings : Model -> Html Msg
viewTrappings model =
    Html.div
        [ HA.style "display" "grid"
        , HA.style "grid-template-columns" "[name] auto [enc] 40px"
        ]
        (List.concat
            [ [ Html.div
                [ HA.style "grid-column" "name" ]
                [ Html.text "Name" ]
              , Html.div
                [ HA.style "grid-column" "enc" ]
                [ Html.text "Enc" ]
              ]
            , (List.indexedMap
                (\index trapping ->
                    [ Html.div
                        [ HA.style "grid-column" "name" ]
                        [ viewTextInput
                            { onInput = Msg.SetTrappingName index
                            , value = trapping.name
                            }
                        ]
                    , Html.div
                        [ HA.style "grid-column" "enc" ]
                        [ viewNumberInput
                            { onInput = Msg.SetTrappingEncumbrance index
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
                    { onClick = Msg.AddTrapping
                    , text = "Add"
                    }
                ]
              ]
            ]
        )


viewWealth : Model -> Html Msg
viewWealth model =
    Html.div
        [ HA.style "display" "grid"
        , HA.style "grid-template-columns" "2fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 2fr"
        ]
        [ Html.div
            [ HA.style "grid-column" "span 3" ]
            [ Html.text "G"
            , viewNumberInput
                { onInput = Msg.SetWealthGold
                , value = model.character.wealth.gold
                }
            ]
        , Html.div
            [ HA.style "grid-column" "span 4" ]
            [ Html.text "/"
            , viewNumberInput
                { onInput = Msg.SetWealthSilver
                , value = model.character.wealth.silver
                }
            ]
        , Html.div
            [ HA.style "grid-column" "span 3" ]
            [ Html.text "d"
            , viewNumberInput
                { onInput = Msg.SetWealthBrass
                , value = model.character.wealth.brass
                }
            ]
        , Html.div
            [ HA.style "grid-column" "2"
            ]
            [ viewButton
                { onClick = Msg.ConvertOneGoldToSilver
                , text = ">"
                }
            ]
        , viewButton
            { onClick = Msg.ConvertAllGoldToSilver
            , text = ">>"
            }
        , viewButton
            { onClick = Msg.ConvertAllSilverToGold
            , text = "<<"
            }
        , viewButton
            { onClick = Msg.ConvertOneSilverToGold
            , text = "<"
            }
        , viewButton
            { onClick = Msg.ConvertOneSilverToBrass
            , text = ">"
            }
        , viewButton
            { onClick = Msg.ConvertAllSilverToBrass
            , text = ">>"
            }
        , viewButton
            { onClick = Msg.ConvertAllBrassToSilver
            , text = "<<"
            }
        , viewButton
            { onClick = Msg.ConvertOneBrassToSilver
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
                                { onInput = Msg.SetWeaponName index
                                , value = weapon.name
                                }
                            ]
                        , Html.div
                            [ HA.style "width" "25%"
                            ]
                            [ Html.text "Damage"
                            , viewTextInput
                                { onInput = Msg.SetWeaponDamage index
                                , value = weapon.damage
                                }
                            ]
                        , Html.div
                            [ HA.style "width" "25%"
                            ]
                            [ Html.text "Group"
                            , viewTextInput
                                { onInput = Msg.SetWeaponGroup index
                                , value = weapon.group
                                }
                            ]
                        , Html.div
                            [ HA.style "width" "25%"
                            ]
                            [ Html.text "Encumbrance"
                            , viewNumberInput
                                { onInput = Msg.SetWeaponEncumbrance index
                                , value = weapon.encumbrance
                                }
                            ]
                        , Html.div
                            [ HA.style "width" "25%"
                            ]
                            [ Html.text "Range/Reach"
                            , viewTextInput
                                { onInput = Msg.SetWeaponRange index
                                , value = weapon.range
                                }
                            ]
                        , Html.div
                            [ HA.style "width" "50%"
                            ]
                            [ Html.text "Qualities"
                            , viewTextInput
                                { onInput = Msg.SetWeaponQualities index
                                , value = weapon.qualities
                                }
                            ]
                        ]
                  )
                model.character.weapons
              )
            , [ viewButton
                { onClick = Msg.AddWeapon
                , text = "Add"
                }
              ]
            ]
        )


viewArmour : Model -> Html Msg
viewArmour model =
    Html.div
        [ HA.style "display" "grid"
        , HA.style "grid-template-columns" "[name] auto [locations] auto [enc] 40px [ap] 40px [qualities] auto"
        ]
        (List.concat
            [ [ Html.span
                []
                [ Html.text "Name" ]
              , Html.span
                []
                [ Html.text "Locations" ]
              , Html.span
                []
                [ Html.text "Enc" ]
              , Html.span
                []
                [ Html.text "AP" ]
              , Html.span
                []
                [ Html.text "Qualities" ]
              ]
            , (List.indexedMap
                (\index armour ->
                    [ viewTextInput
                        { onInput = Msg.SetArmourName index
                        , value = armour.name
                        }
                    , viewTextInput
                        { onInput = Msg.SetArmourLocations index
                        , value = armour.locations
                        }
                    , viewNumberInput
                        { onInput = Msg.SetArmourEncumbrance index
                        , value = armour.encumbrance
                        }
                    , viewNumberInput
                        { onInput = Msg.SetArmourAp index
                        , value = armour.ap
                        }
                    , viewTextInput
                        { onInput = Msg.SetArmourQualities index
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
                    { onClick = Msg.AddArmour
                    , text = "Add"
                    }
                ]
              ]
            ]
        )


viewWounds : Model -> Html Msg
viewWounds model =
    Html.div
        [ HA.style "display" "flex"
        , HA.style "flex-flow" "row"
        , HA.style "justify-content" "space-between"
        , HA.style "align-items" "flex-end"
        ]
        [ Html.div
            []
            [ Html.div
                []
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
            []
            [ Html.div
                []
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
            []
            [ Html.div
                []
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
        , Html.div
            []
            [ Html.text "Extra"
            , Html.div
                [ HA.style "width" "40px" ]
                [ viewNumberInput
                    { onInput = Msg.SetExtraWounds
                    , value = model.character.extraWounds
                    }
                ]
            ]
        , Html.div
            []
            [ Html.text "=" ]
        , Html.div
            []
            [ Html.div
                []
                [ Html.text "Total" ]
            , Character.getWounds model.character
                |> String.fromInt
                |> Html.text
            ]
        , Html.div
            []
            [ Html.text "Current"
            , Html.div
                [ HA.style "width" "40px" ]
                [ viewNumberInput
                    { onInput = Msg.SetCurrentWounds
                    , value = model.character.currentWounds
                    }
                ]
            ]
        ]
