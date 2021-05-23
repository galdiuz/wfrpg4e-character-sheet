module Data exposing (..)

import List.Extra


type alias Class =
    { name : String
    , careers : List Career
    }


type alias Career =
    { name : String
    , levels : List CareerLevel
    }


type alias CareerLevel =
    { name : String
    , status : String
    }


classes : List Class
classes =
    [ academic
    , burgher
    , courtier
    , peasant
    , ranger
    , riverfolk
    , rogue
    , warrior
    ]


getStatus : String -> String -> String -> Maybe String
getStatus class career level =
    List.Extra.find ((==) class << .name) classes
        |> Maybe.map .careers
        |> Maybe.andThen (List.Extra.find ((==) career << .name))
        |> Maybe.map .levels
        |> Maybe.andThen (List.Extra.find ((==) level << .name))
        |> Maybe.map .status


species : List String
species =
    [ "Dwarf"
    , "Halfling"
    , "High Elf"
    , "Human"
    , "Wood Elf"
    ]


statuses : List String
statuses =
    [ "Brass 0"
    , "Brass 1"
    , "Brass 2"
    , "Brass 3"
    , "Brass 4"
    , "Brass 5"
    , "Gold 1"
    , "Gold 2"
    , "Gold 3"
    , "Gold 4"
    , "Gold 5"
    , "Gold 6"
    , "Gold 7"
    , "Silver 1"
    , "Silver 2"
    , "Silver 3"
    , "Silver 4"
    , "Silver 5"
    ]


--------------
-- Academic --
--------------

academic : Class
academic =
    { name = "Academic"
    , careers =
         [ apothecary
         , engineer
         , lawyer
         , nun
         , physician
         , priest
         , scholar
         , wizard
         ]
    }


apothecary : Career
apothecary =
    { name = "Apothecary"
    , levels =
        [ { name = "Apothecary’s Apprentice"
          , status = "Brass 3"
          }
        , { name = "Apothecary"
          , status = "Silver 1"
          }
        , { name = "Master Apothecary"
          , status = "Silver 3"
          }
        , { name = "Apothecary-General"
          , status = "Gold 1"
          }
        ]
    }


engineer : Career
engineer =
    { name = "Engineer"
    , levels =
        [ { name = "Student Engineer"
          , status = "Brass 4"
          }
        , { name = "Engineer"
          , status = "Silver 2"
          }
        , { name = "Master Engineer"
          , status = "Silver 4"
          }
        , { name = "Chartered Engineer"
          , status = "Gold 2"
          }
        ]
    }


lawyer : Career
lawyer =
    { name = "Lawyer"
    , levels =
        [ { name = "Student Lawyer"
          , status = "Brass 4"
          }
        , { name = "Lawyer"
          , status = "Silver 3"
          }
        , { name = "Barrister"
          , status = "Gold 1"
          }
        , { name = "Judge"
          , status = "Gold 2"
          }
        ]
    }


nun : Career
nun =
    { name = "Nun"
    , levels =
        [ { name = "Novitiate"
          , status = "Brass 1"
          }
        , { name = "Nun"
          , status = "Brass 4"
          }
        , { name = "Abbess"
          , status = "Silver 2"
          }
        , { name = "Prioress Genera"
          , status = "Silver 5"
          }
        ]
    }


physician : Career
physician =
    { name = "Physician"
    , levels =
        [ { name = "Physician’s Apprentice"
          , status = "Brass 4"
          }
        , { name = "Physician"
          , status = "Silver 3"
          }
        , { name = "Doktor"
          , status = "Silver 5"
          }
        , { name = "Court Physician"
          , status = "Gold 1"
          }
        ]
    }


priest : Career
priest =
    { name = "Priest"
    , levels =
        [ { name = "Initiate"
          , status = "Brass 2"
          }
        , { name = "Priest"
          , status = "Silver 1"
          }
        , { name = "High Priest"
          , status = "Gold 1"
          }
        , { name = "Lector"
          , status = "Gold 2"
          }
        ]
    }


scholar : Career
scholar =
    { name = "Scholar"
    , levels =
        [ { name = "Student"
          , status = "Brass 3"
          }
        , { name = "Scholar"
          , status = "Silver 2"
          }
        , { name = "Fellow"
          , status = "Silver 5"
          }
        , { name = "Professor"
          , status = "Gold 1"
          }
        ]
    }


wizard : Career
wizard =
    { name = "Wizard"
    , levels =
        [ { name = "Wizard's Apprenctice"
          , status = "Brass 3"
          }
        , { name = "Wizard"
          , status = "Silver 3"
          }
        , { name = "Master Wizard"
          , status = "Gold 1"
          }
        , { name = "Wizard Lord"
          , status = "Gold 2"
          }
        ]
    }

-------------
-- Burgher --
-------------

burgher : Class
burgher =
    { name = "Burgher"
    , careers =
        [ agitator
        , artisan
        , beggar
        , investigator
        , merchant
        , ratCatcher
        , townsman
        , watchman
        ]
    }


agitator : Career
agitator =
    { name = "Agitator"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


artisan : Career
artisan =
    { name = "Artisan"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


beggar : Career
beggar =
    { name = "Beggar"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


investigator : Career
investigator =
    { name = "Investigator"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


merchant : Career
merchant =
    { name = "Merchant"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


ratCatcher : Career
ratCatcher =
    { name = "Rat Catcher"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


townsman : Career
townsman =
    { name = "Townsman"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


watchman : Career
watchman =
    { name = "Watchman"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }

-------------
-- Courier --
-------------

courtier : Class
courtier =
    { name = "Courtier"
    , careers =
        [ advisor
        , artist
        , duelist
        , envoy
        , noble
        , servant
        , spy
        , warden
        ]
    }


advisor : Career
advisor =
    { name = "Advisor"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


artist : Career
artist =
    { name = "Artist"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


duelist : Career
duelist =
    { name = "Duelist"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


envoy : Career
envoy =
    { name = "Envoy"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


noble : Career
noble =
    { name = "Noble"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


servant : Career
servant =
    { name = "Servant"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


spy : Career
spy =
    { name = "Spy"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


warden : Career
warden =
    { name = "Warden"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }

-------------
-- Peasant --
-------------

peasant : Class
peasant =
    { name = "Peasant"
    , careers =
        [ bailiff
        , hedgeWitch
        , herbalist
        , hunter
        , miner
        , mystic
        , scout
        , villager
        ]
    }


bailiff : Career
bailiff =
    { name = "Bailiff"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


hedgeWitch : Career
hedgeWitch =
    { name = "Hedge Witch"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


herbalist : Career
herbalist =
    { name = "Herbalist"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


hunter : Career
hunter =
    { name = "Hunter"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


miner : Career
miner =
    { name = "Miner"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


mystic : Career
mystic =
    { name = "Mystic"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


scout : Career
scout =
    { name = "Scout"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


villager : Career
villager =
    { name = "Villager"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }

------------
-- Ranger --
------------

ranger : Class
ranger =
    { name = "Ranger"
    , careers =
        [ bountyHunter
        , coachman
        , entertainer
        , flagellant
        , messenger
        , pedlar
        , roadWarden
        , witchHunter
        ]
    }


bountyHunter : Career
bountyHunter =
    { name = "Bounty Hunter"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


coachman : Career
coachman =
    { name = "Coachman"
    , levels =
        [ { name = "Posilion"
          , status = "Silver 1"
          }
        , { name = "Coachman"
          , status = "Silver 2"
          }
        , { name = "Coach Master"
          , status = "Silver 3"
          }
        , { name = "Route Master"
          , status = "Silver 5"
          }
        ]
    }


entertainer : Career
entertainer =
    { name = "Entertainer"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


flagellant : Career
flagellant =
    { name = "Flagellant"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


messenger : Career
messenger =
    { name = "Messenger"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


pedlar : Career
pedlar =
    { name = "Pedlar"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


roadWarden : Career
roadWarden =
    { name = "Road Warden"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


witchHunter : Career
witchHunter =
    { name = "Witch Hunter"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }

---------------
-- Riverfolk --
---------------

riverfolk : Class
riverfolk =
    { name = "Riverfolk"
    , careers =
        [ boatman
        , huffer
        , riverwarden
        , riverwoman
        , seaman
        , smuggler
        , stevedore
        , wrecker
        ]
    }


boatman : Career
boatman =
    { name = "Boatman"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


huffer : Career
huffer =
    { name = "Huffer"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


riverwarden : Career
riverwarden =
    { name = "Riverwarden"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


riverwoman : Career
riverwoman =
    { name = "Riverwoman"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


seaman : Career
seaman =
    { name = "Seaman"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


smuggler : Career
smuggler =
    { name = "Smuggler"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


stevedore : Career
stevedore =
    { name = "Stevedore"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


wrecker : Career
wrecker =
    { name = "Wrecker"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }

-----------
-- Rogue --
-----------

rogue : Class
rogue =
    { name = "Rogue"
    , careers =
        [ bawd
        , charlatan
        , fence
        , graveRobber
        , outlab
        , racketeer
        , thief
        , witch
        ]
    }


bawd : Career
bawd =
    { name = "Bawd"
    , levels =
        [ { name = "Hustler"
          , status = "Brass 1"
          }
        , { name = "Bawd"
          , status = "Brass 3"
          }
        , { name = "Procurer"
          , status = "Silver 1"
          }
        , { name = "Ringleader"
          , status = "Silver 3"
          }
        ]
    }


charlatan : Career
charlatan =
    { name = "Charlatan"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


fence : Career
fence =
    { name = "Fence"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


graveRobber : Career
graveRobber =
    { name = "Grave Robber"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


outlab : Career
outlab =
    { name = "Outlab"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


racketeer : Career
racketeer =
    { name = "Racketeer"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


thief : Career
thief =
    { name = "Thief"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


witch : Career
witch =
    { name = "Witch"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }

-------------
-- Warrior --
-------------

warrior : Class
warrior =
    { name = "Warrior"
    , careers =
        [ cavalryman
        , guard
        , knight
        , pitFighter
        , protagonist
        , soldier
        , slayer
        , warriorPriest
        ]
    }


cavalryman : Career
cavalryman =
    { name = "Cavalryman"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


guard : Career
guard =
    { name = "Guard"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


knight : Career
knight =
    { name = "Knight"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


pitFighter : Career
pitFighter =
    { name = "Pit Fighter"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


protagonist : Career
protagonist =
    { name = "Protagonist"
    , levels =
        [ { name = "Braggart"
          , status = "Brass 2"
          }
        , { name = "Protagonist"
          , status = "Silver 1"
          }
        , { name = "Hitman"
          , status = "Silver 4"
          }
        , { name = "Assassin"
          , status = "Gold 1"
          }
        ]
    }


soldier : Career
soldier =
    { name = "Soldier"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


slayer : Career
slayer =
    { name = "Slayer"
    , levels =
        [ { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        , { name = ""
          , status = ""
          }
        ]
    }


warriorPriest : Career
warriorPriest =
    { name = "Warrior Priest"
    , levels =
        [ { name = "Novitiate"
          , status = "Brass 2"
          }
        , { name = "Warrior Priest"
          , status = "Silver 2"
          }
        , { name = "Priest Sergeant"
          , status = "Silver 3"
          }
        , { name = "Priest Captain"
          , status = "Silver 4"
          }
        ]
    }

-------------
-- Talents --
-------------

talents : List String
talents =
    [ "Accurate Shot"
    , "Acute Sense (Sense)"
    , "Aethyric Attunement"
    , "Alley Cat"
    , "Ambidextrous"
    , "Animal Affinity"
    , "Arcane Magic (Lore)"
    , "Argumentative"
    , "Artistic"
    , "Attractive"
    , "Battle Rage"
    , "Beat Blae"
    , "Beneath Notice"
    , "Berserk Charge"
    , "Blather"
    , "Bless (Divine Lore)"
    , "Bookish"
    , "Break and Enter"
    , "Briber"
    , "Cardsharp"
    , "Careful Strike"
    , "Carouser"
    , "Catfall"
    , "Cat-tongued"
    , "Chaos Magic (Lore)"
    , "Combat Aware"
    , "Combat Master"
    , "Combat Reflexes"
    , "Commanding Presence"
    , "Concoct"
    , "Contortionist"
    , "Coolheaded"
    , "Crack the Whip"
    , "Craftsman (Trade)"
    , "Criminal"
    , "Deadeye Shot"
    , "Dealmaker"
    , "Detect Artefact"
    , "Diceman"
    , "Dirty Fighting"
    , "Disarm"
    , "Distract"
    , "Doomed"
    , "Drilled"
    , "Dual Wielder"
    , "Embezzle"
    , "Enclosed Fighter"
    , "Etiquette (Social Group)"
    , "Fast Hands"
    , "Fast Shot"
    , "Fearless (Enemy)"
    , "Feint"
    , "Field Dressing"
    , "Fisherman"
    , "Flagellant"
    , "Flee!"
    , "Fleet Footed"
    , "Frenzy"
    , "Frightening"
    , "Furtious Assault"
    , "Gregarious"
    , "Gunner"
    , "Hardy"
    , "Hatred (Group)"
    , "Holy Hatred"
    , "Holy Visions"
    , "Hunter's Eye"
    , "Impassioned Zeal"
    , "Implacable"
    , "In-fighter"
    , "Inspiring"
    , "Instinctive Diction"
    , "Invoke (Divine Lore)"
    , "Iron Jaw"
    , "Iron Will"
    , "Jump Up"
    , "Kingpin"
    , "Lightning Reflexes"
    , "Linguistics"
    , "Lip Reading"
    , "Luck"
    , "Magical Sense"
    , "Magic Resistance"
    , "Magnum Opus"
    , "Marksman"
    , "Master of Disguise"
    , "Master Orator"
    , "Master Tradesman (Trade)"
    , "Menacing"
    , "Mimic"
    , "Night Vision"
    , "Nimble Fingered"
    , "Noble Blood"
    , "Nose for Trouble"
    , "Numismatics"
    , "Old Salt"
    , "Orientation"
    , "Panhandle"
    , "Perfect Pitch"
    , "Petty Magic"
    , "Pharmacist"
    , "Pilot"
    , "Public Speaker"
    , "Pure Soul"
    , "Rapid Reload"
    , "Reaction Strike"
    , "Read/Write"
    , "Relentless"
    , "Resistance (Threat)"
    , "Resolute"
    , "Reversal"
    , "Riposte"
    , "River Guide"
    , "Robust"
    , "Roughrider"
    , "Rover"
    , "Savant (Lore)"
    , "Savvy"
    , "Scale Sheer Surface"
    , "Schemer"
    , "Sea Legs"
    , "Seasoned Traveller"
    , "Second Sight"
    , "Secret Identity"
    , "Shadow"
    , "Sharp"
    , "Sharpshooter"
    , "Shieldman"
    , "Sixth Sense"
    , "Slayer"
    , "Small"
    , "Sniper"
    , "Speedreader"
    , "Sprinter"
    , "Step Aside"
    , "Stone Soup"
    , "Stout-hearted"
    , "Strider (Terrain)"
    , "Strike Mighty Blow"
    , "Strike to Injure"
    , "Strike to Stun"
    , "Strong Back"
    , "Strong Legs"
    , "Strong-minded"
    , "Strong Swimmer"
    , "Sturdy"
    , "Suave"
    , "Super Numerate"
    , "Supportive"
    , "Sure Shot"
    , "Surgery"
    , "Tenacious"
    , "Tinker"
    , "Tower of Memories"
    , "Trapper"
    , "Trick Riding"
    , "Tunnel Rat"
    , "Unshakable"
    , "Very Resilient"
    , "Very Strong"
    , "War Leader"
    , "War Wizard"
    , "Warrior Born"
    , "Waterman"
    , "Wealthy"
    , "Well-prepared"
    , "Witch!"
    ]
