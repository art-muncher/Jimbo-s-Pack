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
                    "{X:purple,C:white}X#1#{} blind size"
                }
            },
            wall_pure = {
                name = "Tower",
                text = {
                    "{X:purple,C:white}X#1#{} blind size"
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
                name = "Holy Water",
                text = {
                    "{C:red}#1#{} Discards",
                }
            },
            water_pure = {
                name = "Holy Water",
                text = {
                    "{C:red}+#1#{} Discards",
                }
            },

            --eye and mouth
            --plant

            needle_curse = {
                name = "Pin",
                text = {
                    "{C:blue}#1#{} Hands"
                }
            },
            needle_pure = {
                name = "Pin",
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
                    "Cards have {X:dark_edition,C:white}X#1#{}", 'to all values'
                }
            },
            zone_pure = {
                name = "Totem",
                text = {
                    "#2# in #3# chance for", 'cards to have {X:dark_edition,C:white}X#1#{}','to all values'
                }
            },


            goad_curse = {
                name = "Fuchsia",
                text = {
                    "{C:spades}Spades{} cards are {C:attention}flipped",
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
        }
    },
    misc = {
        dictionary = {

        }
    }
}