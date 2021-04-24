module App.Msg exposing (Msg(..))

import App


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
    | AddExpAdjustment
    | SetExpAdjustmentValue Int String
    | SetExpAdjustmentDescription Int String
