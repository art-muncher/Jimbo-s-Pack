local table ={
    descriptions = {
        jimb_curses = {

            
            hook_curse = {
                name = "Hasp",
                text = {
                    "{C:attention}First hand{} of {C:attention}round", 'has {C:attention}#1# handsize'
                }
            },
            hook_pure = {
                name = "Hasp Purified",
                text = {
                    "{C:attention}First hand{} of {C:attention}round", 'has {C:attention}+#1# handsize'
                }
            },


            wall_curse = {
                name = "Tower",
                text = {
                    "{X:purple,C:white}X#1#{} blind size",
                    'on {C:attention}Boss Blinds'
                }
            },
            wall_pure = {
                name = "Tower Purified",
                text = {
                    "{X:purple,C:white}X#1#{} blind size",
                    'on {C:attention}Boss Blinds'
                }
            },

            arm_curse = {
                name = "Vein",
                text = {
                    "{C:attention}Final possible hand{} played", "is {C:red}downgraded"
                }
            },
            arm_pure = {
                name = "Vein Purified",
                text = {
                    "{C:attention}Final possible hand{} played", "is {C:attention}upgraded",
                }
            },

            --idfk what to do for psychic

            water_curse = {
                name = "Flood",
                text = {
                    "{C:red}#1#{} Discards",
                }
            },
            water_pure = {
                name = "Flood Purified",
                text = {
                    "{C:red}+#1#{} Discards",
                }
            },

            --eye and mouth
            --plant

            needle_curse = {
                name = "Thread",
                text = {
                    "{C:blue}#1#{} Hands"
                }
            },
            needle_pure = {
                name = "Thread Purified",
                text = {
                    "{C:blue}+#1#{} Hands"
                }
            },

            tooth_curse = {
                name = "Cavity",
                text = {
                    "Fifth card played","gives {C:money}#1#$"
                }
            },
            tooth_pure = {
                name = "Cavity Purified",
                text = {
                    "Last card played", "gives {C:money}+#1#$",
                }
            },

            oxen_curse = {
                name = "Oxen",
                text = {
                    "Playing {C:attention}most played hand{}", "gives {C:money}#1#${}"
                }
            },
            oxen_pure = {
                name = "Oxen Purified",
                text = {
                    "Playing {C:attention}most played hand{}", "gives {C:money}#1#${}",
                }
            },

            manacle_curse = {
                name = "Shackle",
                text = {
                    "{C:attention}Hand size{} cannot go", 'over {C:attention}#1#'
                }
            },
            manacle_pure = {
                name = "Shackle Purified",
                text = {
                    "{C:attention}Hand size{} cannot go", 'under {C:attention}#1#'
                }
            },

            zone_curse = {
                name = "Totem",
                text = {
                    "{C:green}#2# in #3#{} chance for", "cards have {X:dark_edition,C:white}X#1#{}", 'to all values'
                }
            },
            zone_pure = {
                name = "Totem Purified",
                text = {
                    "{C:green}#2# in #3#{} chance for", 'cards to have {X:dark_edition,C:white}X#1#{}','to all values'
                }
            },


            goad_curse = {
                name = "Fuchsia",
                text = {
                    "{C:spades}Spades{} cards {C:attention}dont count","{C:attention}as Spades",
                }
            },
            goad_pure = {
                name = "Fuchsia Purified",
                text = {
                    "{C:spades}Spades{} cards act like",'{C:dark_edition}Negative{} cards'
                }
            },


            head_curse = {
                name = "Begonia",
                text = {
                    "{C:hearts}Heart{} cards held in hand",'give {X:mult,C:white}X#1#{} when held',
                }
            },
            head_pure = {
                name = "Begonia Purified",
                text = {
                    "{C:hearts}Heart{} cards held in hand",'give {X:mult,C:white}X#1#{} when held',
                }
            },


            club_curse = {
                name = "Chrysanthemums",
                text = {
                    "This card loses {C:chips}+#1#{} Chips", 
                    'when a {C:clubs}Club{} card is scored',
                    '{C:inactive}(Currently {C:chips}#2#{} {C:inactive} Chips)'
                }
            },
            club_pure = {
                name = "Chrysanthemums Purified",
                text = {
                    "This card gains {C:chips}+#1#{} Chips", 
                    'when a {C:clubs}Club{} card is scored',
                    '{C:inactive}(Currently {C:chips}#2#{} {C:inactive} Chips)'
                }
            },

            window_curse = {
                name = "Tulipa",
                text = {
                    "Lose {C:money}#1#${} when a", "{C:diamonds}Diamonds{} card is discarded"
                }
            },
            window_pure = {
                name = "Tulipa Purified",
                text = {
                    "Gain {C:money}#1#${} when a", "{C:diamonds}Diamonds{} card is discarded"
                }
            },




            leaf_curse = {
                name = "Garden",
                text = {
                    "{C:attention}#1#{} random cards are",
                    "{C:attention}debuffed{} on every Hand unless", 
                    "a {C:attention}Joker{} has been",
                    '{C:attention}sold{} this {C:attention}Ante',
                }
            },
            leaf_pure = {
                name = "Garden Purified",
                text = {
                    "+#1# handsize if a {C:attention}Joker",
                    "has been {C:attention}sold{} this {C:attention}Ante",
                }
            },

            vessel_curse = {
                name = "Husk",
                text = {
                    "This card gains {X:purple,C:white}X#1#{} blind size",
                    'when {C:attention}Boss Blind{} is defeated',
                    '{C:inactive}(Currently{} {X:purple,C:white}X#2#{} {C:inactive}blind size)'
                }
            },
            vessel_pure = {
                name = "Husk Purified",
                text = {
                    "This card loses {X:purple,C:white}#1#%{} blind size",
                    'when {C:attention}Boss Blind{} is defeated',
                    '{C:inactive}(Currently{} {X:purple,C:white}X#2#{} {C:inactive}blind size)'
                }
            },

            acorn_curse = {
                name = "Kernel",
                text = {
                    "{C:attention}Flips and shuffles",
                    "all {C:attention}Joker{} cards",
                    'on {C:attention}first hand'
                }
            },
            acorn_pure = {
                name = "Kernel Purified",
                text = {
                    "???",
                }
            },

            heart_curse = {
                name = "Soul",
                text = {
                    "One random {C:attention}Joker",
                    "disabled every {C:attention}odd{} hand"
                }
            },
            heart_pure = {
                name = "Soul Purified",
                text = {
                    "Cards cannot be",
                    'debuffed on',
                    '{C:attention}odd hands'
                }
            },

            bell_curse = {
                name = "Carillon",
                text = {
                    "Forces 1 card to",
                    "always be selected",
                    'on {C:attention}Boss Blinds'
                }
            },
            bell_pure = {
                name = "Carillon Purified",
                text = {
                    "A random card becomes",
                    '{C:dark_edition}Negative{} at the',
                    'start of a blind'
                }
            },


            hand_pure = {
                name = "Ring",
                text = {
                    "{X:purple,C:white}X#1#{} Blind requirement",
                    'for every {C:attention}Hand{} you have'
                }
            },
            hand_curse = {
                name = "Ring Purified",
                text = {
                    "{X:purple,C:white}X#1#{} Blind requirement",
                    'for every {C:attention}Hand{} you have'
                }
            },

            vanilla_curse = {
                name = "Extract",
                text = {
                    "{C:legendary}Modded Jokers{} give",
                    '{X:mult,C:white}X#1#{} Mult'
                }
            },
            vanilla_pure = {
                name = "Extract Purified",
                text = {
                    "{C:legendary}Modded Jokers{} give",
                    '{X:mult,C:white}X#1#{} Mult'
                }
            },

            luck_curse = {
                name = "Blessing",
                text = {
                    "#1# in #2# chance for",
                    'cards to give {X:mult,C:white}#3#{} Mult'
                }
            },
            luck_pure = {
                name = "Blessing Purified",
                text = {
                    "#1# in #2# chance for",
                    'cards to give {X:mult,C:white}#3#{} Mult'
                }
            },

            cerberus_curse = {
                name = "Hound",
                text = {
                    "{X:purple,C:white}X#1#{} blind size",
                    "{C:attention}Duplicate{} this card when",
                    'defeating a {C:attention}Boss Blind{}'
                }
            },
            cerberus_pure = {
                name = "Hound Purified",
                text = {
                    "{X:purple,C:white}X#1#{} blind size",
                    "{C:attention}Duplicate{} this card when",
                    'defeating a {C:attention}Boss Blind{}'
                }
            },

            rainfall_curse = {
                name = 'Tears',
                text = {
                    "{C:red}Debuff{} a random card in",
                    'hand after playing a hand'
                }
            },
            rainfall_pure = {
                name = 'Tears Purified',
                text = {
                    "???"
                }
            },

            tax_curse = {
                name = 'Tax Form',
                text = {
                    "{X:mult,C:white}X#1#{} Mult if",
                    'hand scores over {C:attention}#2#%',
                    'blind requirement'
                }
            },
            tax_pure = {
                name = 'Tax Form Filed',
                text = {
                    "{X:mult,C:white}X#1#{} Mult if",
                    'hand scores under {C:attention}#2#%',
                    'blind requirement'
                }
            },
        },
        summon_blind = {
            bl_small = {
                name = "Small Blind?",
                text = {}
            },
            bl_big = {
                name = "Big Blind?",
                text = {}
            },
            bl_hook = {
                name = "The Hook?",
                text = {
                    'Debuffs 2 random',
                    'cards per hand played',
                } 
            },
            bl_wall = {
                name = "The Wall?",
                text = {
                    "Extra large blind, increase",
                    'blind size by +0.25X every hand'
                }
            },
            bl_wheel = {
                name = "The Wheel?",
                text = {
                    " in 2 Jokers get flipped,",
                    "all Jokers are shuffled"
                }
            },
            bl_arm = {
                name = "The Arm?",
                text = {
                    "Decrease level of",
                    "most played poker hand"
                }
            },
            bl_psychic = {
                name = "The Psychic?",
                text = {
                    "Must play 5 cards,",
                    'all cards must score'
                }
            },
            bl_goad = {
                name = "The Goad?",
                text = {
                    "All Spade cards are debuffed,",
                    "spade cards can't be discarded"
                }
            },
            bl_water = {
                name = "The Water?",
                text = {
                    "Start with 0 discards,",
                    "1 in 8 chance for drawn",
                    'cards to be discarded'
                }
            },
            --[[bl_eye = {
                name = "The Eye?",
                text = {
                    "You can repeat",
                    "hand types only",
                    '2 times this Ante'
                }--too lazy to finish
            },
            bl_mouth = {
                name = "The Mouth?",
                text = {
                    "Play only 1 hand",
                    "type this round,",
                    'cannot play most',
                    'played poker hand',
                }--too lazy to finish
            },]]
            bl_plant = {
                name = "The Plant?",
                text = {
                    'Face cards are debuffed',
                    'Face cards cannot be discarded'
                }
            },
            bl_needle = {
                name = "The Needle?",
                text = {
                    "Play only 1 hand",
                    '+1X Base blind size'
                }
            },
            bl_head = {
                name = "The Head?",
                text = {
                    "All Heart cards are debuffed",
                    "Heart cards left in hand give",
                    'X0.75 Mult'
                }
            },
            bl_tooth = {
                name = "The Tooth?",
                text = {
                    "Lose $1 per",
                    "card drawn"
                }
            },
            --[[bl_final_leaf = {
                name = "Jade Garden",
                text = {
                    "All cards debuffed",
                    "until specific Joker",
                    'is sold',
                    '(They are jiggling)'
                }
            },
            bl_final_vessel = {
                name = "Lavender Husk",
                text = {
                    "Very large blind",
                    'X1.25 blind size when',
                    'hand is played'
                }
            },]]
            bl_ox = {
                name = "The Ox?",
                text = {
                    "Playing a #1#",
                    "sets $ to the negative",
                    'of current $',
                }
            },
            bl_house = {
                name = "The House?",
                text = {
                    "First hand is",
                    "flipped and", 
                    "debuffed"
                }
            },
            bl_club = {
                name = "The Club?",
                text = {
                    "All Club cards",
                    "are debuffed this Ante"
                }
            },
            bl_fish = {
                name = "The Fish?",
                text = {
                    "Cards are drawn debuffed",
                    "after each hand played" --idfk how
                }
            },
            bl_window = {
                name = "The Window?",
                text = {
                    "All Diamond cards",
                    "are debuffed and flip",
                    'a random card when drawn'
                }
            },
            bl_manacle = {
                name = "The Manacle?",
                text = {
                    "-1 Hand Size",
                    'every hand'
                }
            },
            --[[bl_serpent = {
                name = "The Serpent",
                text = {
                    "After Play or Discard,",
                    "always draw 3 cards"
                }
            },]]
            bl_pillar = {
                name = "The Pillar?",
                text = {
                    "Cards played previously this Ante",
                    "are debuffed, ranks previously",
                    'played last hand are debuffed'
                }
            },
            bl_flint = {
                name = "The Flint?",
                text = {
                    "Base Chips and",
                    "Mult are halved twice"
                }
            },
            bl_mark = {
                name = "The Mark?",
                text = {
                    "All cards with a rank",
                    "higher than 6 are",
                    "drawn face down"
                }
            },
            --[[bl_final_acorn = {
                name = "Ochre Kernel",
                text = {
                    "Flips and shuffles",
                    "all Joker cards",
                    'every hand'
                }
            },
            bl_final_heart = {
                name = "Cardinal Soul",
                text = {
                    "One random Joker",
                    "cannot triggered",
                    'if triggered, disallow',
                    'hand'
                }
            },
            bl_final_bell = {
                name = "Azure Chime",
                text = {
                    "Forces 1 card",
                    'to be selected'
                    "Forced card cannot", 
                    "score in a hand"
                }
            }]]


            bl_jimb_zone = {
                name = "The Zone?",
                text = {
                    'Cards created this Ante',
                    'spawn with Deteriorating and',
                    'Perishable Stickers'
                }
            },
        },
    },
    misc = {
        dictionary = {

        },
        quips = {
            ['default'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}...",},

            ['jimbo_menu1'] = {"{s:1.5}Let's get this", '{s:1.5}Joker Poker started!'},
            ['jimbo_menu2'] = {"{s:1.5}Do you like my", "{s:1.5}newest additions?",},
            ['jimbo_menu3'] = {"{s:1.5}Find all the Jokers!",},
            ['jimbo_menu4'] = {"{s:1.5}There's a scary card hiding", '{s:1.5}in your collection...'},
            ['jimbo_menu5'] = {"{s:1.5}Are you new here?",},
            ['jimbo_menu6'] = {"{s:1.5}What are you standing", '{s:1.5}here for? Start a run!'},
            ['jimbo_menu7'] = {"{s:1.5}You should watch", '{s:1.5}my videos!'},
            ['jimbo_menu8'] = {"{s:1.5}https://www.youtube.com/watch?v=xvFZjo5PgG0", },

            ['Small Blind Red Deck1'] = {"{C:blue,E:1.5,S:1.5,s:1.5}Hehehe!",},
            ['Small Blind Red Deck2'] = {"{C:blue,E:1.5,S:1.5,s:1.5}Nyahaha...",},
            ['Small Blind Red Deck3'] = {"{C:blue,E:1.5,S:1.5,s:1.5}Hahaha!"},
            ['Small Blind Red Deck_disable1'] = {"{C:blue,E:1.5,S:1.5,s:1.5}?",},
            ['Small Blind Red Deck_disable2'] = {"{C:blue,E:1.5,S:1.5,s:1.5}?",},
            ['Small Blind Red Deck_disable3'] = {"{C:blue,E:1.5,S:1.5,s:1.5}?",},
            ['Small Blind Red Deck_defeat1'] = {"{C:blue,E:1.5,S:1.5,s:1.5}Nnngh...",},
            ['Small Blind Red Deck_defeat2'] = {"{C:blue,E:1.5,S:1.5,s:1.5}Aaghhh!!!",},

            ['Big Blind Red Deck1'] = {"{C:attention,E:1.5,S:1.5,s:1.5}Hehehe!",},
            ['Big Blind Red Deck2'] = {"{C:attention,E:1.5,S:1.5,s:1.5}Nyahaha...",},
            ['Big Blind Red Deck3'] = {"{C:attention,E:1.5,S:1.5,s:1.5}Hahaha!"},
            ['Big Blind Red Deck_disable1'] = {"{C:attention,E:1.5,S:1.5,s:1.5}?",},
            ['Big Blind Red Deck_disable2'] = {"{C:attention,E:1.5,S:1.5,s:1.5}?",},
            ['Big Blind Red Deck_disable3'] = {"{C:attention,E:1.5,S:1.5,s:1.5}?",},
            ['Big Blind Red Deck_defeat1'] = {"{C:attention,E:1.5,S:1.5,s:1.5}Nnngh...",},
            ['Big Blind Red Deck_defeat2'] = {"{C:attention,E:1.5,S:1.5,s:1.5}Aaghhh!!!",},



            ['The Plant Red Deck1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Why, hello again.",},
            ['The Plant Red Deck2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Nice day, isn't it?",},
            ['The Plant Red Deck3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Are you scared?", "{C:legendary,E:1.5,S:1.5,s:1.5}You can always hug me!"},
            ['The Plant Red Deck_disable1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}..You...",},
            ['The Plant Red Deck_disable2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Why would you..",},
            ['The Plant Red Deck_disable3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}How could you..",},
            ['The Plant Red Deck_defeat1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Good luck!",},
            ['The Plant Red Deck_defeat2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}See you soon!",},

            ['The Hook Red Deck1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}I'll get you this time...",},
            ['The Hook Red Deck2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}You again!",},
            ['The Hook Red Deck3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}The next time,", "{C:legendary,E:1.5,S:1.5,s:1.5}I swear..."},
            ['The Hook Red Deck_disable1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}..You..",},
            ['The Hook Red Deck_disable2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Coward...",},
            ['The Hook Red Deck_disable3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Runner..",},
            ['The Hook Red Deck_defeat1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}This won't be the last time...",},
            ['The Hook Red Deck_defeat2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Argh...",},

            ['The Wheel Red Deck1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}BACK FOR MORE?!?",},
            ['The Wheel Red Deck2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}WE'LL NEVER STOP!",},
            ['The Wheel Red Deck3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}AHAHAHA!!", "{C:legendary,E:1.5,S:1.5,s:1.5}CAN'T STOP NOW!!"},
            ['The Wheel Red Deck_disable1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}.",},
            ['The Wheel Red Deck_disable2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}-",},
            ['The Wheel Red Deck_disable3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}.",},
            ['The Wheel Red Deck_defeat1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}STOP IT, STOP IT!!",},
            ['The Wheel Red Deck_defeat2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}GAMBLE GAMBLE GAMBLE",},

            ['The Psychic Red Deck1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}I don't foresee this going well.",},
            ['The Psychic Red Deck2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}This is pointless.",},
            ['The Psychic Red Deck3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}You'll just never stop,", "{C:legendary,E:1.5,S:1.5,s:1.5}won't you?"},
            ['The Psychic Red Deck_disable1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}My head hurts...",},
            ['The Psychic Red Deck_disable2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Where am I?",},
            ['The Psychic Red Deck_disable3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Who are you?",},
            ['The Psychic Red Deck_defeat1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Goodbye...",},
            ['The Psychic Red Deck_defeat2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Hmph...",},

            ['The Water Red Deck1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}I'm sorry...",},
            ['The Water Red Deck2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}We can't stop...",},
            ['The Water Red Deck3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Why?", "{C:legendary,E:2.5,S:1.5,s:1.5}WHY!?"},
            ['The Water Red Deck_disable1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}It's okay...",},
            ['The Water Red Deck_disable2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}I forgive you...",},
            ['The Water Red Deck_disable3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}It's fine...",},
            ['The Water Red Deck_defeat1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Goodbye...",},
            ['The Water Red Deck_defeat2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}...",},

            ['The House Red Deck1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Eugh... You again.",},
            ['The House Red Deck2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Can't you stop coming here?",},
            ['The House Red Deck3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Get out of my sight,", "{C:legendary,E:1.5,S:1.5,s:1.5}you pest."},
            ['The House Red Deck_disable1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}For someone like you,",'{C:legendary,E:1.5,S:1.5,s:1.5}impressive.'},
            ['The House Red Deck_disable2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}To think you", '{C:legendary,E:1.5,S:1.5,s:1.5}would do that...'},
            ['The House Red Deck_disable3'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Not bad.",},
            ['The House Red Deck_defeat1'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Never come back.",},
            ['The House Red Deck_defeat2'] = {"{C:legendary,E:1.5,S:1.5,s:1.5}Don't come near me.",},
        }
    }
}
table.descriptions.Other = table.descriptions.jimb_curses



return table
