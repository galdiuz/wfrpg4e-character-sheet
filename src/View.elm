module View exposing (view)

import Character as Character
import Css
import Data
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
        , viewDatalists
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
                { onClick = Msg.SetAllCardStatesPressed Ui.Collapsed
                , text = "Collapse all"
                }
            , viewButton
                { onClick = Msg.SetAllCardStatesPressed Ui.Open
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
        , Html.div
            (List.append
                [ HA.class "card-content"
                , HA.id (Ui.cardId card ++ "-content")
                ]
                (case Ui.getCardState card model.ui of
                    Ui.Open ->
                        [ HAE.attributeMaybe
                            (\height ->
                                HA.style "max-height" (String.fromInt height ++ "px")
                            )
                            (Dict.get (Ui.cardId card) model.ui.cardContentHeights)
                        ]

                    Ui.Collapsed ->
                        [ HA.style "max-height" "0px"
                        , HA.style "padding-bottom" "0px"
                        , HA.style "padding-top" "0px"
                        , HA.style "transform" "scale(1, 0.25)"
                        ]
                )
            )
            [ case card of
                Ui.Armour ->
                    viewArmour model

                Ui.C12cs ->
                    viewC12cs model

                Ui.Corruption ->
                    viewCorruption model

                Ui.Encumbrance ->
                    viewEncumbrance model

                Ui.Experience ->
                    viewExperience model

                Ui.Fate ->
                    viewFate model

                Ui.Information ->
                    viewInformation model

                Ui.Movement ->
                    viewMovement model

                Ui.Notes ->
                    viewNotes model

                Ui.Skills ->
                    viewSkills model

                Ui.Spells ->
                    viewSpells model

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
        [ HA.class "flex-column"
        ]
        [ Html.div
            [ HA.class "flex-row"
            ]
            [ viewTextInputWithLabel
                [ HA.style "flex" "2" ]
                { label = "Name"
                , list = Nothing
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Name)
                , value = model.character.info.name
                }
            , viewTextInputWithLabel
                []
                { label = "Species"
                , list = Just "datalist-species"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Species)
                , value = model.character.info.species
                }
            ]
        , Html.div
            [ HA.class "flex-row"
            ]
            [ viewTextInputWithLabel
                []
                { label = "Class"
                , list = Just "datalist-classes"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Class)
                , value = model.character.info.class
                }
            , viewTextInputWithLabel
                []
                { label = "Career"
                , list = Just ("datalist-careers-" ++ formatId model.character.info.class)
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Career)
                , value = model.character.info.career
                }
            , viewTextInputWithLabel
                [ HA.style "flex" "2" ]
                { label = "Career Level"
                , list = Just ("datalist-career-levels-" ++ formatId model.character.info.career)
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.CareerLevel)
                , value = model.character.info.careerLevel
                }
            ]
        , Html.div
            [ HA.class "flex-row"
            ]
            [ viewTextInputWithLabel
                [ HA.style "flex" "4" ]
                { label = "Career Path"
                , list = Nothing
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.CareerPath)
                , value = model.character.info.careerPath
                }
            , viewTextInputWithLabel
                []
                { label = "Status"
                , list = Just "datalist-statuses"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Status)
                , value = model.character.info.status
                }
            ]
        , Html.div
            [ HA.class "flex-row"
            ]
            [ viewTextInputWithLabel
                [ HA.style "flex" "2" ]
                { label = "Age"
                , list = Nothing
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Age)
                , value = model.character.info.age
                }
            , viewTextInputWithLabel
                [ HA.style "flex" "2" ]
                { label = "Height"
                , list = Nothing
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Height)
                , value = model.character.info.height
                }
            , viewTextInputWithLabel
                [ HA.style "flex" "3" ]
                { label = "Hair"
                , list = Nothing
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Hair)
                , value = model.character.info.hair
                }
            , viewTextInputWithLabel
                [ HA.style "flex" "3" ]
                { label = "Eyes"
                , list = Nothing
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
    { list : Maybe String
    , onInput : String -> msg
    , value : String
    }
    -> Html msg
viewTextInput data =
    Html.input
        [ HA.type_ "text"
        , HA.value data.value
        , HAE.attributeMaybe HA.list data.list
        , Events.onInput data.onInput
        ]
        []


viewTextInputWithLabel :
    List (Html.Attribute msg)
    -> { label : String
       , list : Maybe String
       , onInput : String -> msg
       , value : String
       }
    -> Html msg
viewTextInputWithLabel attributes data =
    Html.label
        (List.append
            [ HA.class "label"
            ]
            attributes
        )
        [ Html.text data.label
        , Html.input
            [ HA.type_ "text"
            , HAE.attributeMaybe HA.list data.list
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
    Html.div
        [ HA.style "position" "relative"
        , HA.style "flex" "1"
        ]
        [ Html.div
            [ HA.class "textarea"
            , HA.style "display" "hidden"
            ]
            (data.value
                |> String.split "\n"
                |> List.map
                    (\text ->
                        if String.isEmpty text then
                            Html.text " "
                        else
                            Html.text text
                    )
                |> List.intersperse (Html.br [] [])
            )
        , Html.textarea
            [ HA.class "textarea"
            , HA.value data.value
            , Events.onInput data.onInput
            ]
            []
        ]


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
    List (Html.Attribute msg)
    -> { label : String
       , onInput : String -> msg
       , value : Int
       }
    -> Html msg
viewNumberInputWithLabel attributes data =
    Html.label
        (List.append
            [ HA.class "label"
            , HA.style "flex" "1"
            ]
            attributes
        )
        [ Html.text data.label
        , Html.input
            [ HA.type_ "number"
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
        [ HA.class "flex-row"
        ]
        [ viewNumberInputWithLabel
            []
            { label = "Total"
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
        , HA.style "grid-template-columns" "[name] auto [c12c] 15% [c12c-value] 10% [adv] 20% [skill] 10%"
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
                            { list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setAdvancedSkillName index)
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
        , HA.style "grid-template-columns" "[name] 35% [times-taken] 20% [description] auto"
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
                        { list = Just "datalist-talents"
                        , onInput = Msg.TextFieldChanged (Character.setTalentName index)
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
                            { list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setTrappingName index)
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
                []
                { label = "Gold Crowns"
                , onInput = Msg.NumberFieldChanged (Character.setGold)
                , value = model.character.wealth.gold
                }
            ]
        , Html.div
            [ HA.style "grid-column" "span 4" ]
            [ viewNumberInputWithLabel
                []
                { label = "Silver Shillings"
                , onInput = Msg.NumberFieldChanged (Character.setSilver)
                , value = model.character.wealth.silver
                }
            ]
        , Html.div
            [ HA.style "grid-column" "span 3" ]
            [ viewNumberInputWithLabel
                []
                { label = "Brass Pennies"
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
        [ HA.class "flex-column" ]
        (List.concat
            [ (List.indexedMap
                  (\index weapon ->
                    Html.div
                        [ HA.class "flex-column"
                        ]
                        [ Html.div
                            [ HA.class "flex-row" ]
                            [ viewTextInputWithLabel
                                [ HA.style "flex" "2" ]
                                { label = "Name"
                                , list = Nothing
                                , onInput = Msg.TextFieldChanged (Character.setWeaponName index)
                                , value = weapon.name
                                }
                            , viewTextInputWithLabel
                                []
                                { label = "Damage"
                                , list = Nothing
                                , onInput = Msg.TextFieldChanged (Character.setWeaponDamage index)
                                , value = weapon.damage
                                }
                            , viewTextInputWithLabel
                                []
                                { label = "Group"
                                , list = Nothing
                                , onInput = Msg.TextFieldChanged (Character.setWeaponGroup index)
                                , value = weapon.group
                                }
                            ]
                        , Html.div
                            [ HA.class "flex-row" ]
                            [ viewNumberInputWithLabel
                                []
                                { label = "Enc"
                                , onInput = Msg.NumberFieldChanged (Character.setWeaponEncumbrance index)
                                , value = weapon.encumbrance
                                }
                            , viewTextInputWithLabel
                                [ HA.style "flex" "2" ]
                                { label = "Range/Reach"
                                , list = Nothing
                                , onInput = Msg.TextFieldChanged (Character.setWeaponRange index)
                                , value = weapon.range
                                }
                            , viewTextInputWithLabel
                                [ HA.style "flex" "5" ]
                                { label = "Qualities"
                                , list = Nothing
                                , onInput = Msg.TextFieldChanged (Character.setWeaponQualities index)
                                , value = weapon.qualities
                                }
                            ]
                        ]
                  )
                model.character.weapons
              )
            , [ viewButton
                { onClick = Msg.ButtonPressed Character.addWeapon
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
            [ HA.class "flex-column"
            ]
            [ Html.div
                [ HA.class "flex-row"
                ]
                [ viewNumberInputWithLabel
                    []
                    { label = "Left arm (10-24)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.LeftArm)
                    , value = model.character.ap.leftArm
                    }
                , viewNumberInputWithLabel
                    []
                    { label = "Head (01-09)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.Head)
                    , value = model.character.ap.head
                    }
                , viewNumberInputWithLabel
                    []
                    { label = "Right arm (10-24)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.RightArm)
                    , value = model.character.ap.rightArm
                    }
                ]
            , Html.div
                [ HA.class "flex-row"
                ]
                [ viewNumberInputWithLabel
                    [ HA.style "flex" "9" ]
                    { label = "Shield"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.Shield)
                    , value = model.character.ap.shield
                    }
                , viewNumberInputWithLabel
                    [ HA.style "flex" "20" ]
                    { label = "Left leg (80-89)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.LeftLeg)
                    , value = model.character.ap.leftLeg
                    }
                , viewNumberInputWithLabel
                    [ HA.style "flex" "17" ]
                    { label = "Body (45-79)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.Body)
                    , value = model.character.ap.body
                    }
                , viewNumberInputWithLabel
                    [ HA.style "flex" "20" ]
                    { label = "Right leg (90-00)"
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
                            { list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setArmourName index)
                            , value = armour.name
                            }
                        , viewTextInput
                            { list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setArmourLocations index)
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
                            { list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setArmourQualities index)
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
        [ HA.class "flex-column"
        , HA.style "gap" "16px"
        ]
        [ Html.div
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
                []
                { label = "Extra"
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
                []
                { label = "Current"
                , onInput = Msg.NumberFieldChanged (Character.setCurrentWounds)
                , value = model.character.currentWounds
                }
            ]
        , Html.div
            [ HA.class "grid"
            , HA.style "grid-template-columns" "[location] 20% [description] auto"
            ]
            (List.concat
                [ [ Html.span
                    [ HA.class "label" ]
                    [ Html.text "Location" ]
                  , Html.span
                    [ HA.class "label" ]
                    [ Html.text "Description" ]
                  ]
                , List.indexedMap
                    (\index injury ->
                        [ viewSelect
                            { options = Character.injuryLocations
                            , label = Character.bodyLocationToString
                            , value = Character.bodyLocationToString
                            , selected = Just injury.location
                            , onInput = Msg.TextFieldChanged (Character.setInjuryLocationFromString index)
                            }
                        , viewTextInput
                            { list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setInjuryDescription index)
                            , value = injury.description
                            }
                        ]
                    )
                    model.character.injuries
                    |> List.concat
                , [ Html.div
                    [ HA.style "grid-column" "span 2" ]
                    [ viewButton
                        { onClick = Msg.ButtonPressed (Character.addInjury)
                        , text = "Add"
                        }
                    ]
                    ]
                ]
            )
        ]


viewEncumbrance : Model -> Html Msg
viewEncumbrance model =
    Html.div
        [ HA.class "flex-row"
        , HA.style "align-items" "flex-end"
        ]
        [ Html.div
            [ HA.style "flex" "1" ]
            [ Html.div
                [ HA.class "label" ]
                [ Html.text "Weapons" ]
            , Character.weaponEncumbrance model.character
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
                [ Html.text "Armour" ]
            , Character.armourEncumbrance model.character
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
                [ Html.text "Trappings" ]
            , Character.trappingsEncumbrance model.character
                |> String.fromInt
                |> Html.text
            ]
        , Html.div
            []
            [ Html.text "=" ]
        , Html.div
            [ HA.style "flex" "0.8" ]
            [ Html.div
                [ HA.class "label" ]
                [ Html.text "Total" ]
            , Character.totalEncumbrance model.character
                |> String.fromInt
                |> Html.text
            ]
        , Html.div
            []
            [ Html.text "/" ]
        , viewNumberInputWithLabel
            []
            { label = "Max Enc."
            , onInput = Msg.NumberFieldChanged (Character.setMaxEncumbrance)
            , value = model.character.maxEncumbrance
            }
        ]


viewNotes : Model -> Html Msg
viewNotes model =
    Html.div
        [ HA.class "flex-column"
        ]
        (List.concat
            [ List.indexedMap
                (\index note ->
                    viewTextareaInput
                        { onInput = Msg.TextFieldChanged (Character.setNote index)
                        , value = note
                        }
                )
                model.character.notes
            , [ Html.div
                []
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.addNote)
                    , text = "Add"
                    }
                ]
              ]
            ]
        )


viewDatalists : Html msg
viewDatalists =
    Html.div
        []
        (List.append
            [ viewDatalist
                "datalist-classes"
                (List.map .name Data.classes)
            , viewDatalist
                "datalist-species"
                Data.species
            , viewDatalist
                "datalist-statuses"
                Data.statuses
            , viewDatalist
                "datalist-talents"
                Data.talents
            ]
            (List.map
                (\class ->
                    List.append
                        [ viewDatalist
                            ("datalist-careers-" ++ formatId class.name)
                            (List.map .name class.careers)
                        ]
                        (List.map
                            (\career ->
                                viewDatalist
                                    ("datalist-career-levels-" ++ formatId career.name)
                                    (List.map .name career.levels)
                            )
                            class.careers
                        )
                )
                Data.classes
                |> List.concat
            )
        )


formatId : String -> String
formatId str =
    str
        |> String.replace " " "-"
        |> String.toLower


viewDatalist : String -> List String -> Html msg
viewDatalist id options =
    Html.datalist
        [ HA.id id ]
        (List.map
            (\option ->
                Html.option
                    [ HA.value option ]
                    []
            )
            options
        )


viewFate : Model -> Html Msg
viewFate model =
    Html.div
        [ HA.class "flex-row" ]
        [ viewNumberInputWithLabel
            [ HA.style "flex" "2" ]
            { label = "Fate"
            , onInput = Msg.NumberFieldChanged Character.setFate
            , value = model.character.fate
            }
        , viewNumberInputWithLabel
            [ HA.style "flex" "3" ]
            { label = "Fortune"
            , onInput = Msg.NumberFieldChanged Character.setFate
            , value = model.character.fate
            }
        , viewNumberInputWithLabel
            [ HA.style "flex" "3" ]
            { label = "Resilience"
            , onInput = Msg.NumberFieldChanged Character.setFate
            , value = model.character.fate
            }
        , viewNumberInputWithLabel
            [ HA.style "flex" "3" ]
            { label = "Resolve"
            , onInput = Msg.NumberFieldChanged Character.setFate
            , value = model.character.fate
            }
        , viewTextInputWithLabel
            [ HA.style "flex" "5" ]
            { label = "Motivation"
            , list = Nothing
            , onInput = Msg.TextFieldChanged Character.setMotivation
            , value = model.character.motivation
            }
        ]


viewMovement : Model -> Html Msg
viewMovement model =
    Html.div
        [ HA.class "flex-row" ]
        [ viewNumberInputWithLabel
            []
            { label = "Movement"
            , onInput = Msg.NumberFieldChanged Character.setMovement
            , value = model.character.movement
            }
        , Html.div
            [ HA.style "flex" "1" ]
            [ Html.div
                [ HA.class "label" ]
                [ Html.text "Walk" ]
            , Html.text (String.fromInt (Character.walk model.character))
            ]
        , Html.div
            [ HA.style "flex" "1" ]
            [ Html.div
                [ HA.class "label" ]
                [ Html.text "Run" ]
            , Html.text (String.fromInt (Character.run model.character))
            ]
        ]


viewSpells : Model -> Html Msg
viewSpells model =
    Html.div
        [ HA.class "flex-column" ]
        (List.concat
            [ (List.indexedMap
                (\index spell ->
                    case Ui.getSpellState index model.ui of
                        Ui.Collapsed ->
                            Html.div
                                [ HA.class "flex-row"
                                ]
                                [ viewButton
                                    { onClick = Msg.ToggleSpellStatePressed index
                                    , text =
                                        if String.isEmpty spell.name then
                                            "<New spell>"

                                        else
                                            spell.name
                                    }
                                ]

                        Ui.Open ->
                            Html.div
                                [ HA.class "flex-column"
                                ]
                                [ Html.div
                                    [ HA.class "flex-row" ]
                                    [ viewTextInputWithLabel
                                        [ HA.style "flex" "1" ]
                                        { label = "Name"
                                        , list = Nothing
                                        , onInput = Msg.TextFieldChanged (Character.setSpellName index)
                                        , value = spell.name
                                        }
                                    , viewTextInputWithLabel
                                        []
                                        { label = "Range"
                                        , list = Nothing
                                        , onInput = Msg.TextFieldChanged (Character.setSpellRange index)
                                        , value = spell.range
                                        }
                                    , Html.button
                                        [ HA.class "button-style"
                                        , Events.onClick (Msg.ToggleSpellStatePressed index)
                                        ]
                                        [ FA.viewIcon FontAwesome.Solid.compress ]
                                    ]
                                , Html.div
                                    [ HA.class "flex-row" ]
                                    [ viewTextInputWithLabel
                                        [ HA.style "flex" "5" ]
                                        { label = "Target"
                                        , list = Nothing
                                        , onInput = Msg.TextFieldChanged (Character.setSpellTarget index)
                                        , value = spell.target
                                        }
                                    , viewTextInputWithLabel
                                        [ HA.style "flex" "5" ]
                                        { label = "Duration"
                                        , list = Nothing
                                        , onInput = Msg.TextFieldChanged (Character.setSpellDuration index)
                                        , value = spell.duration
                                        }
                                    , viewNumberInputWithLabel
                                        [ HA.style "flex" "1" ]
                                        { label = "CN"
                                        , onInput = Msg.NumberFieldChanged (Character.setSpellCn index)
                                        , value = spell.cn
                                        }
                                    ]
                                , Html.label
                                    [ HA.class "label" ]
                                    [ Html.text "Effect"
                                    , viewTextareaInput
                                        { onInput = Msg.TextFieldChanged (Character.setSpellEffect index)
                                        , value = spell.effect
                                        }
                                    ]
                                ]
                )
                model.character.spells
                |> List.intersperse
                    (Html.div
                        []
                        []
                    )
              )
            , [ viewButton
                { onClick = Msg.ButtonPressed Character.addSpell
                , text = "Add"
                }
              ]
            ]
        )


viewCorruption : Model -> Html Msg
viewCorruption model =
    Html.div
        [ HA.class "flex-column"
        , HA.style "gap" "16px"
        ]
        [ Html.div
            [ HA.class "flex-row" ]
            [ viewNumberInputWithLabel
                []
                { label = "Corruption Points"
                , onInput = Msg.NumberFieldChanged (Character.setCorruption)
                , value = model.character.corruption
                }
            , Html.div
                [ HA.style "flex" "1" ]
                [ Html.div
                    [ HA.class "label" ]
                    [ Html.text "Mutation Threshold" ]
                , Html.text (String.fromInt (Character.mutationThreshold model.character))
                ]
            ]
        , Html.div
            [ HA.class "grid"
            , HA.style "grid-template-columns" "[kind] 20% [description] 30% [effect] auto"
            ]
            (List.concat
                [ [ Html.span
                    [ HA.class "label" ]
                    [ Html.text "Kind" ]
                  , Html.span
                    [ HA.class "label" ]
                    [ Html.text "Description" ]
                  , Html.span
                    [ HA.class "label" ]
                    [ Html.text "Effect" ]
                  ]
                , List.indexedMap
                    (\index mutation ->
                        [ viewSelect
                            { options = Character.allMutationKinds
                            , label = Character.mutationKindToString
                            , value = Character.mutationKindToString
                            , selected = Just mutation.kind
                            , onInput = Msg.TextFieldChanged (Character.setMutationKindFromString index)
                            }
                        , viewTextInput
                            { list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setMutationDescription index)
                            , value = mutation.description
                            }
                        , viewTextInput
                            { list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setMutationEffect index)
                            , value = mutation.effect
                            }
                        ]
                    )
                    model.character.mutations
                    |> List.concat
                , [ Html.div
                    [ HA.style "grid-column" "span 3" ]
                    [ viewButton
                        { onClick = Msg.ButtonPressed (Character.addMutation)
                        , text = "Add"
                        }
                    ]
                    ]
                ]
            )
        ]
