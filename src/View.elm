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
import Html.Keyed
import Icons
import Model exposing (Model)
import Msg as Msg exposing (Msg)
import OrderedDict exposing (OrderedDict)
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
                                [ HA.id (Ui.cardId card)
                                , HAE.attributeIf
                                    (Just (Ui.Card card) == model.ui.draggedElement)
                                    (HA.class  "element-transparent")
                                , HAE.attributeIf
                                    (Dict.member (Ui.cardId card) model.ui.movingElements)
                                    (HA.class  "element-fading")
                                ]
                                [ viewCard model card ]

                            , if Ui.isElementFloating model.ui (Ui.Card card) then
                                let
                                    ( left, top ) =
                                        Ui.getFloatingCardPosition model.ui card index
                                in
                                Html.div
                                    [ HA.class "element-floating"
                                    , HAE.attributeIf
                                        (Dict.member (Ui.cardId card) model.ui.movingElements)
                                        (HA.class "element-moving")
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
                , Draggable.mouseTrigger (Ui.Card card) Msg.DragMsgReceived
                ]
                [ Icons.view (Ui.cardIcon card) ]
            , Html.span
                [ HA.class "card-header-title"
                , Draggable.mouseTrigger (Ui.Card card) Msg.DragMsgReceived
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
                        [ HA.class "card-content-collapsed"
                        ]
                )
            )
            [ Html.div
                [ HA.class "card-content-inner"
                , HAE.attributeMaybe
                    (\height ->
                        HA.style "height" (String.fromInt height ++ "px")
                    )
                    (Dict.get (Ui.cardId card) model.ui.cardContentHeights)
                , case Ui.getCardState card model.ui of
                    Ui.Open ->
                        HAE.empty

                    Ui.Collapsed ->
                        HA.class "card-content-inner-collapsed"

                ]
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
                [ HA.style "flex" "1" ]
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
    viewInputWithLabel
        attributes
        data.label
        (viewTextInput
            { list = data.list
            , onInput = data.onInput
            , value = data.value
            }
        )


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
    viewInputWithLabel
        attributes
        data.label
        (viewNumberInput
            { onInput = data.onInput
            , value = data.value
            }
        )


viewInputWithLabel :
    List (Html.Attribute msg)
    -> String
    -> Html msg
    -> Html msg
viewInputWithLabel attributes label input =
    Html.label
        (List.append
            [ HA.class "label"
            ]
            attributes
        )
        [ Html.text label
        , input
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
        []
        [ Html.div
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
                ]
            )
        , Html.div
            [ HA.style "margin-top" "10px"
            , HA.style "font-size" "18px"
            ]
            [ Html.text "Grouped & Advanced Skills" ]
        , viewSortableRows
            { addMsg = Character.addAdvancedSkill
            , card = Ui.Skills
            , headerView =
                Just
                    [ Html.div
                        [ HA.class "label"
                        , HA.style "flex" "9"
                        ]
                        [ Html.text "Name" ]
                    , Html.div
                        [ HA.class "label"
                        , HA.style "flex" "5"
                        ]
                        [ Html.text "Characteristic" ]
                    , Html.div
                        [ HA.class "label"
                        , HA.style "flex" "4"
                        ]
                        [ Html.text "Advances" ]
                    , Html.div
                        [ HA.class "label"
                        , HA.style "flex" "2"
                        ]
                        [ Html.text "Skill" ]
                    ]
            , items = model.character.advancedSkills
            , model = model
            , rowView =
                \id skill ->
                    [ Html.div
                        [ HA.style "flex" "9" ]
                        [ viewTextInput
                            { list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setAdvancedSkillName id)
                            , value = skill.name
                            }
                        ]
                    , Html.div
                        [ HA.class "flex-row"
                        , HA.style "flex" "5"
                        ]
                        [ Html.div
                            [ HA.style "flex" "2" ]
                            [ viewC12cSelect id skill
                            ]
                        , Html.div
                            [ HA.style "flex" "1" ]
                            [ Character.getC12cs model.character
                                |> Character.getC12c skill.c12c
                                |> String.fromInt
                                |> Html.text
                            ]
                        ]
                    , Html.div
                        [ HA.style "flex" "4" ]
                        [ viewNumberInput
                            { onInput = Msg.NumberFieldChanged (Character.setAdvancedSkillAdvances id)
                            , value = skill.advances
                            }
                        ]
                    , Html.div
                        [ HA.style "flex" "2" ]
                        [ Character.skillValue model.character skill
                            |> String.fromInt
                            |> Html.text
                        ]
                    ]
            }
        ]


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
    viewSortableRows
        { addMsg = Character.addTalent
        , card = Ui.Talents
        , headerView =
            Just
                [ Html.div
                    [ HA.class "label"
                    , HA.style "flex" "2"
                    ]
                    [ Html.text "Name" ]
                , Html.div
                    [ HA.class "label"
                    , HA.style "flex" "0 0 45px"
                    ]
                    [ Html.text "# taken" ]
                , Html.div
                    [ HA.class "label"
                    , HA.style "flex" "3"
                    ]
                    [ Html.text "Description" ]
                ]
        , items = model.character.talents
        , model = model
        , rowView =
            \id talent ->
                [ Html.div
                    [ HA.style "flex" "2"
                    ]
                    [ viewTextInput
                        { list = Just "datalist-talents"
                        , onInput = Msg.TextFieldChanged (Character.setTalentName id)
                        , value = talent.name
                        }
                    ]
                , Html.div
                    [ HA.style "flex" "0 0 45px"
                    ]
                    [ viewNumberInput
                        { onInput = Msg.NumberFieldChanged (Character.setTalentTimesTaken id)
                        , value = talent.timesTaken
                        }
                    ]
                , Html.div
                    [ HA.style "flex" "3"
                    ]
                    [ viewTextareaInput
                        { onInput = Msg.TextFieldChanged (Character.setTalentDescription id)
                        , value = talent.description
                        }
                    ]
                ]
        }


viewAdjustments : Model -> Html Msg
viewAdjustments model =
    viewSortableRows
        { addMsg = Character.addExpAdjustment
        , card = Ui.Experience
        , headerView =
            Just
                [ Html.div
                    [ HA.class "label" ]
                    [ Html.text "Value" ]
                , Html.div
                    [ HA.class "label"
                    , HA.style "flex" "4"
                    ]
                    [ Html.text "Description" ]
                ]
        , items = model.character.expAdjustments
        , model = model
        , rowView =
            (\id adjustment ->
                [ Html.div
                    [ HA.style "flex" "1" ]
                    [ viewNumberInput
                        { onInput = Msg.NumberFieldChanged (Character.setExpAdjustmentValue id)
                        , value = adjustment.value
                        }
                    ]
                , Html.div
                    [ HA.style "flex" "4" ]
                    [ viewTextareaInput
                        { onInput = Msg.TextFieldChanged (Character.setExpAdjustmentDescription id)
                        , value = adjustment.description
                        }
                    ]
                ]
            )
        }


viewTrappings : Model -> Html Msg
viewTrappings model =
    viewSortableRows
        { addMsg = Character.addTrapping
        , card = Ui.Trappings
        , headerView =
            Just
                [ Html.div
                    [ HA.class "label"
                    ]
                    [ Html.text "Name" ]
                , Html.div
                    [ HA.class "label"
                    , HA.style "flex" "0 0 40px"
                    ]
                    [ Html.text "Enc" ]
                ]
        , items = model.character.trappings
        , model = model
        , rowView =
            \id trapping ->
                [ Html.div
                    [ HA.style "flex" "1" ]
                    [ viewTextInput
                        { list = Nothing
                        , onInput = Msg.TextFieldChanged (Character.setTrappingName id)
                        , value = trapping.name
                        }
                    ]
                , Html.div
                    [ HA.style "flex" "0 0 40px"
                    ]
                    [ viewNumberInput
                        { onInput = Msg.NumberFieldChanged (Character.setTrappingEncumbrance id)
                        , value = trapping.encumbrance
                        }
                    ]
                ]
        }


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
    viewSortableRows
        { addMsg = Character.addWeapon
        , card = Ui.Weapons
        , headerView = Nothing
        , items = model.character.weapons
        , model = model
        , rowView =
            \id weapon ->
                [ Html.div
                    [ HA.class "flex-column"
                    ]
                    [ Html.div
                        [ HA.class "flex-row" ]
                        [ viewTextInputWithLabel
                            [ HA.style "flex" "2" ]
                            { label = "Name"
                            , list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setWeaponName id)
                            , value = weapon.name
                            }
                        , viewTextInputWithLabel
                            []
                            { label = "Damage"
                            , list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setWeaponDamage id)
                            , value = weapon.damage
                            }
                        , viewTextInputWithLabel
                            []
                            { label = "Group"
                            , list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setWeaponGroup id)
                            , value = weapon.group
                            }
                        ]
                    , Html.div
                        [ HA.class "flex-row" ]
                        [ viewNumberInputWithLabel
                            []
                            { label = "Enc"
                            , onInput = Msg.NumberFieldChanged (Character.setWeaponEncumbrance id)
                            , value = weapon.encumbrance
                            }
                        , viewTextInputWithLabel
                            [ HA.style "flex" "2" ]
                            { label = "Range/Reach"
                            , list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setWeaponRange id)
                            , value = weapon.range
                            }
                        , viewTextInputWithLabel
                            [ HA.style "flex" "5" ]
                            { label = "Qualities"
                            , list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setWeaponQualities id)
                            , value = weapon.qualities
                            }
                        ]
                    ]
                ]
        }


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
        , viewSortableRows
            { addMsg = Character.addArmour
            , card = Ui.Armour
            , headerView = Nothing
            , items = model.character.armour
            , model = model
            , rowView =
                \id armour ->
                    [ Html.div
                        [ HA.class "flex-column" ]
                        [ Html.div
                            [ HA.class "flex-row" ]
                            [ viewTextInputWithLabel
                                [ HA.style "flex" "3" ]
                                { label = "Name"
                                , list = Nothing
                                , onInput = Msg.TextFieldChanged (Character.setArmourName id)
                                , value = armour.name
                                }
                            , viewTextInputWithLabel
                                [ HA.style "flex" "3" ]
                                { label = "Locations"
                                , list = Nothing
                                , onInput = Msg.TextFieldChanged (Character.setArmourLocations id)
                                , value = armour.locations
                                }
                            , viewNumberInputWithLabel
                                []
                                { label = "AP"
                                , onInput = Msg.NumberFieldChanged (Character.setArmourAp id)
                                , value = armour.ap
                                }
                            ]
                        , Html.div
                            [ HA.class "flex-row" ]
                            [ viewNumberInputWithLabel
                                []
                                { label = "Enc"
                                , onInput = Msg.NumberFieldChanged (Character.setArmourEncumbrance id)
                                , value = armour.encumbrance
                                }
                            , viewTextInputWithLabel
                                [ HA.style "flex" "6" ]
                                { label = "Qualities"
                                , list = Nothing
                                , onInput = Msg.TextFieldChanged (Character.setArmourQualities id)
                                , value = armour.qualities
                                }
                            ]
                        ]
                    ]
            }
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
        , viewSortableRows
            { addMsg = Character.addInjury
            , card = Ui.Wounds
            , headerView =
                Just
                    [ Html.div
                        [ HA.class "label" ]
                        [ Html.text "Location" ]
                    , Html.div
                        [ HA.class "label"
                        , HA.style "flex" "3"
                        ]
                        [ Html.text "Description" ]
                    ]
            , items = model.character.injuries
            , model = model
            , rowView =
                \id injury ->
                    [ Html.div
                        [ HA.style "flex" "1" ]
                        [ viewSelect
                            { options = Character.injuryLocations
                            , label = Character.bodyLocationToString
                            , value = Character.bodyLocationToString
                            , selected = Just injury.location
                            , onInput = Msg.TextFieldChanged (Character.setInjuryLocationFromString id)
                            }
                        ]
                    , Html.div
                        [ HA.style "flex" "3" ]
                        [ viewTextareaInput
                            { onInput = Msg.TextFieldChanged (Character.setInjuryDescription id)
                            , value = injury.description
                            }
                        ]
                    ]
            }
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
            , Character.sumEncumbrance model.character.weapons
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
            , Character.sumEncumbrance model.character.armour
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
            , Character.sumEncumbrance model.character.trappings
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
    viewSortableRows
        { addMsg = Character.addNote
        , card = Ui.Notes
        , headerView = Nothing
        , items = model.character.notes
        , model = model
        , rowView =
            \id note ->
                [ viewTextareaInput
                    { onInput = Msg.TextFieldChanged (Character.setNote id)
                    , value = note
                    }
                ]
        }


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
            , onInput = Msg.NumberFieldChanged Character.setFortune
            , value = model.character.fortune
            }
        , viewNumberInputWithLabel
            [ HA.style "flex" "3" ]
            { label = "Resilience"
            , onInput = Msg.NumberFieldChanged Character.setResilience
            , value = model.character.resilience
            }
        , viewNumberInputWithLabel
            [ HA.style "flex" "3" ]
            { label = "Resolve"
            , onInput = Msg.NumberFieldChanged Character.setResolve
            , value = model.character.resolve
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
    viewSortableRows
        { addMsg = Character.addSpell
        , card = Ui.Spells
        , headerView = Nothing
        , items = model.character.spells
        , model = model
        , rowView =
            \id spell ->
                (case Ui.getSpellState id model.ui of
                    Ui.Collapsed ->
                        [ viewButton
                            { onClick = Msg.ToggleSpellStatePressed id
                            , text =
                                if String.isEmpty spell.name then
                                    "<New spell>"

                                else
                                    spell.name
                            }
                        ]

                    Ui.Open ->
                        [ Html.div
                            [ HA.class "flex-column"
                            ]
                            [ Html.div
                                [ HA.class "flex-row" ]
                                [ viewTextInputWithLabel
                                    [ HA.style "flex" "1" ]
                                    { label = "Name"
                                    , list = Nothing
                                    , onInput = Msg.TextFieldChanged (Character.setSpellName id)
                                    , value = spell.name
                                    }
                                , viewTextInputWithLabel
                                    []
                                    { label = "Range"
                                    , list = Nothing
                                    , onInput = Msg.TextFieldChanged (Character.setSpellRange id)
                                    , value = spell.range
                                    }
                                , Html.button
                                    [ HA.class "button-style"
                                    , Events.onClick (Msg.ToggleSpellStatePressed id)
                                    ]
                                    [ FA.viewIcon FontAwesome.Solid.compress ]
                                ]
                            , Html.div
                                [ HA.class "flex-row" ]
                                [ viewTextInputWithLabel
                                    [ HA.style "flex" "5" ]
                                    { label = "Target"
                                    , list = Nothing
                                    , onInput = Msg.TextFieldChanged (Character.setSpellTarget id)
                                    , value = spell.target
                                    }
                                , viewTextInputWithLabel
                                    [ HA.style "flex" "5" ]
                                    { label = "Duration"
                                    , list = Nothing
                                    , onInput = Msg.TextFieldChanged (Character.setSpellDuration id)
                                    , value = spell.duration
                                    }
                                , viewNumberInputWithLabel
                                    [ HA.style "flex" "1" ]
                                    { label = "CN"
                                    , onInput = Msg.NumberFieldChanged (Character.setSpellCn id)
                                    , value = spell.cn
                                    }
                                ]
                            , Html.label
                                [ HA.class "label" ]
                                [ Html.text "Effect"
                                , viewTextareaInput
                                    { onInput = Msg.TextFieldChanged (Character.setSpellEffect id)
                                    , value = spell.effect
                                    }
                                ]
                            ]
                        ]
                )
        }


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
        , viewSortableRows
            { addMsg = Character.addMutation
            , card = Ui.Corruption
            , headerView =
                Just
                    [ Html.div
                        [ HA.class "label"
                        , HA.style "flex" "3"
                        ]
                        [ Html.text "Kind" ]
                    , Html.div
                        [ HA.class "label"
                        , HA.style "flex" "4"
                        ]
                        [ Html.text "Description" ]
                    , Html.div
                        [ HA.class "label"
                        , HA.style "flex" "6"
                        ]
                        [ Html.text "Effect" ]
                    ]
            , items = model.character.mutations
            , model = model
            , rowView =
                \id mutation ->
                    [ Html.div
                        [ HA.style "flex" "3" ]
                        [ viewSelect
                            { options = Character.allMutationKinds
                            , label = Character.mutationKindToString
                            , value = Character.mutationKindToString
                            , selected = Just mutation.kind
                            , onInput = Msg.TextFieldChanged (Character.setMutationKindFromString id)
                            }
                        ]
                    , Html.div
                        [ HA.style "flex" "4" ]
                        [ viewTextareaInput
                            { onInput = Msg.TextFieldChanged (Character.setMutationDescription id)
                            , value = mutation.description
                            }
                        ]
                    , Html.div
                        [ HA.style "flex" "6" ]
                        [ viewTextareaInput
                            { onInput = Msg.TextFieldChanged (Character.setMutationEffect id)
                            , value = mutation.effect
                            }
                        ]
                    ]
            }
        ]


viewSortableRows :
    { addMsg : Character.Character -> Character.Character
    , card : Ui.Card
    , headerView : Maybe (List (Html Msg))
    , items : OrderedDict Int item
    , model : Model
    , rowView : Int -> item -> List (Html Msg)
    }
    -> Html Msg
viewSortableRows data =
    Html.div
        [ HA.class "flex-column" ]
        [ case data.headerView of
            Just headerView ->
                Html.div
                    [ HA.class "flex-row" ]
                    (List.append
                        [ Html.div
                            [ HA.style "width" "8px" ]
                            []
                        ]
                        headerView
                    )

            Nothing ->
                Html.text ""
        , Html.Keyed.node
            "div"
            [ HA.class "flex-column"
            , HA.id (Ui.rowContainerId data.card)
            , HA.style "position" "relative"
            ]
            (OrderedDict.mapToList
                (\id item ->
                    ( String.fromInt id
                    , viewRow data.model id item data.rowView data.card
                    )
                )
                data.items
            )
        , viewButton
            { onClick = Msg.ButtonPressed data.addMsg
            , text = "Add"
            }
        ]


viewRow :
    Model
    -> Int
    -> a
    -> (Int -> a -> List (Html Msg))
    -> Ui.Card
    -> Html Msg
viewRow model id item rowView card =
    let
        element =
            Ui.Row card id
    in
    Html.div
        []
        [ Html.div
            [ HA.id (Ui.draggableElementId element)
            , HAE.attributeIf
                (Just element == model.ui.draggedElement)
                (HA.class  "element-transparent")
            , HAE.attributeIf
                (Dict.member (Ui.draggableElementId element) model.ui.movingElements)
                (HA.class  "element-fading")
            ]
            [ Html.div
                [ HA.class "flex-row" ]
                (List.append
                    [ Html.div
                        [ Draggable.mouseTrigger (Ui.Row card id) Msg.DragMsgReceived
                        , HA.style "width" "8px"
                        , HA.style "cursor" "ns-resize"
                        ]
                        [ FA.viewIcon FontAwesome.Solid.arrowsAltV ]
                    ]
                    (rowView id item)
                )
            ]
        , if Ui.isElementFloating model.ui element then
            let
                ( _, top ) =
                    Ui.getFloatingRowPosition model.ui element
            in
            Html.div
                [ HA.class "element-floating background"
                , HAE.attributeIf
                    (Dict.member (Ui.draggableElementId element) model.ui.movingElements)
                    (HA.class "element-moving")
                , HA.style "top" (String.fromInt top ++ "px")
                ]
                [ Html.div
                    [ HA.class "flex-row" ]
                    (List.append
                        [ Html.div
                            [ Draggable.mouseTrigger (Ui.Row card id) Msg.DragMsgReceived
                            , HA.style "width" "8px"
                            , HA.style "cursor" "ns-resize"
                            ]
                            [ FA.viewIcon FontAwesome.Solid.arrowsAltV ]
                        ]
                        (rowView id item)
                    )
                ]

          else
                Html.text ""
        ]
