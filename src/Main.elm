module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation
import Character
import Cmd.Extra
import Dict exposing (Dict)
import Draggable
import Draggable.Events
import File
import File.Download
import File.Select
import Json.Decode
import Json.Encode
import Model exposing (Model)
import Msg as Msg exposing (Msg)
import Process
import Task
import Ui
import Url
import View


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = \_ -> Msg.NoOp
        , onUrlChange = \_ -> Msg.NoOp
        }


init : flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url _ =
    { character = Character.emptyCharacter
    , ui = Ui.emptyUi
    }
        |> Cmd.Extra.withCmd
            (Task.perform
                (\viewport ->
                    Msg.SetWindowSize
                        (floor viewport.scene.width)
                        (floor viewport.scene.height)
                )
                Browser.Dom.getViewport
            )


view : Model -> Browser.Document Msg
view model =
    { body = [ View.view model ]
    , title = ""
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize Msg.SetWindowSize
        , Draggable.subscriptions Msg.DragMsg model.ui.drag
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.NoOp ->
            Cmd.Extra.withNoCmd model

        Msg.SetC12csAdvances c12c str ->
            parseIntAndSet
                { string = str
                , setter = Character.setC12csAdvances c12c
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.SetC12csInitial c12c str ->
            parseIntAndSet
                { string = str
                , setter = Character.setC12csInitial c12c
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.SetAdvancedSkillAdvances index str ->
            parseIntAndSet
                { string = str
                , setter = Character.setAdvancedSkillAdvances index
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.SetAdvancedSkillName index str ->
            Character.setAdvancedSkillName index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetBasicSkillAdvances index str ->
            parseIntAndSet
                { string = str
                , setter = Character.setBasicSkillAdvances index
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.AddAdvancedSkill ->
            Character.addAdvancedSkill model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetAdvancedSkillC12c index str ->
            case Character.c12cFromString str of
                Ok c12c ->
                    Character.setAdvancedSkillC12c index c12c model.character
                        |> Model.asCharacterIn model
                        |> Cmd.Extra.withNoCmd

                Err _ ->
                    Cmd.Extra.withNoCmd model

        Msg.AddTalent ->
            Character.addTalent model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetTalentTimesTaken index str ->
            parseIntAndSet
                { string = str
                , setter = Character.setTalentTimesTaken index
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.SetTalentName index str ->
            Character.setTalentName index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetTalentDescription index str ->
            Character.setTalentDescription index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetExperience str ->
            parseIntAndSet
                { string = str
                , setter = Character.setExperience
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.AddExpAdjustment ->
            Character.addExpAdjustment model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetExpAdjustmentDescription index str ->
            Character.setExpAdjustmentDescription index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetExpAdjustmentValue index str ->
            parseIntAndSet
                { string = str
                , setter = Character.setExpAdjustmentValue index
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.Save ->
            ( model
            , Json.Encode.encode 0 (Character.encodeCharacter model.character)
                |> File.Download.string "file.json" "application/json"
            )

        Msg.Load ->
            ( model
            , File.Select.file [ "application/json" ] Msg.LoadFile
            )

        Msg.LoadFile file ->
            ( model
            , Task.perform Msg.LoadString (File.toString file)
            )

        Msg.LoadString str ->
            case Json.Decode.decodeString Character.decodeCharacter str of
                Ok character ->
                    character
                        |> Model.asCharacterIn model
                        |> Cmd.Extra.withNoCmd

                Err err ->
                    Cmd.Extra.withNoCmd model

        Msg.SetInformation field value ->
            Character.setInformation field value model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetWindowSize x y ->
            Ui.updateWindowWidth model.ui x
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetDragPosition ( dx, dy ) ->
            let
                ( x, y ) =
                    model.ui.dragPosition
            in
            Ui.setDragPosition
                ( round (toFloat x + dx)
                , round (toFloat y + dy)
                )
                model.ui
                |> Ui.updateDraggedCard
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetDragElement cardType ->
            model
                |> Cmd.Extra.withCmd
                    (Browser.Dom.getElement (Ui.cardId cardType)
                        |> Task.map .element
                        |> Task.attempt
                            (Result.map (Msg.SetDragElementData cardType)
                                >> Result.withDefault Msg.NoOp
                            )
                    )
                |> Cmd.Extra.addCmds
                    (List.map
                        (\card ->
                            Browser.Dom.getElement (Ui.cardId card)
                                |> Task.map .element
                                |> Task.attempt
                                    (Result.map (Msg.SetCardData card)
                                        >> Result.withDefault Msg.NoOp
                                    )
                        )
                        Ui.allCards
                    )
                |> Cmd.Extra.addCmds
                    (List.indexedMap
                        (\index _ ->
                            Browser.Dom.getElement (Ui.columnId index)
                                |> Task.map .element
                                |> Task.attempt
                                    (Result.map (Msg.SetColumnData index)
                                        >> Result.withDefault Msg.NoOp
                                    )
                        )
                        model.ui.columns
                    )

        Msg.SetCardData card data ->
            Ui.setCardHeight card (round data.height) model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetColumnData index data ->
            Ui.setColumnPosition index ( round data.x, round data.y ) model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetDragElementData card data ->
            model.ui
                |> Ui.setDraggedCard (Just card)
                |> Ui.setDragPosition
                    ( round (data.x)
                    , round (data.y)
                    )
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.ClearDragElementOnClick _ ->
            Ui.setDraggedCard Nothing model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.ClearDragElementOnDragEnd ->
            model
                |> Cmd.Extra.withCmd
                    (case model.ui.draggedCard of
                        Just card ->
                            Browser.Dom.getElement (Ui.cardId card)
                                |> Task.map .element
                                |> Task.attempt
                                    (Result.map (Msg.GotElement card)
                                        >> Result.withDefault Msg.NoOp
                                    )

                        Nothing ->
                            Cmd.none
                    )

        Msg.GotElement card data ->
            model.ui
                |> Ui.setMovingCard card ( round data.x, round data.y )
                |> Ui.setDraggedCard Nothing
                |> Ui.setDragPosition ( 0, 0 )
                |> Model.asUiIn model
                |> Cmd.Extra.withCmd
                    (Process.sleep 1000
                        |> Task.perform (\_ -> Msg.RemoveMovingCard card)
                    )

        Msg.RemoveMovingCard card ->
            Ui.removeMovingCard card model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.DragMsg dragMsg ->
            Draggable.update dragConfig dragMsg model.ui
                |> Tuple.mapFirst (Model.asUiIn model)

        Msg.AddTrapping ->
            Character.addTrapping model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetTrappingName index str ->
            Character.setTrappingName index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetTrappingEncumbrance index str ->
            parseIntAndSet
                { string = str
                , setter = Character.setTrappingEncumbrance index
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.SetWealthGold str ->
            parseIntAndSet
                { string = str
                , setter = Character.setGold
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.SetWealthSilver str ->
            parseIntAndSet
                { string = str
                , setter = Character.setSilver
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.SetWealthBrass str ->
            parseIntAndSet
                { string = str
                , setter = Character.setBrass
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertAllSilverToGold ->
            Character.convertAllSilverToGold model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertOneSilverToGold ->
            Character.convertOneSilverToGold model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertAllSilverToBrass ->
            Character.convertAllSilverToBrass model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertOneSilverToBrass ->
            Character.convertOneSilverToBrass model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertAllGoldToSilver ->
            Character.convertAllGoldToSilver model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertOneGoldToSilver ->
            Character.convertOneGoldToSilver model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertAllBrassToSilver ->
            Character.convertAllBrassToSilver model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.ConvertOneBrassToSilver ->
            Character.convertOneBrassToSilver model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.AddWeapon ->
            Character.addWeapon model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetWeaponDamage index str ->
            Character.setWeaponDamage index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetWeaponEncumbrance index str ->
            parseIntAndSet
                { string = str
                , setter = Character.setWeaponEncumbrance index
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.SetWeaponGroup index str ->
            Character.setWeaponGroup index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetWeaponName index str ->
            Character.setWeaponName index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetWeaponQualities index str ->
            Character.setWeaponQualities index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetWeaponRange index str ->
            Character.setWeaponRange index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.AddArmour ->
            Character.addArmour model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetArmourAp index str ->
            parseIntAndSet
                { string = str
                , setter = Character.setArmourAp index
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.SetArmourEncumbrance index str ->
            parseIntAndSet
                { string = str
                , setter = Character.setArmourEncumbrance index
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.SetArmourLocations index str ->
            Character.setArmourLocations index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetArmourName index str ->
            Character.setArmourName index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetArmourQualities index str ->
            Character.setArmourQualities index str model.character
                |> Model.asCharacterIn model
                |> Cmd.Extra.withNoCmd

        Msg.SetCurrentWounds str ->
            parseIntAndSet
                { string = str
                , setter = Character.setCurrentWounds
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.SetExtraWounds str ->
            parseIntAndSet
                { string = str
                , setter = Character.setExtraWounds
                }
                model
                |> Cmd.Extra.withNoCmd

        Msg.ToggleCardState card ->
            Ui.toggleCardState card model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.CollapseAllCards ->
            Ui.collapseAllCards model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd

        Msg.ExpandAllCards ->
            Ui.expandAllCards model.ui
                |> Model.asUiIn model
                |> Cmd.Extra.withNoCmd


dragConfig : Draggable.Config Ui.Card Msg
dragConfig =
    Draggable.customConfig
        [ Draggable.Events.onDragBy Msg.SetDragPosition
        , Draggable.Events.onMouseDown Msg.SetDragElement
        , Draggable.Events.onDragEnd Msg.ClearDragElementOnDragEnd
        , Draggable.Events.onClick Msg.ClearDragElementOnClick
        ]


parseIntAndSet :
    { string : String
    , setter : Int -> Character.Character -> Character.Character
    }
    -> Model
    -> Model
parseIntAndSet data model =
    case String.toInt data.string of
        Just value ->
            data.setter value model.character
                |> Model.asCharacterIn model

        Nothing ->
            if String.isEmpty data.string then
                data.setter 0 model.character
                    |> Model.asCharacterIn model

            else
                model
