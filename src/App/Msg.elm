module App.Msg exposing (Msg(..))

import App
import File


type Msg
    = NoOp
    | SetC12csAdvances App.C12c String
    | SetC12csInitial App.C12c String
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
    | FileLoaded String
    | SetInformation String String
