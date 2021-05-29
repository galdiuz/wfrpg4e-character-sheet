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
        [ { name = "Pamphleteer"
          , status = "Brass 1"
          }
        , { name = "Agitator"
          , status = "Brass 2"
          }
        , { name = "Rabble Rouser"
          , status = "Brass 3"
          }
        , { name = "Demagogue"
          , status = "Brass 5"
          }
        ]
    }


artisan : Career
artisan =
    { name = "Artisan"
    , levels =
        [ { name = "Apprentice Artisan"
          , status = "Brass 2"
          }
        , { name = "Artisan"
          , status = "Silver 1"
          }
        , { name = "Master Artisan"
          , status = "Silver 3"
          }
        , { name = "Guildmaster"
          , status = "Gold 1"
          }
        ]
    }


beggar : Career
beggar =
    { name = "Beggar"
    , levels =
        [ { name = "Pauper"
          , status = "Brass 0"
          }
        , { name = "Beggar"
          , status = "Brass 2"
          }
        , { name = "Master Beggar"
          , status = "Brass 4"
          }
        , { name = "Beggar King"
          , status = "Silver 2"
          }
        ]
    }


investigator : Career
investigator =
    { name = "Investigator"
    , levels =
        [ { name = "Sleuth"
          , status = "Silver 1"
          }
        , { name = "Investigator"
          , status = "Silver 2"
          }
        , { name = "Master Investigator"
          , status = "Silver 3"
          }
        , { name = "Detective"
          , status = "Silver 5"
          }
        ]
    }


merchant : Career
merchant =
    { name = "Merchant"
    , levels =
        [ { name = "Trader"
          , status = "Silver 2"
          }
        , { name = "Merchant"
          , status = "Silver 5"
          }
        , { name = "Master Merchant"
          , status = "Gold 1"
          }
        , { name = "Merchant Prince"
          , status = "Gold 3"
          }
        ]
    }


ratCatcher : Career
ratCatcher =
    { name = "Rat Catcher"
    , levels =
        [ { name = "Rat Hunter"
          , status = "Brass 3"
          }
        , { name = "Rat Catcher"
          , status = "Silver 1"
          }
        , { name = "Sewer Jack"
          , status = "Silver 2"
          }
        , { name = "Exterminator"
          , status = "Silver 3"
          }
        ]
    }


townsman : Career
townsman =
    { name = "Townsman"
    , levels =
        [ { name = "Clerk"
          , status = "Silver 1"
          }
        , { name = "Townsman"
          , status = "Silver 2"
          }
        , { name = "Town Councillor"
          , status = "Silver 5"
          }
        , { name = "Burgomeister"
          , status = "Gold 1"
          }
        ]
    }


watchman : Career
watchman =
    { name = "Watchman"
    , levels =
        [ { name = "Watch Recruit"
          , status = "Brass 3"
          }
        , { name = "Watchman"
          , status = "Silver 1"
          }
        , { name = "Watch Sergeant"
          , status = "Silver 3"
          }
        , { name = "Watch Captain"
          , status = "Gold 1"
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
        [ { name = "Aide"
          , status = "Silver 2"
          }
        , { name = "Advisor"
          , status = "Silver 4"
          }
        , { name = "Counsellor"
          , status = "Gold 1"
          }
        , { name = "Chancellor"
          , status = "Gold 3"
          }
        ]
    }


artist : Career
artist =
    { name = "Artist"
    , levels =
        [ { name = "Apprentice Artist"
          , status = "Silver 1"
          }
        , { name = "Artist"
          , status = "Silver 3"
          }
        , { name = "Master Artist"
          , status = "Silver 5"
          }
        , { name = "Maestro"
          , status = "Gold 2"
          }
        ]
    }


duelist : Career
duelist =
    { name = "Duelist"
    , levels =
        [ { name = "Fencer"
          , status = "Silver 3"
          }
        , { name = "Duelist"
          , status = "Silver 5"
          }
        , { name = "Duelmaster"
          , status = "Gold 1"
          }
        , { name = "Judical Champion"
          , status = "Gold 3"
          }
        ]
    }


envoy : Career
envoy =
    { name = "Envoy"
    , levels =
        [ { name = "Herald"
          , status = "Silver 2"
          }
        , { name = "Envoy"
          , status = "Silver 4"
          }
        , { name = "Diplomat"
          , status = "Gold 2"
          }
        , { name = "Ambassador"
          , status = "Gold 5"
          }
        ]
    }


noble : Career
noble =
    { name = "Noble"
    , levels =
        [ { name = "Scion"
          , status = "Gold 1"
          }
        , { name = "Noble"
          , status = "Gold 3"
          }
        , { name = "Magnate"
          , status = "Gold 5"
          }
        , { name = "Noble Lord"
          , status = "Gold 7"
          }
        ]
    }


servant : Career
servant =
    { name = "Servant"
    , levels =
        [ { name = "Menial"
          , status = "Silver 1"
          }
        , { name = "Servant"
          , status = "Silver 3"
          }
        , { name = "Attendant"
          , status = "Silver 5"
          }
        , { name = "Steward"
          , status = "Gold 1"
          }
        ]
    }


spy : Career
spy =
    { name = "Spy"
    , levels =
        [ { name = "Informer"
          , status = "Brass 3"
          }
        , { name = "Spy"
          , status = "Silver 3"
          }
        , { name = "Agent"
          , status = "Gold 1"
          }
        , { name = "Spymaster"
          , status = "Gold 4"
          }
        ]
    }


warden : Career
warden =
    { name = "Warden"
    , levels =
        [ { name = "Custodian"
          , status = "Silver 1"
          }
        , { name = "Warden"
          , status = "Silver 3"
          }
        , { name = "Seneschal"
          , status = "Gold 1"
          }
        , { name = "Governor"
          , status = "Gold 3"
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
        [ { name = "Tax Collector"
          , status = "Solver 1"
          }
        , { name = "Bailiff"
          , status = "Silver 5"
          }
        , { name = "Reeve"
          , status = "Gold 1"
          }
        , { name = "Magistrate"
          , status = "Gold 3"
          }
        ]
    }


hedgeWitch : Career
hedgeWitch =
    { name = "Hedge Witch"
    , levels =
        [ { name = "Hedge Apprentice"
          , status = "Brass 1"
          }
        , { name = "Hedge Witch"
          , status = "Brass 2"
          }
        , { name = "Hedge Master"
          , status = "Brass 3"
          }
        , { name = "Hedgewise"
          , status = "Brass 5"
          }
        ]
    }


herbalist : Career
herbalist =
    { name = "Herbalist"
    , levels =
        [ { name = "Herb Gatherer"
          , status = "Brass 2"
          }
        , { name = "Herbalist"
          , status = "Brass 4"
          }
        , { name = "Herb Master"
          , status = "Silver 1"
          }
        , { name = "Herbwise"
          , status = "Silver 3"
          }
        ]
    }


hunter : Career
hunter =
    { name = "Hunter"
    , levels =
        [ { name = "Trapper"
          , status = "Brass 2"
          }
        , { name = "Hunter"
          , status = "Brass 4"
          }
        , { name = "Tracker"
          , status = "Silver 1"
          }
        , { name = "Huntsmaster"
          , status = "Silver 3"
          }
        ]
    }


miner : Career
miner =
    { name = "Miner"
    , levels =
        [ { name = "Prospector"
          , status = "Brass 2"
          }
        , { name = "Miner"
          , status = "Brass 4"
          }
        , { name = "Master Miner"
          , status = "Brass 5"
          }
        , { name = "Mine Foreman"
          , status = "Silver 4"
          }
        ]
    }


mystic : Career
mystic =
    { name = "Mystic"
    , levels =
        [ { name = "Fortune Teller"
          , status = "Brass 1"
          }
        , { name = "Mystic"
          , status = "Brass 2"
          }
        , { name = "Sage"
          , status = "Brass 3"
          }
        , { name = "Seer"
          , status = "Brass 4"
          }
        ]
    }


scout : Career
scout =
    { name = "Scout"
    , levels =
        [ { name = "Guide"
          , status = "Brass 3"
          }
        , { name = "Scout"
          , status = "Brass 5"
          }
        , { name = "Pathfinder"
          , status = "Silver 1"
          }
        , { name = "Explorer"
          , status = "Silver 5"
          }
        ]
    }


villager : Career
villager =
    { name = "Villager"
    , levels =
        [ { name = "Peasant"
          , status = "Brass 2"
          }
        , { name = "Villager"
          , status = "Brass 3"
          }
        , { name = "Councillor"
          , status = "Brass 4"
          }
        , { name = "Village Elder"
          , status = "Silver 2"
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
        [ { name = "Thief-taker"
          , status = "Silver 1"
          }
        , { name = "Bounty Hunter"
          , status = "Silver 3"
          }
        , { name = "Master Bounty Hunter"
          , status = "Silver 5"
          }
        , { name = "Bounty Hunter General"
          , status = "Gold 1"
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
        [ { name = "Busker"
          , status = "Brass 3"
          }
        , { name = "Entertainer"
          , status = "Brass 5"
          }
        , { name = "Troubadour"
          , status = "Silver 3"
          }
        , { name = "Troupe Leader"
          , status = "Gold 1"
          }
        ]
    }


flagellant : Career
flagellant =
    { name = "Flagellant"
    , levels =
        [ { name = "Zealot"
          , status = "Brass 0"
          }
        , { name = "Flagellant"
          , status = "Brass 0"
          }
        , { name = "Penitent"
          , status = "Brass 0"
          }
        , { name = "Prophet of Doom"
          , status = "Brass 0"
          }
        ]
    }


messenger : Career
messenger =
    { name = "Messenger"
    , levels =
        [ { name = "Runner"
          , status = "Brass 3"
          }
        , { name = "Messenger"
          , status = "Silver 1"
          }
        , { name = "Courier"
          , status = "Silver 3"
          }
        , { name = "Courier-Captain"
          , status = "Silver 5"
          }
        ]
    }


pedlar : Career
pedlar =
    { name = "Pedlar"
    , levels =
        [ { name = "Vagabond"
          , status = "Brass 1"
          }
        , { name = "Pedlar"
          , status = "Brass 4"
          }
        , { name = "Master Pedlar"
          , status = "Silver 1"
          }
        , { name = "Wandering Trader"
          , status = "Silver 3"
          }
        ]
    }


roadWarden : Career
roadWarden =
    { name = "Road Warden"
    , levels =
        [ { name = "Toll Keeper"
          , status = "Brass 5"
          }
        , { name = "Road Warden"
          , status = "Silver 2"
          }
        , { name = "Road Sergeant"
          , status = "Silver 4"
          }
        , { name = "Road Captain"
          , status = "Gold 1"
          }
        ]
    }


witchHunter : Career
witchHunter =
    { name = "Witch Hunter"
    , levels =
        [ { name = "Interrogator"
          , status = "Silver 1"
          }
        , { name = "Witch Hunter"
          , status = "Silver 3"
          }
        , { name = "Inquisitor"
          , status = "Silver 5"
          }
        , { name = "Witchfinder General"
          , status = "Gold 1"
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
        [ { name = "Boat-hand"
          , status = "Silver 1"
          }
        , { name = "Boatman"
          , status = "Silver 2"
          }
        , { name = "Bargeswain"
          , status = "Silver 3"
          }
        , { name = "Barhe Master"
          , status = "Silver 5"
          }
        ]
    }


huffer : Career
huffer =
    { name = "Huffer"
    , levels =
        [ { name = "Riverguide"
          , status = "Brass 4"
          }
        , { name = "Huffer"
          , status = "Silver 1"
          }
        , { name = "Pilot"
          , status = "Silver 3"
          }
        , { name = "Master Pilot"
          , status = "Silver 5"
          }
        ]
    }


riverwarden : Career
riverwarden =
    { name = "Riverwarden"
    , levels =
        [ { name = "River Recruit"
          , status = "Silver 1"
          }
        , { name = "Riverwarden"
          , status = "Silver 2"
          }
        , { name = "Shipsword"
          , status = "Silver 4"
          }
        , { name = "Shipsword Master"
          , status = "Gold 1"
          }
        ]
    }


riverwoman : Career
riverwoman =
    { name = "Riverwoman"
    , levels =
        [ { name = "Greenfish"
          , status = "Brass 2"
          }
        , { name = "Riverwoman"
          , status = "Brass 3"
          }
        , { name = "Riverwise"
          , status = "Brass 5"
          }
        , { name = "River Elder"
          , status = "Silver 2"
          }
        ]
    }


seaman : Career
seaman =
    { name = "Seaman"
    , levels =
        [ { name = "Landsman"
          , status = "Silver 1"
          }
        , { name = "Seaman"
          , status = "Silver 3"
          }
        , { name = "Boatswain"
          , status = "Silver 5"
          }
        , { name = "Ship's Master"
          , status = "Gold 2"
          }
        ]
    }


smuggler : Career
smuggler =
    { name = "Smuggler"
    , levels =
        [ { name = "River Runner"
          , status = "Brass 2"
          }
        , { name = "Smuggler"
          , status = "Brass 3"
          }
        , { name = "Master Smuggler"
          , status = "Brass 5"
          }
        , { name = "Smuggler King"
          , status = "Silver 2"
          }
        ]
    }


stevedore : Career
stevedore =
    { name = "Stevedore"
    , levels =
        [ { name = "Dockhand"
          , status = "Brass 3"
          }
        , { name = "Stevedore"
          , status = "Silver 1"
          }
        , { name = "Foreman"
          , status = "Silver 3"
          }
        , { name = "Dock Master"
          , status = "Silver 5"
          }
        ]
    }


wrecker : Career
wrecker =
    { name = "Wrecker"
    , levels =
        [ { name = "Cargo Scavenger"
          , status = "Brass 2"
          }
        , { name = "Wrecker"
          , status = "Brass 3"
          }
        , { name = "River Pirate"
          , status = "Brass 5"
          }
        , { name = "Wrecker Captain"
          , status = "Silver 2"
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
        [ { name = "Swindler"
          , status = "Brass 3"
          }
        , { name = "Charlatan"
          , status = "Brass 5"
          }
        , { name = "Con Artist"
          , status = "Silver 2"
          }
        , { name = "Scoundrel"
          , status = "Silver 4"
          }
        ]
    }


fence : Career
fence =
    { name = "Fence"
    , levels =
        [ { name = "Broker"
          , status = "Silver 1"
          }
        , { name = "Fence"
          , status = "Silver 2"
          }
        , { name = "Master Fence"
          , status = "Silver 3"
          }
        , { name = "Black Marketeer"
          , status = "Silver 4"
          }
        ]
    }


graveRobber : Career
graveRobber =
    { name = "Grave Robber"
    , levels =
        [ { name = "Body Snatcher"
          , status = "Brass 2"
          }
        , { name = "Grave Robber"
          , status = "Brass 3"
          }
        , { name = "Tomb Robber"
          , status = "Silver 1"
          }
        , { name = "Treasure Hunter"
          , status = "Silver 5"
          }
        ]
    }


outlab : Career
outlab =
    { name = "Outlab"
    , levels =
        [ { name = "Brigand"
          , status = "Brass 1"
          }
        , { name = "Outlaw"
          , status = "Brass 2"
          }
        , { name = "Outlaw Chief"
          , status = "Brass 4"
          }
        , { name = "Bandit King"
          , status = "Silver 2"
          }
        ]
    }


racketeer : Career
racketeer =
    { name = "Racketeer"
    , levels =
        [ { name = "Thug"
          , status = "Brass 3"
          }
        , { name = "Racketeer"
          , status = "Brass 5"
          }
        , { name = "Gang Boss"
          , status = "Silver 3"
          }
        , { name = "Crime Lord"
          , status = "Silver 5"
          }
        ]
    }


thief : Career
thief =
    { name = "Thief"
    , levels =
        [ { name = "Prowler"
          , status = "Brass 1"
          }
        , { name = "Thief"
          , status = "Brass 3"
          }
        , { name = "Master Thief"
          , status = "Brass 5"
          }
        , { name = "Cat Burglar"
          , status = "Silver 3"
          }
        ]
    }


witch : Career
witch =
    { name = "Witch"
    , levels =
        [ { name = "Hexer"
          , status = "Brass 1"
          }
        , { name = "Witch"
          , status = "Brass 2"
          }
        , { name = "Wyrd"
          , status = "Brass 3"
          }
        , { name = "Warlock"
          , status = "Brass 5"
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
        , slayer
        , soldier
        , warriorPriest
        ]
    }


cavalryman : Career
cavalryman =
    { name = "Cavalryman"
    , levels =
        [ { name = "Horseman"
          , status = "Silver 2"
          }
        , { name = "Cavalryman"
          , status = "Silver 4"
          }
        , { name = "Cavalry Sergeant"
          , status = "Gold 1"
          }
        , { name = "Cavalry Officer"
          , status = "Gold 2"
          }
        ]
    }


guard : Career
guard =
    { name = "Guard"
    , levels =
        [ { name = "Sentry"
          , status = "Silver 1"
          }
        , { name = "Guard"
          , status = "Silver 2"
          }
        , { name = "Honour Guard"
          , status = "Silver 3"
          }
        , { name = "Guard Officer"
          , status = "Silver 5"
          }
        ]
    }


knight : Career
knight =
    { name = "Knight"
    , levels =
        [ { name = "Squire"
          , status = "Silver 3"
          }
        , { name = "Knight"
          , status = "Silver 5"
          }
        , { name = "First Knight"
          , status = "Gold 2"
          }
        , { name = "Kinght of the Inner Circle"
          , status = "Gold 4"
          }
        ]
    }


pitFighter : Career
pitFighter =
    { name = "Pit Fighter"
    , levels =
        [ { name = "Purgilist"
          , status = "Brass 4"
          }
        , { name = "Pit Fighter"
          , status = "Silver 2"
          }
        , { name = "Pit Fighter"
          , status = "Silver 5"
          }
        , { name = "Pit Legend"
          , status = "Gold 2"
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


slayer : Career
slayer =
    { name = "Slayer"
    , levels =
        [ { name = "Troll Slayer"
          , status = "Brass 2"
          }
        , { name = "Giant Slayer"
          , status = "Brass 2"
          }
        , { name = "Dragon Slayer"
          , status = "Brass 2"
          }
        , { name = "Daemon Slayer"
          , status = "Brass 2"
          }
        ]
    }


soldier : Career
soldier =
    { name = "Soldier"
    , levels =
        [ { name = "Recruit"
          , status = "Silver 1"
          }
        , { name = "Soldier"
          , status = "Silver 3"
          }
        , { name = "Sergeant"
          , status = "Silver 5"
          }
        , { name = "Officer"
          , status = "Gold 1"
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
