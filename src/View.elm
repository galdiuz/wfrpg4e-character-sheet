module View exposing (view)

import Character as Character
import Css.Base as Css
import Css.Dark
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
        [ Css.column
        ]
        [ case model.ui.theme of
            Ui.Light ->
                Html.node "style" [] [ Html.text Css.styleSheet ]

            Ui.Dark ->
                Html.node "style" [] [ Html.text Css.Dark.styleSheet ]
        , FontAwesome.Styles.css
        , viewHeader
        , viewContent model
        , viewDatalists
        ]


viewHeader : Html Msg
viewHeader =
    Html.div
        [ Css.header
        , Css.row
        ]
        [ viewFile
        , Html.div
            [ Css.row ]
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
        [ Css.content
        ]
        (List.indexedMap
            (\index cards ->
                Html.div
                    [ Css.column
                    , HA.style "flex" "1"
                    , HA.style "position" "relative"
                    , HA.id (Ui.columnId index)
                    ]
                    (List.map
                        (\card ->
                            [ Html.div
                                [ HA.id (Ui.cardId card)
                                , HAE.attributeIf
                                    (Just (Ui.Card card) == model.ui.draggedElement)
                                    Css.transparent
                                , HAE.attributeIf
                                    (Dict.member (Ui.cardId card) model.ui.movingElements)
                                    Css.fading
                                ]
                                [ viewCard model card ]

                            , if Ui.isElementFloating model.ui (Ui.Card card) then
                                let
                                    ( left, top ) =
                                        Ui.getFloatingCardPosition model.ui card index
                                in
                                Html.div
                                    [ Css.floating
                                    , HAE.attributeIf
                                        (Dict.member (Ui.cardId card) model.ui.movingElements)
                                        Css.moving
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
        [ Css.card
        ]
        [ Html.div
            [ Css.cardHeader
            , Css.row
            ]
            [ Html.div
                [ Css.cardHeaderIcon
                , Css.cursorMove
                , Draggable.mouseTrigger (Ui.Card card) Msg.DragMsgReceived
                ]
                [ Icons.view (Ui.cardIcon card) ]
            , Html.span
                [ Css.cardHeaderTitle
                , Css.cursorMove
                , Draggable.mouseTrigger (Ui.Card card) Msg.DragMsgReceived
                ]
                [ Html.text (Ui.cardTitle card)
                ]
            , Html.div
                [ Css.row
                ]
                [ Html.div
                    [ Css.row ]
                    [ Html.button
                        [ Css.button
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
                [ Css.cardContent
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
                        [ Css.cardContentCollapsed
                        ]
                )
            )
            [ Html.div
                [ Css.cardContentInner
                , HAE.attributeMaybe
                    (\height ->
                        HA.style "height" (String.fromInt height ++ "px")
                    )
                    (Dict.get (Ui.cardId card) model.ui.cardContentHeights)
                , case Ui.getCardState card model.ui of
                    Ui.Open ->
                        HAE.empty

                    Ui.Collapsed ->
                        Css.cardContentInnerCollapsed

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
        [ Css.row ]
        [ viewButton
            { onClick = Msg.SavePressed
            , text = "Save"
            }
        , viewButton
            { onClick = Msg.LoadPressed
            , text = "Load"
            }
        ]


viewInformation : Model -> Html Msg
viewInformation model =
    Html.div
        [ Css.column
        ]
        [ Html.div
            [ Css.row
            ]
            [ viewTextInputWithLabel
                [ HA.style "flex" "2" ]
                { label = "Name"
                , list = Nothing
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Name)
                , value = model.character.info.name
                }
            , viewTextInputWithLabel
                [ HA.style "flex" "1" ]
                { label = "Species"
                , list = Just "datalist-species"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Species)
                , value = model.character.info.species
                }
            ]
        , Html.div
            [ Css.row
            ]
            [ viewTextInputWithLabel
                [ HA.style "flex" "1" ]
                { label = "Class"
                , list = Just "datalist-classes"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Class)
                , value = model.character.info.class
                }
            , viewTextInputWithLabel
                [ HA.style "flex" "1" ]
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
            [ Css.row
            ]
            [ viewTextInputWithLabel
                [ HA.style "flex" "4" ]
                { label = "Career Path"
                , list = Nothing
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.CareerPath)
                , value = model.character.info.careerPath
                }
            , viewTextInputWithLabel
                [ HA.style "flex" "1" ]
                { label = "Status"
                , list = Just "datalist-statuses"
                , onInput = Msg.TextFieldChanged (Character.setInformation Character.Status)
                , value = model.character.info.status
                }
            ]
        , Html.div
            [ Css.row
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
        [ Css.column
        ]
        [ Html.div
            [ Css.row
            ]
            [ Html.div
                [ Css.label
                , HA.style "flex" "2"
                ]
                [ Html.text "Characteristic" ]
            , Html.div
                [ Css.label
                , HA.style "flex" "1"
                ]
                [ Html.text "Initial" ]
            , Html.div
                [ Css.label
                , HA.style "flex" "1"
                ]
                [ Html.text "Advances" ]
            , Html.div
                [ Css.label
                , HA.style "flex" "1"
                ]
                [ Html.text "Current" ]
            ]
        , Html.div
            [ Css.column
            ]
            (List.map
                (\c12c ->
                    Html.div
                        [ Css.row
                        , Css.listRow
                        ]
                        [ Html.div
                            [ HA.style "flex" "2" ]
                            [ Html.text (Character.c12cToFullString c12c) ]
                        , Html.div
                            [ HA.style "flex" "1" ]
                            [ viewNumberInput
                                { onInput = Msg.NumberFieldChanged (Character.setC12csInitial c12c)
                                , value = Character.getC12c c12c model.character.c12csInitial
                                }
                            ]
                        , Html.div
                            [ HA.style "flex" "1" ]
                            [ viewNumberInput
                                { onInput = Msg.NumberFieldChanged (Character.setC12csAdvances c12c)
                                , value = Character.getC12c c12c model.character.c12csAdvances
                                }
                            ]
                        , Html.div
                            [ HA.style "flex" "1" ]
                            [ Character.getC12cs model.character
                                |> Character.getC12c c12c
                                |> String.fromInt
                                |> Html.text
                            ]
                        ]
                )
                Character.allC12cs
            )
        ]


viewTextInput :
    { list : Maybe String
    , onInput : String -> msg
    , value : String
    }
    -> Html msg
viewTextInput data =
    Html.input
        [ Css.input
        , HA.type_ "text"
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
        [ Css.textarea
        ]
        [ Html.div
            [ Css.input
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
            [ Css.input
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
        [ Css.input
        , HA.type_ "number"
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
            [ Css.label
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
        [ Css.button
        , Events.onClick data.onClick
        ]
        [ Html.text data.text ]


viewExperience : Model -> Html Msg
viewExperience model =
    Html.div
        [ Css.column
        , HA.style "gap" "16px"
        ]
        [ viewExperienceTable model
        , viewAdjustments model
        ]


viewExperienceTable : Model -> Html Msg
viewExperienceTable model =
    Html.div
        [ Css.row
        ]
        [ viewNumberInputWithLabel
            [ HA.style "flex" "1" ]
            { label = "Total"
            , onInput = Msg.NumberFieldChanged (Character.setExperience)
            , value = model.character.experience
            }
        , Html.div
            [ HA.style "flex" "1" ]
            [ Html.div
                [ Css.label ]
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
            [ Html.div
                [ Css.label ]
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
        [ Css.column
        ]
        [ Html.div
            [ HA.style "font-size" "18px"
            ]
            [ Html.text "Basic skills" ]
        , Html.div
            [ Css.column
            ]
            [ Html.div
                [ Css.row
                ]
                [ Html.div
                    [ Css.label
                    , HA.style "flex" "9"
                    ]
                    [ Html.text "Name" ]
                , Html.div
                    [ Css.label
                    , HA.style "flex" "5"
                    ]
                    [ Html.text "Characteristic" ]
                , Html.div
                    [ Css.label
                    , HA.style "flex" "4"
                    ]
                    [ Html.text "Advances" ]
                , Html.div
                    [ Css.label
                    , HA.style "flex" "2"
                    ]
                    [ Html.text "Skill" ]
                ]
            , Html.div
                [ Css.column
                ]
                (List.indexedMap
                    (\index skill ->
                        Html.div
                            [ Css.row
                            , Css.listRow
                            ]
                            [ Html.div
                                [ HA.style "flex" "9" ]
                                [ Html.text skill.name ]
                            , Html.div
                                [ Css.row
                                , HA.style "flex" "5"
                                ]
                                [ Html.div
                                    [ HA.style "flex" "1" ]
                                    [ Html.text (Character.c12cToString skill.c12c) ]
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
                                    { onInput = Msg.NumberFieldChanged (Character.setBasicSkillAdvances index)
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
                    )
                    model.character.basicSkills
                )
            ]
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
                        [ Css.label
                        , HA.style "flex" "9"
                        ]
                        [ Html.text "Name" ]
                    , Html.div
                        [ Css.label
                        , HA.style "flex" "5"
                        ]
                        [ Html.text "Characteristic" ]
                    , Html.div
                        [ Css.label
                        , HA.style "flex" "4"
                        ]
                        [ Html.text "Advances" ]
                    , Html.div
                        [ Css.label
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
                        [ Css.row
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
        [ Css.select
        , Events.onInput (data.onInput)
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
                    [ Css.label
                    , HA.style "flex" "2"
                    ]
                    [ Html.text "Name" ]
                , Html.div
                    [ Css.label
                    , HA.style "flex" "0 0 45px"
                    ]
                    [ Html.text "# taken" ]
                , Html.div
                    [ Css.label
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
                    [ Css.label
                    , HA.style "flex" "1"
                    ]
                    [ Html.text "Value" ]
                , Html.div
                    [ Css.label
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
                    [ Css.label
                    , HA.style "flex" "1"
                    ]
                    [ Html.text "Name" ]
                , Html.div
                    [ Css.label
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
        [ Css.column
        ]
        [ Html.div
            [ Css.row ]
            [ viewNumberInputWithLabel
                [ HA.style "flex" "1" ]
                { label = "Gold Crowns"
                , onInput = Msg.NumberFieldChanged (Character.setGold)
                , value = model.character.wealth.gold
                }
            , viewNumberInputWithLabel
                [ HA.style "flex" "1" ]
                { label = "Silver Shillings"
                , onInput = Msg.NumberFieldChanged (Character.setSilver)
                , value = model.character.wealth.silver
                }
            , viewNumberInputWithLabel
                [ HA.style "flex" "1" ]
                { label = "Brass Pennies"
                , onInput = Msg.NumberFieldChanged (Character.setBrass)
                , value = model.character.wealth.brass
                }
            ]
        , Html.div
            [ Css.row
            ]
            [ Html.div
                [ HA.style "flex" "2" ]
                []
            , Html.div
                [ HA.style "flex" "1" ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.convertOneGoldToSilver)
                    , text = ">"
                    }
                ]
            , Html.div
                [ HA.style "flex" "1" ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.convertAllGoldToSilver)
                    , text = ">>"
                    }
                ]
            , Html.div
                [ HA.style "flex" "1" ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.convertAllSilverToGold)
                    , text = "<<"
                    }
                ]
            , Html.div
                [ HA.style "flex" "1" ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.convertOneSilverToGold)
                    , text = "<"
                    }
                ]
            , Html.div
                [ HA.style "flex" "1" ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.convertOneSilverToBrass)
                    , text = ">"
                    }
                ]
            , Html.div
                [ HA.style "flex" "1" ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.convertAllSilverToBrass)
                    , text = ">>"
                    }
                ]
            , Html.div
                [ HA.style "flex" "1" ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.convertAllBrassToSilver)
                    , text = "<<"
                    }
                ]
            , Html.div
                [ HA.style "flex" "1" ]
                [ viewButton
                    { onClick = Msg.ButtonPressed (Character.convertOneBrassToSilver)
                    , text = "<"
                    }
                ]
            , Html.div
                [ HA.style "flex" "2" ]
                []
            ]
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
                    [ Css.column
                    ]
                    [ Html.div
                        [ Css.row ]
                        [ viewTextInputWithLabel
                            [ HA.style "flex" "2" ]
                            { label = "Name"
                            , list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setWeaponName id)
                            , value = weapon.name
                            }
                        , viewTextInputWithLabel
                            [ HA.style "flex" "1" ]
                            { label = "Damage"
                            , list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setWeaponDamage id)
                            , value = weapon.damage
                            }
                        , viewTextInputWithLabel
                            [ HA.style "flex" "1" ]
                            { label = "Group"
                            , list = Nothing
                            , onInput = Msg.TextFieldChanged (Character.setWeaponGroup id)
                            , value = weapon.group
                            }
                        ]
                    , Html.div
                        [ Css.row ]
                        [ viewNumberInputWithLabel
                            [ HA.style "flex" "1" ]
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
            [ Css.column
            ]
            [ Html.div
                [ Css.row
                ]
                [ viewNumberInputWithLabel
                    [ HA.style "flex" "1" ]
                    { label = "Left arm (10-24)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.LeftArm)
                    , value = model.character.ap.leftArm
                    }
                , viewNumberInputWithLabel
                    [ HA.style "flex" "1" ]
                    { label = "Head (01-09)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.Head)
                    , value = model.character.ap.head
                    }
                , viewNumberInputWithLabel
                    [ HA.style "flex" "1" ]
                    { label = "Right arm (10-24)"
                    , onInput = Msg.NumberFieldChanged (Character.setAp Character.RightArm)
                    , value = model.character.ap.rightArm
                    }
                ]
            , Html.div
                [ Css.row
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
                        [ Css.column ]
                        [ Html.div
                            [ Css.row ]
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
                                [ HA.style "flex" "1" ]
                                { label = "AP"
                                , onInput = Msg.NumberFieldChanged (Character.setArmourAp id)
                                , value = armour.ap
                                }
                            ]
                        , Html.div
                            [ Css.row ]
                            [ viewNumberInputWithLabel
                                [ HA.style "flex" "1" ]
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
        [ Css.column
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
                    [ Css.label ]
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
                    [ Css.label ]
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
                    [ Css.label ]
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
                [ HA.style "flex" "1" ]
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
                    [ Css.label ]
                    [ Html.text "Total" ]
                , Character.getWounds model.character
                    |> String.fromInt
                    |> Html.text
                ]
            , viewNumberInputWithLabel
                [ HA.style "flex" "1" ]
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
                        [ Css.label
                        , HA.style "flex" "1"
                        ]
                        [ Html.text "Location" ]
                    , Html.div
                        [ Css.label
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
        [ Css.row
        , HA.style "align-items" "flex-end"
        ]
        [ Html.div
            [ HA.style "flex" "1" ]
            [ Html.div
                [ Css.label ]
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
                [ Css.label ]
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
                [ Css.label ]
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
                [ Css.label ]
                [ Html.text "Total" ]
            , Character.totalEncumbrance model.character
                |> String.fromInt
                |> Html.text
            ]
        , Html.div
            []
            [ Html.text "/" ]
        , viewNumberInputWithLabel
            [ HA.style "flex" "1" ]
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
        [ Css.row ]
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
        [ Css.row ]
        [ viewNumberInputWithLabel
            [ HA.style "flex" "1" ]
            { label = "Movement"
            , onInput = Msg.NumberFieldChanged Character.setMovement
            , value = model.character.movement
            }
        , Html.div
            [ HA.style "flex" "1" ]
            [ Html.div
                [ Css.label ]
                [ Html.text "Walk" ]
            , Html.text (String.fromInt (Character.walk model.character))
            ]
        , Html.div
            [ HA.style "flex" "1" ]
            [ Html.div
                [ Css.label ]
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
                            [ Css.column
                            ]
                            [ Html.div
                                [ Css.row ]
                                [ viewTextInputWithLabel
                                    [ HA.style "flex" "1" ]
                                    { label = "Name"
                                    , list = Nothing
                                    , onInput = Msg.TextFieldChanged (Character.setSpellName id)
                                    , value = spell.name
                                    }
                                , viewTextInputWithLabel
                                    [ HA.style "flex" "1" ]
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
                                [ Css.row ]
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
                                [ Css.label ]
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
        [ Css.column
        , HA.style "gap" "16px"
        ]
        [ Html.div
            [ Css.row ]
            [ viewNumberInputWithLabel
                [ HA.style "flex" "1" ]
                { label = "Corruption Points"
                , onInput = Msg.NumberFieldChanged (Character.setCorruption)
                , value = model.character.corruption
                }
            , Html.div
                [ HA.style "flex" "1" ]
                [ Html.div
                    [ Css.label ]
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
                        [ Css.label
                        , HA.style "flex" "3"
                        ]
                        [ Html.text "Kind" ]
                    , Html.div
                        [ Css.label
                        , HA.style "flex" "4"
                        ]
                        [ Html.text "Description" ]
                    , Html.div
                        [ Css.label
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
        [ Css.column ]
        [ case data.headerView of
            Just headerView ->
                Html.div
                    [ Css.row ]
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
            [ Css.column
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
        [ HA.class "list-row" ]
        [ Html.div
            [ HA.id (Ui.draggableElementId element)
            , HAE.attributeIf
                (Just element == model.ui.draggedElement)
                (Css.transparent)
            , HAE.attributeIf
                (Dict.member (Ui.draggableElementId element) model.ui.movingElements)
                (Css.fading)
            ]
            [ Html.div
                [ Css.row ]
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
                [ Css.floating
                , HAE.attributeIf
                    (Dict.member (Ui.draggableElementId element) model.ui.movingElements)
                    (Css.moving)
                , HA.style "top" (String.fromInt top ++ "px")
                ]
                [ Html.div
                    [ Css.row ]
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
