module Msg exposing (Msg(..))

import Character as Character
import Draggable
import File
import Ui


type Msg
    = NoOp
    | SetC12csAdvances Character.C12c String
    | SetC12csInitial Character.C12c String
    | SetBasicSkillAdvances Int String
    | SetAdvancedSkillAdvances Int String
    | SetAdvancedSkillName Int String
    | SetAdvancedSkillC12c Int String
    | AddAdvancedSkill
    | AddTalent
    | SetTalentName Int String
    | SetTalentTimesTaken Int String
    | SetTalentDescription Int String
    | SetExperience String
    | AddExpAdjustment
    | SetExpAdjustmentValue Int String
    | SetExpAdjustmentDescription Int String
    | Save
    | Load
    | LoadFile File.File
    | LoadString String
    | SetInformation String String
    | SetWindowSize Int Int
    | SetDragElement Ui.Card
    | SetDragPosition Draggable.Delta
    | DragMsg (Draggable.Msg Ui.Card)
    | SetDragElementData Element
    | ClearDragElementOnClick Ui.Card
    | ClearDragElementOnDragEnd
    | SetCardData Ui.Card Element
    | AddTrapping
    | SetTrappingName Int String
    | SetTrappingEncumbrance Int String
    | SetWealthGold String
    | SetWealthSilver String
    | SetWealthBrass String
    | ConvertAllSilverToGold
    | ConvertOneSilverToGold
    | ConvertAllSilverToBrass
    | ConvertOneSilverToBrass
    | ConvertAllBrassToSilver
    | ConvertOneBrassToSilver
    | ConvertAllGoldToSilver
    | ConvertOneGoldToSilver
    | AddWeapon
    | SetWeaponDamage Int String
    | SetWeaponEncumbrance Int String
    | SetWeaponGroup Int String
    | SetWeaponName Int String
    | SetWeaponQualities Int String
    | SetWeaponRange Int String
    | AddArmour
    | SetArmourAp Int String
    | SetArmourEncumbrance Int String
    | SetArmourLocations Int String
    | SetArmourName Int String
    | SetArmourQualities Int String


type alias Element =
    { x : Float
    , y : Float
    , width : Float
    , height : Float
    }
