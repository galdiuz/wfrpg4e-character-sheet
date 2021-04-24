module App exposing (..)


type alias Model =
    { character : Character
    }


type alias Character =
    { c12csInitial : C12cs
    , c12csAdvances : C12cs
    , basicSkills : List Skill
    , advancedSkills : List Skill
    , talents : List Talent
    , experience : Int
    , expAdjustments : List ExpAdjustment
    }


emptyCharacter : Character
emptyCharacter =
    { c12csInitial = emptyC12cs
    , c12csAdvances = emptyC12cs
    , basicSkills = basicSkills
    , advancedSkills = []
    , talents = []
    , experience = 0
    , expAdjustments = []
    }


type alias C12cs =
    { ws : Int
    , bs : Int
    , s : Int
    , t : Int
    , i : Int
    , ag : Int
    , dex : Int
    , int : Int
    , wp : Int
    , fel : Int
    }


type C12c
    = WS
    | BS
    | S
    | T
    | I
    | Ag
    | Dex
    | Int
    | WP
    | Fel


type alias Skill =
    { advances : Int
    , c12c : C12c
    , name : String
    }


type alias Talent =
    { description : String
    , timesTaken : Int
    , name : String
    }


emptyTalent : Talent
emptyTalent =
    { description = ""
    , timesTaken = 0
    , name = ""
    }


type alias ExpAdjustment =
    { description : String
    , value : Int
    }


emptyExpAdjustment : ExpAdjustment
emptyExpAdjustment =
    { description = ""
    , value = 0
    }


basicSkills : List Skill
basicSkills =
    [ { advances = 0
      , c12c = Dex
      , name = "Art"
      }
    , { advances = 0
      , c12c = Ag
      , name = "Athletics"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Bribery"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Charm"
      }
    , { advances = 0
      , c12c = WP
      , name = "Charm Animal"
      }
    , { advances = 0
      , c12c = S
      , name = "Climb"
      }
    , { advances = 0
      , c12c = WP
      , name = "Cool"
      }
    , { advances = 0
      , c12c = T
      , name = "Consume Alcohol"
      }
    , { advances = 0
      , c12c = Ag
      , name = "Dodge"
      }
    , { advances = 0
      , c12c = Ag
      , name = "Drive"
      }
    , { advances = 0
      , c12c = T
      , name = "Endurance"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Entertain"
      }
    , { advances = 0
      , c12c = Int
      , name = "Gamble"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Gossip"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Haggle"
      }
    , { advances = 0
      , c12c = S
      , name = "Intimidate"
      }
    , { advances = 0
      , c12c = I
      , name = "Intuition"
      }
    , { advances = 0
      , c12c = Fel
      , name = "Leadership"
      }
    , { advances = 0
      , c12c = WS
      , name = "Melee (Basic)"
      }
    , { advances = 0
      , c12c = I
      , name = "Navigation"
      }
    , { advances = 0
      , c12c = Int
      , name = "Outdoor Survival"
      }
    , { advances = 0
      , c12c = I
      , name = "Perception"
      }
    , { advances = 0
      , c12c = Ag
      , name = "Ride"
      }
    , { advances = 0
      , c12c = S
      , name = "Row"
      }
    , { advances = 0
      , c12c = Ag
      , name = "Stealth"
      }
    ]


emptySkill : Skill
emptySkill =
    { advances = 0
    , c12c = WS
    , name = ""
    }


emptyC12cs : C12cs
emptyC12cs =
    { ws = 0
    , bs = 0
    , s = 0
    , t = 0
    , i = 0
    , ag = 0
    , dex = 0
    , int = 0
    , wp = 0
    , fel = 0
    }


allC12cs : List C12c
allC12cs =
    [ WS
    , BS
    , S
    , T
    , I
    , Ag
    , Dex
    , Int
    , WP
    , Fel
    ]


addC12cs : C12cs -> C12cs -> C12cs
addC12cs a b =
    { ws = a.ws + b.ws
    , bs = a.bs + b.bs
    , s = a.s + b.s
    , t = a.t + b.t
    , i = a.i + b.i
    , ag = a.ag + b.ag
    , dex = a.dex + b.dex
    , int = a.int + b.int
    , wp = a.wp + b.wp
    , fel = a.fel + b.fel
    }


getC12c : C12c -> C12cs -> Int
getC12c c12c c12cs =
    case c12c of
        WS -> c12cs.ws
        BS -> c12cs.bs
        S -> c12cs.s
        T -> c12cs.t
        I -> c12cs.i
        Ag -> c12cs.ag
        Dex -> c12cs.dex
        Int -> c12cs.int
        WP -> c12cs.wp
        Fel -> c12cs.fel


getC12cs : Character -> C12cs
getC12cs character =
    addC12cs character.c12csInitial character.c12csAdvances


setC12c : Int -> C12c -> C12cs -> C12cs
setC12c value c12c c12cs =
    case c12c of
        WS -> { c12cs | ws = value }
        BS -> { c12cs | bs = value }
        S -> { c12cs | s = value }
        T -> { c12cs | t = value }
        I -> { c12cs | i = value }
        Ag -> { c12cs | ag = value }
        Dex -> { c12cs | dex = value }
        Int -> { c12cs | int = value }
        WP -> { c12cs | wp = value }
        Fel -> { c12cs | fel = value }


c12cToString : C12c -> String
c12cToString c12c =
    case c12c of
        WS -> "WS"
        BS -> "BS"
        S -> "S"
        T -> "T"
        I -> "I"
        Ag -> "Ag"
        Dex -> "Dex"
        Int -> "Int"
        WP -> "WP"
        Fel -> "Fel"


c12cToFullString : C12c -> String
c12cToFullString c12c =
    case c12c of
        WS -> "Weapon Skill"
        BS -> "Ballistic Skill"
        S -> "Strength"
        T -> "Toughness"
        I -> "Initiative"
        Ag -> "Agility"
        Dex -> "Dexterity"
        Int -> "Intelligence"
        WP -> "Willpower"
        Fel -> "Fellowship"


c12cFromString : String -> Maybe C12c
c12cFromString str =
    case str of
        "WS" -> Just WS
        "BS" -> Just BS
        "S" -> Just S
        "T" -> Just T
        "I" -> Just I
        "Ag" -> Just Ag
        "Dex" -> Just Dex
        "Int" -> Just Int
        "WP" -> Just WP
        "Fel" -> Just Fel
        _ -> Nothing


c12csCost : C12cs -> Int
c12csCost c12cs =
    List.foldl
        (\c12c total ->
            total + c12cCost (getC12c c12c c12cs)
        )
        0
        allC12cs


c12cCost : Int -> Int
c12cCost value =
    if value <= 5 then
        25 * value

    else if value <= 10 then
        30 * (value - 5) + 125

    else if value <= 15 then
        40 * (value - 10) + 275

    else if value <= 20 then
        50 * (value - 15) + 475

    else if value <= 25 then
        70 * (value - 20) + 725

    else if value <= 30 then
        90 * (value - 25) + 1075

    else if value <= 35 then
        120 * (value - 30) + 1525

    else if value <= 40 then
        150 * (value - 35) + 2125

    else if value <= 45 then
        190 * (value - 40) + 2875

    else
        230 * (value - 45) + 3825


skillCost : Int -> Int
skillCost value =
    if value <= 5 then
        10 * value

    else if value <= 10 then
        15 * (value - 5) + 50

    else if value <= 15 then
        20 * (value - 10) + 125

    else if value <= 20 then
        30 * (value - 15) + 225

    else if value <= 25 then
        40 * (value - 20) + 375

    else if value <= 30 then
        60 * (value - 25) + 575

    else if value <= 35 then
        80 * (value - 30) + 875

    else if value <= 40 then
        110 * (value - 35) + 1275

    else if value <= 45 then
        140 * (value - 40) + 1825

    else
        180 * (value - 45) + 2525


skillValue : Character -> Skill -> Int
skillValue character skill =
    getC12c skill.c12c (getC12cs character) + skill.advances


skillsCost : List Skill -> Int
skillsCost skills =
    List.foldl
        (\skill total ->
            total + skillCost skill.advances
        )
        0
        skills


talentsCost : List Talent -> Int
talentsCost talents =
    List.foldl
        (\talent total ->
            total + (talent.timesTaken * (talent.timesTaken + 1) * 50)
        )
        0
        talents


expAdjustmentsCost : List ExpAdjustment -> Int
expAdjustmentsCost adjustments =
    List.map .value adjustments
        |> List.foldl (+) 0


currentExp : Character -> Int
currentExp character =
    character.experience - spentExp character


spentExp : Character -> Int
spentExp character =
    List.foldl
        (+)
        0
        [ c12csCost character.c12csAdvances
        , skillsCost character.basicSkills
        , skillsCost character.advancedSkills
        , talentsCost character.talents
        , expAdjustmentsCost character.expAdjustments
        ]
