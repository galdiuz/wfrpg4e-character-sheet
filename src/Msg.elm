module Msg exposing (Msg(..))

import Character as Character
import Draggable
import File


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
    | SetDragDelta Draggable.Delta
    | DragMsg (Draggable.Msg String)
