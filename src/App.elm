module App exposing (..)


type alias Model =
    { character : Character
    }


type alias Character =
    { c12csInitial : C12cs
    , c12csAdvances : C12cs
    , skills : List Skill
    }


emptyCharacter : Character
emptyCharacter =
    { c12csInitial = emptyC12cs
    , c12csAdvances = emptyC12cs
    , skills = []
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
    { advancements : Int
    , c12c : C12c
    , name : String
    }


type alias Talent =
    { name : String
    , timesTaken : String
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


skillValue : C12cs -> Skill -> Int
skillValue c12cs skill =
    getC12c skill.c12c c12cs + skill.advancements
