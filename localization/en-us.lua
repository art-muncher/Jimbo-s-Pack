return {
    descriptions = {
        jimb_curses = {

            
            hook_curse = {
                name = "Hasp",
                text = {
                    "{C:attention}First hand{} of {C:attention}round", 'has {C:attention}#1# handsize'
                }
            },
            hook_pure = {
                name = "Hasp",
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
                name = "Tower",
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
                name = "Vein",
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
                name = "Flood",
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
                name = "Thread",
                text = {
                    "{C:blue}-#1#{} Hands"
                }
            },

            tooth_curse = {
                name = "Cavity",
                text = {
                    "Fifth card played","gives {C:money}#1#$"
                }
            },
            tooth_pure = {
                name = "Cavity",
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
                name = "Oxen",
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
                name = "Shackle",
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
                name = "Totem",
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
                name = "Fuchsia",
                text = {
                    "{C:spades}Spades{} cards are always",'{C:dark_edition}Negative{}'
                }
            },


            head_curse = {
                name = "Begonia",
                text = {
                    "{C:hearts}Heart{} cards held in hand",'give {X:mult,C:white}X#1#{} when held',
                }
            },
            head_pure = {
                name = "Begonia",
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
                name = "Chrysanthemums",
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
                name = "Tulipa",
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
                name = "Garden",
                text = {
                    "+#1# handsize if a {C:attention}Joker",
                    "has been {C:attention}sold{} this {C:attention}Ante",
                }
            },

            vessel_curse = {
                name = "Dock",
                text = {
                    "This card gains {X:purple,C:white}X#1#{} blind size",
                    'when {C:attention}Boss Blind{} is defeated',
                    '{C:inactive}(Currently{} {X:purple,C:white}X#2#{} {C:inactive}blind size)'
                }
            },
            vessel_pure = {
                name = "Dock",
                text = {
                    "This card loses {X:purple,C:white}#1#%{} blind size",
                    'when {C:attention}Boss Blind{} is defeated',
                    '{C:inactive}(Currently{} {X:purple,C:white}X#2#{} {C:inactive}blind size)'
                }
            },

            acorn_curse = {
                name = "Tree",
                text = {
                    "{C:attention}Flips and shuffles",
                    "all {C:attention}Joker{} cards",
                    'on {C:attention}first hand'
                }
            },
            acorn_pure = {
                name = "Tree",
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
                name = "Soul",
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
                name = "Carillon",
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
                name = "Ring",
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
                name = "Extract",
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
                name = "Blessing",
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
                name = "Hound",
                text = {
                    "{X:purple,C:white}X#1#{} blind size",
                    "{C:attention}Duplicate{} this card when",
                    'defeating a {C:attention}Boss Blind{}'
                }
            },

            rainfall_curse = {
                name = 'Tears',
                text = {
                    "{C:red}Debuff{} a random card",
                    'after playing a hand'
                }
            },
            rainfall_pure = {
                name = 'Tears',
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
                name = 'Tax Form',
                text = {
                    "{X:mult,C:white}X#1#{} Mult if",
                    'hand scores under {C:attention}#2#%',
                    'blind requirement'
                }
            },
        }
    },
    misc = {
        dictionary = {

        }
    }
}
