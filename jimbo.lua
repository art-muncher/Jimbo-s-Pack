--- STEAMODDED HEADER
--- MOD_NAME: Jimbo's New Pack
--- MOD_ID: JimbosPack
--- MOD_AUTHOR: [elial1, Jimbo Himself (real)]
--- MOD_DESCRIPTION: jim bo
--- PRIORITY: 999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999



local jimbomod = SMODS.current_mod

SMODS.Atlas({key = 'Jokers', path = 'Jokers.png', px = 71, py = 95})
SMODS.Atlas({key = 'Soulj', path = 'Soulj.png', px = 71, py = 95})
SMODS.Atlas({key = 'Curse', path = 'Curses.png', px = 71, py = 95})
SMODS.Atlas({key = 'Tarot', path = 'Tarots.png', px = 71, py = 95})
SMODS.Atlas{
    key = "Mega",
    path = "Jokers2.png",
    px = 710,
    py = 1520
}
SMODS.Atlas({key = 'Vouchers', path = 'Vouchers.png', px = 71, py = 95})


if jimbomod.config.Jokers == nil then
    jimbomod.config.Jokers = true
end
if jimbomod.config.Curses == nil then
    jimbomod.config.Curses = true
end
if jimbomod.config["Boss Blinds"] == nil then
    jimbomod.config["Boss Blinds"]  = true
end
if jimbomod.config["Special Spectrals"] == nil then
    jimbomod.config["Special Spectrals"]  = true
end


local jimboTabs = function() return {
	{
		label = "Config",
		chosen = true,
		tab_definition_function = function()
			jimbo_nodes = {}
			settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }

            settings.nodes[#settings.nodes + 1] =
                create_toggle({ label = "Jokers", ref_table = jimbomod.config, ref_value = "Jokers" })
            settings.nodes[#settings.nodes + 1] =
                create_toggle({ label = "Curses", ref_table = jimbomod.config, ref_value = "Curses" })
            settings.nodes[#settings.nodes + 1] =
                create_toggle({ label = "Boss Blinds", ref_table = jimbomod.config, ref_value = "Boss Blinds" })
            settings.nodes[#settings.nodes + 1] =
                create_toggle({ label = "Special Spectrals", ref_table = jimbomod.config, ref_value = "Special Spectrals" })

			config = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { settings } }
			jimbo_nodes[#jimbo_nodes + 1] = config
			return {
				n = G.UIT.ROOT,
				config = {
					emboss = 0.05,
					minh = 6,
					r = 0.1,
					minw = 10,
					align = "cm",
					padding = 0.2,
					colour = G.C.BLACK,
				},
				nodes = jimbo_nodes,
			}
		end,
	},
} 
end
SMODS.current_mod.extra_tabs = jimboTabs



local operationfuncs = {
    function(value,mult)
        value = value * mult
        return value
    end,
    function(value,add)
        value = value + add
        return value
    end,
    function(value,div)
        value = value/div
        return value
    end,
    function(value,sub)
        value = value-sub
        return value
    end,
}




---CONGRATS ON ENTERING MY SECRET EVIL SCRIPTING LAIR........ BUT BEWARE..... THIS CODE SUCKS BALLS!!! MUAHAHAHAHAHAHAHA












--Googly Joker
local googly = SMODS.Joker{
    key = 'Googly',
    loc_txt = {
        name = "Googly Joker",
        text = {
            "Cards scored have a", "{C:green}#3# in #1#{} chance of", "being retriggered {C:attention}#2#{} times"
        }
    },
    rarity = 2,
    config = {
        extra = {
            odds = 4,
            retrigger_amt = 2
        }
    },
    pos = { x = 0, y = 0 },
    atlas = 'Jokers',
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.odds,center.ability.extra.retrigger_amt,G.GAME.probabilities.normal}}
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

googly.calculate = function(self, card, context)
    if context.repetition and context.cardarea == G.play then
        if pseudorandom('googly') < G.GAME.probabilities.normal/card.ability.extra.odds then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger_amt,
                card = card
            }
        end
    end
    
end

---Sad Lad
local sadlad = SMODS.Joker{
    key = 'sadlad',
    loc_txt = {
        name = "Sad Lad",
        text = {
            "Gives {C:chips}+#1#{} Chips when", "a card with {X:clubs,C:white}Clubs{} or", " {X:purple,C:white}Spades{} suit is scored"
        }
    },
    rarity = 1,
    config = {extra = {chips = 10}},
    pos = { x = 1, y = 0 },
    atlas = 'Jokers',
    cost = 3,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips,}}
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

sadlad.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
        if context.other_card:is_suit('Clubs') or context.other_card:is_suit('Spades') then
            return {
                chips = card.ability.extra.chips, 
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_chips',
                    vars = { card.ability.extra.chips}
                }
            }
        end
    end
end




---Clown
local clown = SMODS.Joker{
    key = 'digitalclown',
    loc_txt = {
        name = "Digital Clown",
        text = {
            "Face cards give {X:chips,C:white}X#1#{} {C:chips}chips{}", " when scored"
        }
    },
    rarity = 3,
    config = {extra = {chips = 1.2}},
    pos = { x = 2, y = 0 },
    atlas = 'Jokers',
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips}}
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}
clown.calculate = function(self, card, context)
    
    if context.individual and context.cardarea == G.play then
        if context.other_card:is_face() then
            hand_chips = hand_chips * card.ability.extra.chips
            return {
				message = "X" .. card.ability.extra.chips,
				colour = G.C.BLACK
			}
        end
    end
end



local danger = SMODS.Joker{
    key = 'sign',
    loc_txt = {
        name = "Danger Sign",
        text = {
            "{X:mult,C:white}X#1#{} Mult if no discards","have been used this round"
        },
    },
    config = {extra = {Xmult = 2}},
    rarity = 1,
    pos = {x = 1, y = 1},
    atlas = 'Jokers',
    cost = 5,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

danger.calculate = function(self, card, context)
    if context.joker_main and G.GAME.current_round.discards_used == 0 then
        return {
            card = card,
            message = localize{
                type='variable',
                key='a_xmult',
                vars={card.ability.extra.Xmult}
            },
            Xmult_mod = card.ability.extra.Xmult,
        }
    end
end

local gum = SMODS.Joker{
    key = 'gum',
    loc_txt = {
        name = "Bubble Gum",
        text = {
            "{C:mult}+#1#{} Mult, gains", "{C:mult}+#2#{} Mult every round", "Pops after {C:attention}#3# rounds{}"
        }
    },
    config = {extra = {mult = 0, mult_mod = 6, remaining = 6}},
    rarity = 1,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult,center.ability.extra.mult_mod,center.ability.extra.remaining}}
    end,
    calc_dollar_bonus = function(self, card)
        card.ability.extra.remaining = card.ability.extra.remaining - 1
        if card.ability.extra.remaining <= 0 then
            card:start_dissolve()
        end
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = { card.ability.extra.mult }
                },
            }
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}
local gelatin = SMODS.Joker{
    key = 'gelatin',
    loc_txt = {
        name = "Gelatin",
        text = {
            "This Joker gains {X:mult,C:white}X#1#{} Mult",
            "whenever a card is {C:attention}scored",
            "{C:attention}Resets{} at end of round",
            '{C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive} Mult)'
        }
    },
    config = {extra = {Xmult = 1, Xmult_mod = 0.1}},
    rarity = 1,
    pos = {x = 2, y = 2},
    atlas = 'Jokers',
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult_mod,center.ability.extra.Xmult}}
    end,
    calculate = function(self,card,context)
        if context.end_of_round then
            card.ability.extra.Xmult = 1
        end
        if context.individual and context.cardarea == G.play then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = { card.ability.extra.Xmult }
                },
            }
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}


local wine = SMODS.Joker{
    key = 'wine',
    loc_txt = {
        name = "Wine",
        text = {
            "{C:mult}+#1#{} to {C:mult}#2#{} Mult",
            "Decreases by {C:mult}#3#{}", 
            "at the end of round",
            "{C:inactive,s:0.8}Negative is equal to",
            "{C:inactive,s:0.8}half of max mult",
        }
    },
    config = {extra = {mult = 50, mult_mod = 5}},
    rarity = 1,
    pos = {x = 0, y = 3},
    atlas = 'Jokers',
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult, center.ability.extra.mult * -0.5, center.ability.extra.mult_mod}}
    end,
    calc_dollar_bonus = function(self, card)
        card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod
        if card.ability.extra.mult <= 0 then
            card:start_dissolve()
        end
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local temp_Mult = pseudorandom('wine', card.ability.extra.mult, card.ability.extra.mult * -0.5)
            return {
                mult_mod = temp_Mult,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = { card.ability.extra.mult }
                },
            }
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

local beer = SMODS.Joker{
    key = 'beer',
    loc_txt = {
        name = "Beer",
        text = {
            "When sold, the",
            "next {C:attention}Joker created{} has",
            "{X:dark_edition,C:white}X#1#{} to all values"
        }
    },
    config = {extra = {}},
    rarity = 2,
    pos = {x = 1, y = 3},
    atlas = 'Jokers',
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.cardVal or "???"}}
    end,
    calculate = function(self,card,context)
        if not card.ability.extra.cardVal then card.ability.extra.cardVal = pseudorandom("beer",5,20)/10 end
        if context.selling_self then
            G.GAME.next_Gen_Cards[#G.GAME.next_Gen_Cards+1] = {abilityMult = card.ability.extra.cardVal, specType == 'Joker'}
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}



local cardinal = SMODS.Joker{
    key = 'cardinal',
    loc_txt = {
        name = "Cardinal",
        text = {
            "Every played {C:attention}face card{}", 
            "permanently gains", 
            "{C:mult}+#1#{} Mult when scored"
        }
    },
    config = {extra = {mult_mod = 2}},
    rarity = 2,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult_mod}}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_face() then
                context.other_card.ability.mult = context.other_card.ability.mult + card.ability.extra.mult_mod or card.ability.extra.mult_mod
                return {
                    extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

local unscored = 0
local cultist = SMODS.Joker{
    key = 'cultist',
    loc_txt = {
        name = "Cultist",
        text = {
            "Destroy all {C:attention}unscoring cards{}", 
            "{C:attention}Scored{} cards gain {X:mult,C:white}X#1#{} Mult", 
            "per {C:attention}unscoring card"
        }
    },
    config = {extra = {mult_mod = 0.15}},
    rarity = 3,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult_mod}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.before then
			for k, v in pairs(context.full_hand) do
                local unscoring = true
				for _k,_v in pairs(context.scoring_hand) do
                    if v == _v then
                        unscoring = false
                    end
                end
                if unscoring == true then
                    v:start_dissolve()
                    unscored = unscored + 1
                end
			end
		end
            if context.individual and context.cardarea == G.play then
                    context.other_card.ability.x_mult = context.other_card.ability.x_mult + card.ability.extra.mult_mod*unscored or card.ability.extra.mult_mod*unscored
                    unscored = 0
                    return {
                        extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                        colour = G.C.MULT,
                        card = card
                    }
            end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}



local kunai = SMODS.Joker{
    key = 'kunai',
    loc_txt = {
        name = "Kunai",
        text = {
            "When {C:attention}Blind{} is selected,",
            "destroy {C:attention}leftmost Joker{} and gain",
            "{C:chips}+Chips{} equal to sum of all values",
            "{C:inactive}(Currently {C:chips}+#1#{} Chips{C:inactive})"

        }
    },
    config = {extra = {mult = 0}},
    rarity = 3,
    pos = {x = 2, y = 1},
    atlas = 'Jokers',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.setting_blind then
            local num = 0
            local newcard = G.jokers.cards[1]
            if newcard.ability then
                for k,v in pairs(newcard.ability) do
                    if k ~= 'x_mult' and k~= 'order' and type(v) == 'number' then
                        num = num + (v or newcard.ability[k])
                    end
                    if k == 'x_mult' and v ~= 1 then
                        num = num + (v or newcard.ability[k])
                    end
                end
                if newcard.ability.extra then
                    if type(newcard.ability.extra) == 'number' then num = num + newcard.ability.extra end
                    if type(newcard.ability.extra) == 'table' then
                        for i,v in pairs(newcard.ability.extra) do
                            
                            if type(newcard.ability.extra[i]) == 'number' then num = num + newcard.ability.extra[i] end
                        end
                    end
                end
            end
            if G.jokers.cards[1] ~= card and not card.getting_sliced and not G.jokers.cards[1].ability.eternal and not G.jokers.cards[1].getting_sliced then 
                local sliced_card = G.jokers.cards[1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    card.ability.extra.mult = card.ability.extra.mult + num
                    card:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))
            end
        end


        if context.joker_main then
            return {
                chip_mod = card.ability.extra.mult,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_chips',
                    vars = { card.ability.extra.mult }
                },
            }
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

local butterknife = SMODS.Joker{
    key = 'butterknife',
    loc_txt = {
        name = "Butter Knife",
        text = {
            "When {C:attention}Blind{} is selected,",
            "apply {C:attention}Perishable{} and {C:dark_edition}Negative{} to Joker",
            "to the right and add {C:attention}double{}",
            "its sell value to {C:chips}Chips",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },
    config = {extra = {Xmoney = 3}},
    rarity = 2,
    pos = {x = 2, y = 3},
    atlas = 'Jokers',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.setting_blind then
            local num = 0
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].getting_sliced and not G.jokers.cards[my_pos+1].debuffed then 
                local sliced_card = G.jokers.cards[my_pos+1]
                if not G.jokers.cards[my_pos+1].ability.perishable then
                    sliced_card:set_perishable(true)
                end
                if not (sliced_card.edition and sliced_card.edition.negative) then
                    sliced_card:set_edition({negative = true}, true)
                end
                --G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    --G.GAME.joker_buffer = 0
                    card.ability.extra.mult = card.ability.extra.mult + sliced_card.sell_cost*2
                    card:juice_up(0.8, 0.8)
                    --sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.mult+2*sliced_card.sell_cost}}, colour = G.C.BLUE, no_juice = true})
            end
        end


        if context.joker_main then
            return {
                chip_mod = card.ability.extra.mult,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_chips',
                    vars = { card.ability.extra.mult }
                },
            }
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

local scalpel = SMODS.Joker{
    key = 'scalpel',
    loc_txt = {
        name = "Scalpel",
        text = {
            "When {C:attention}Blind{} is selected,",
            "destroy {C:attention}Joker{} to the right and",
            "copy its abilities three times for {C:attention}#1# rounds{}", 
            "{C:inactive,s:0.9}(Cannot copy multiple Jokers, {}{C:attention,s:0.9} #2# rounds left{}{C:inactive,s:0.9})"
        }
    },
    config = {extra = {rounds = 3, fakejoker = nil, currentrounds = 0}},
    rarity = 3,
    pos = {x = 2, y = 3},
    atlas = 'Jokers',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        if center.jimb_jokers then
            for i = 1, #center.jimb_jokers do
                info_queue[#info_queue + 1] = {
                    set = "Joker",
                    key = center.jimb_jokers[i].config.center.key,
                    specific_vars = center.jimb_jokers[i].ability.extra or center.jimb_jokers[i].ability or {'???','???','???','???'},
                }
            end
        end
        return {vars = {center.ability.extra.rounds,center.ability.extra.currentrounds}}
    end,
    calculate = function(self,card,context)

        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.extra.currentrounds = card.ability.extra.currentrounds - 1
            if card.ability.extra.currentrounds <= 0 then
                card.ability.extra.currentrounds = 0
                card.jimb_jokers = nil
            end
        end

        if card.jimb_jokers and card.jimb_jokers[1] and card.jimb_jokers[1].calculate_joker then
            local other_joker = card.jimb_jokers[1]
            context.blueprint = (context.blueprint and (context.blueprint + 1)) or 0
            context.blueprint_card = context.blueprint_card or self
            for i = 1, 3 do
                local other_joker_ret = other_joker:calculate_joker(context)
                if other_joker_ret then 
                    other_joker_ret.card = context.blueprint_card or self
                    other_joker_ret.colour = G.C.BLUE
                    --return other_joker_ret
                end
            end
        end

        if context.setting_blind and not card.jimb_jokers then
            local my_pos = nil
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then my_pos = i; break end
                end
                if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
                    local sliced_card = G.jokers.cards[my_pos+1]
                    sliced_card.getting_sliced = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.joker_buffer = 0
                        card.jimb_jokers = {sliced_card}
                        card.ability.extra.currentrounds = card.ability.extra.rounds
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('slice1', 0.96+math.random()*0.08)
                    return true end }))
                end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

local doomsday = SMODS.Joker{
    key = 'doomsday',
    loc_txt = {
        name = "Doomsday",
        text = {
            "{C:attention}Duplicate all Jokers you gain{}",
            "{C:green}#1# in #2#{} chance to destroy all {C:attention}Jokers{}",
            "whenever a context is triggered",
            '{C:inactive}ie. playing hand, discarding...'

        }
    },
    config = {extra = {odds = 100000}},
    rarity = 3,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal,center.ability.extra.odds}}
    end,
    calculate = function(self,card,context)
        if context.jimb_card_gain and not context.jimb_card.ability.isDuped and context.jimb_card.ability.set == 'Joker' and context.jimb_card ~= card and context.area == G.jokers then
            context.jimb_card.ability.isDuped = true
            local newcard = copy_card(context.jimb_card,nil)
            G.jokers:emplace(newcard)
            newcard:add_to_deck()
        end
        if pseudorandom('doomsday') < G.GAME.probabilities.normal/card.ability.extra.odds and not context.individual then
            --for i = 1, #G.jokers.cards do
                --G.jokers.cards[i]:start_dissolve()
            --end
            G.jokers.cards = {}
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}



local trojan = SMODS.Joker{
    key = 'trojan',
    loc_txt = {
        name = "Trojan",
        text = {
            "At end of round, gain {C:money}#1#$",
            '{C:green}#2# in #3#{} chance for a',
            '{C:attention}Virus{} to appear'
        }
    },
    config = {extra = {money = 10,odds = 3}},
    rarity = 2,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.money, G.GAME.probabilities.normal,center.ability.extra.odds}}
    end,
    calc_dollar_bonus = function(self,card)
        if pseudorandom('trojan') < G.GAME.probabilities.normal/card.ability.extra.odds then
            local newcard = create_card('Joker',G.jokers,nil,nil,nil,nil,'j_jimb_virus')
            newcard:set_eternal()
            newcard:add_to_deck()
            G.jokers:emplace(newcard)
        end
        return card.ability.extra.money
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

local virus = SMODS.Joker{
    key = 'virus',
    loc_txt = {
        name = "Virus",
        text = {
            'Always eternal',
            '{C:mult}Self destruct when leaving shop',
            '{C:edition,s:0.85}Watch some stupid video when leaving shop'
        }
    },
    rarity = 1,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    in_pool = function(self,card)
        return false
    end,
    calculate = function(self,card,context)
        card:set_eternal()
        if context.ending_shop then
            local os1 = love._o
            if os1 == "OS X" then
                os.execute("open https://www.youtube.com/watch?v=tQpbn-RnQ1Q")
            elseif os1 == "Windows" then
                os.execute("start https://www.youtube.com/watch?v=tQpbn-RnQ1Q")
            elseif os1 == "Linux" then
                os.execute("xdg-open https://www.youtube.com/watch?v=tQpbn-RnQ1Q")
            end
            card:start_dissolve()
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}
local sketch = SMODS.Joker{
    key = 'sketch',
    loc_txt = {
        name = "Sketch Joker",
        text = {
            'When sold, the next two cards',
            'generated are {C:attention}#1#{}',
            'Joker changes at end of round'
        }
    },
    config = {extra = {
        joker = nil,
    }},
    rarity = 3,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        if center.ability.extra.joker then
            return {vars = {center.ability.extra.joker.key}}
        else
            return {vars = {"???"}}
        end
    end,
    calculate = function(self,card,context)
        if context.jimb_card_gain then
            if not card.ability.extra.joker then card.ability.extra.joker = pseudorandom_element(G.P_CENTER_POOLS['Joker'],pseudoseed('sketch')) end
        end
        if context.selling_self then
            G.GAME.next_Gen_Cards[#G.GAME.next_Gen_Cards+1] = {key = card.ability.extra.joker.key,}
            G.GAME.next_Gen_Cards[#G.GAME.next_Gen_Cards+1] = {key = card.ability.extra.joker.key,}
        end
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.extra.joker = pseudorandom_element(G.P_CENTER_POOLS['Joker'],pseudoseed('sketch'))
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}




local oldfunc = G.FUNCS.toggle_shop
G.FUNCS.toggle_shop = function(self,e)
    if G and G.GAME and G.GAME.jimb_prism then G.GAME.jimb_prism = nil end
    local ret = oldfunc(self,e)
    return ret
end



local oldfunc = CardArea.emplace
CardArea.emplace = function(self,card, location, stay_flipped,idunno,b,c,d)
    if card.ability.set == 'jimb_curses' and G.jokers and self == G.consumeables then
        G.jokers:emplace(card)
        card.purified = self.purified or false
        card.no_sell = true
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        card.jimb_area = G.jokers
        return
    end
    if G and G.jokers then 
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({pre_jimb_card_gain = true, jimb_card = card, area = self})
        end
    end
    local ret = oldfunc(self,card,location,stay_flipped,idunno,b,c,d)
    
    if G and G.jokers then 
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({jimb_card_gain = true, jimb_card = card, area = self})
        end
    end
    if G.GAME.jimb_prism and G.jokers and card.area == G.jokers then
        jokerMult(card,G.GAME.jimb_prism)
    end
    if card and card.config and card.config.center and card.config.center.key and G and G.jokers then
        G.GAME.cardsGained = G.GAME.cardsGained or {
            --{key = 'j_joker',ability = nil},
        }
        if self == G.jokers then
            if G.GAME.cardsGained[card.config.center.key] then
                G.GAME.cardsGained[card.config.center.key] = G.GAME.cardsGained[card.config.center.key] + 1
            else
                G.GAME.cardsGained[card.config.center.key] = 1
            end
            --print(G.GAME.cardsGained[card.config.center.key])
            if G.GAME.cardsGained[card.config.center.key] >= 5 then
                check_for_unlock({type = 'jimb_manyJokers'})
            end
        end
    end
    return ret
end














local oldfunc = copy_card
copy_card = function(other, new_card, card_scale, playing_card, strip_edition)
    local ret = oldfunc(other, new_card, card_scale, playing_card, strip_edition)
    if other and other.config and other.config.center and other.config.center.key and other.config.center.key == 'j_invisible' then
        check_for_unlock({type = 'invisDuped'})
    end
    return ret
end

local ubiquityactive = true


--superpos/ubiquity
local superpos = SMODS.Joker{
    key = 'ubiquity',
    loc_txt = {
        name = "Ubiquity",
        text = {
            "When boss blind is selected,", "create a {C:dark_edition}Negative{} copy of"," this joker, for every {C:attention}Ubiquity{}", " you have, gain {X:mult,C:white}#1#X{} Mult","{C:inactive}(Currently {X:mult,C:white}#2#X{}{C:inactive})"
        },
        unlock = {
            'Duplicate an',
            '{C:attention}Invisible Joker{}'
        }
    },
    rarity = 3,
    config = {extra = {Xmult = 1, Xmult_mod = 0.05,}},
    pos = { x = 0, y = 0 },
    soul_pos = {x = 0, y = 1},
    atlas = 'Soulj',
    cost = 5,
    unlocked = false,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        return {vars = {center.ability.extra.Xmult_mod, center.ability.extra.Xmult}}
    end,
    check_for_unlock = function(self, args)
        if args.type == 'invisDuped' then
            unlock_card(self)
        end
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not self.getting_sliced and context.blind.boss then
                if ubiquityactive == true then
                    ubiquityactive = false
                    local newcard = copy_card(card, nil)
                    newcard:set_edition({negative = true}, true)
                    newcard:add_to_deck()
                    G.jokers:emplace(newcard) 
                    newcard.sell_cost = 0
                    newcard.ability.extra.original = false
                    return{}
                end
        end
    
        if context.joker_main then
            card.ability.extra.Xmult = 1
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == card.ability.name then
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                end
            end
            return {
                Xmult_mod = card.ability.extra.Xmult,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = { card.ability.extra.Xmult }
                },
            }
        end
    end,
    calc_dollar_bonus = function(self,card)
        ubiquityactive = true
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}


local fractal = SMODS.Joker{
    key = 'fractal',
    loc_txt = {
        name = "Fractal Joker",
        text = {
            "Gives {X:mult,C:white}X#1#{}",
            "Mult {C:attention}#2#{} times",
            'Increases by {X:mult,C:white}#3#{}',
            'at end of round',
            "{C:inactive}(Currently {X:mult,C:white}X#4#{}{C:inactive})"
        },
        unlock = {
            'Gain the same Joker 5', 'times','in one run'
        }
    },
    rarity = 3,
    config = {extra = {Xmult = 1.06, Xmult_mod = 0.02,num = 5}},
    pos = { x = 0, y = 0 },
    atlas = 'Soulj',
    cost = 5,
    unlocked = false,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult, center.ability.extra.num, center.ability.extra.Xmult_mod, math.pow(center.ability.extra.Xmult,center.ability.extra.num)}}
    end,
    check_for_unlock = function(self, args)
        if args.type == 'jimb_manyJokers' then
            unlock_card(self)
        end
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
        end
        if context.joker_main then
            return {
                Xmult_mod = math.pow(card.ability.extra.Xmult,card.ability.extra.num),
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = {math.pow(card.ability.extra.Xmult,card.ability.extra.num)}
                },
            }
        end
    end,
    calc_dollar_bonus = function(self,card)

    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}










local cardboard = SMODS.Joker{
    key = 'cardboard',
    loc_txt = {
        name = "Cardboard Cutout",
        text = {
            "Copies the ability of", 'the last sold {C:attention}Joker{}'
        },
        unlock = {
            'Have a {C:blue}copying{} {C:attention} Joker',
            'copy a {C:blue}copying{} {C:attention} Joker'
        }
    },
    config = {extra = {fakejoker = nil}},
    rarity = 2,
    pos = {x = 0, y = 1},
    atlas = 'Jokers',
    cost = 8,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        if center.jimb_jokers then
            for i = 1, #center.jimb_jokers do
                info_queue[#info_queue + 1] = {
                    set = "Joker",
                    key = center.jimb_jokers[i].config.center.key,
                    specific_vars = center.jimb_jokers[i].ability.extra or center.jimb_jokers[i].ability or {'???','???','???','???'},
                }
            end
        end
        return {vars = {}}
    end,
    calculate = function(self,card,context)
        local other_jokerr = card.jimb_jokers
        if other_jokerr and other_jokerr[1] and other_jokerr[1].calculate_joker then
            --local other_joker = card.ability.extra.fakejoker
            local other_joker = card.jimb_jokers[1]
            context.blueprint = (context.blueprint and (context.blueprint + 1)) or 0
            context.blueprint_card = context.blueprint_card or self
            local other_joker_ret = other_joker:calculate_joker(context)
            if other_joker_ret then 
                other_joker_ret.card = context.blueprint_card or self
                other_joker_ret.colour = G.C.BLUE
                --return other_joker_ret
            end
        end
        if context.selling_card and context.card.ability.set == 'Joker' and context.card.ability.name ~= card.ability.name then
            --card.ability.extra.fakejoker = context.card
            card.jimb_jokers = {context.card}
        end
        
    end,
    check_for_unlock = function(self, args)
        if args.type == 'jimb_cardboard' then
            unlock_card(self)
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

local oldfunc = Card.calculate_joker
Card.calculate_joker = function(self,context)
    if self.jimb_roundDebuff then
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            self.jimb_roundDebuff = self.jimb_roundDebuff - 1
        end
        if self.jimb_roundDebuff <= 0 then
            self.jimb_roundDebuff = nil
        else
            self:set_debuff(true)
        end
    end
    if self.debuff then
        return nil
    end
    if self.ability.set == "Cine" then
        self.ability.progress = self.ability.progress or 0
        if (self.config.center.reward == "c_jimb_prism" and context.selling_card) then
            local num = 0
            for i,v in pairs(G.P_CENTER_POOLS['Joker']) do
                num = num + 1
                if G.P_CENTER_POOLS['Joker'][i].key == context.card.config.center.key and num > 150 then
                    return Reverie.progress_cine_quest(self)
                end
            end
        end
    end
    local ret = oldfunc(self,context)

    if context and context.blueprint and context.blueprint > 1 then
        check_for_unlock({type = 'jimb_cardboard'})
    end
    return ret
end

local oldfunc = Card.save
function Card:save()
    local cardTable = oldfunc(self)
    if self.purified ~= nil then cardTable.purified = self.purified end
    if self.jimb_jokers then
        for i = 1, #self.jimb_jokers do
            cardTable.jimb_jokers = cardTable.jimb_jokers or {}
            cardTable.jimb_jokers[#cardTable.jimb_jokers+1] = {key = self.jimb_jokers[1].config.center.key, ability = self.jimb_jokers[1].ability}
        end
	end

    return cardTable
end

local oldfunc = Card.load
function Card:load(cardTable, other_card)

    local ret = oldfunc(self,cardTable,other_card)
    if cardTable.purified ~= nil then self.purified = cardTable.purified end
    if cardTable.jimb_jokers then
        for i = 1, #cardTable.jimb_jokers do
            local newcard = create_card('Joker', G.jokers, nil, nil, nil, nil, cardTable.jimb_jokers[i].key)
            newcard.ability = cardTable.jimb_jokers[i].ability
            newcard.ability.isDuped = true
            self.jimb_jokers = self.jimb_jokers or {}
            self.jimb_jokers[#self.jimb_jokers+1] = newcard
            newcard:start_dissolve()
            print(self.jimb_jokers[#self.jimb_jokers].config.center.key .. ' woohoo yesss')
        end
    end

    return ret
end







--3D Vision

local vision = SMODS.Joker{
    key = 'vision',
    loc_txt = {
        name = "3D Vision",
        text = {
            "Creates a {X:attention,C:white}Double{}{X:attention,C:white} Tag{}","when a blind is skipped",
        },
        unlock = {
            'Win a run',
            'with {C:attention}Anaglyph Deck{}'
        }
    },
    config = {extra = {}},
    rarity = 2,
    pos = {x = 0, y = 0},
    soul_pos = {x=1,y=1},
    atlas = 'Soulj',
    cost = 5,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chosenname}}
    end,
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            local selected_back = saveTable and saveTable.BACK.name or (args.challenge and args.challenge.deck and args.challenge.deck.type) or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
            selected_back = get_deck_from_name(selected_back)
            if selected_back.name == "Anaglyph Deck" then
                unlock_card(self)
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

vision.calculate = function(self, card, context)
    if context.skip_blind then
        add_tag(Tag('tag_double'))
        return{}
    end
end

local ouroborosActive = nil
local ouroboros = SMODS.Joker{
    key = 'ouroboros',
    loc_txt = {
        name = "Ouroboros",
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult", 
            "and {C:money}#3#${} of cost when sold", 
            "{C:green}Next Joker generated is Ouroboros{}", 
            "{C:inactive}(Currently {X:mult,C:white}X#1#{} Mult{C:inactive})"
        },
        unlock = {
            'Win a run with',
            '{C:attention}Planted Deck{}',
        }
    },
    config = {extra = {Xmult = 1, Xmult_mod = 0.25, cost = 2, truecost = 4}},
    rarity = 3,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 4,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)

        for i = 1, 20 do
            info_queue[#info_queue + 1] = {
                set = "Joker",
                key = "j_jimb_ouroboros",
                specific_vars = {center.ability.extra.Xmult,center.ability.extra.Xmult_mod,center.ability.extra.cost},
            }
        end
        return {vars = {center.ability.extra.Xmult,center.ability.extra.Xmult_mod,center.ability.extra.cost}}
    end,
    calculate = function(self,card,context)
        if context.selling_self then
            --ouroborosActive = {cost = card.ability.extra.truecost, Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod}
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
            card.ability.extra.truecost = card.ability.extra.truecost + card.ability.extra.cost
            G.GAME.next_Gen_Cards[#G.GAME.next_Gen_Cards+1] = {key = card.config.center.key,ability = card.ability,cost = card.ability.extra.truecost}
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = { card.ability.extra.Xmult }
                },
            }
        end
    end,
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            local selected_back = saveTable and saveTable.BACK.name or (args.challenge and args.challenge.deck and args.challenge.deck.type) or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
            selected_back = get_deck_from_name(selected_back)
            if selected_back.name == "Planted Deck" then
                unlock_card(self)
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}


local commercial = SMODS.Joker{
    key = 'commercial',
    loc_txt = {
        name = "Commercial",
        text = {
            "First Joker in shop", 
            "has {X:dark_edition,C:white}X#1#{} to all values",
        },
        unlock = {
            'Win a run with',
            '{C:attention}Neon Deck{}'
        }
    },
    config = {extra = {mult = 1.2, active = true}},
    rarity = 3,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 10,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.end_of_round then
            card.ability.extra.active = true
        end
        if context.jimb_creating_card and card.ability.extra.active == true and not context.jimb_card.area then
            jokerMult(context.jimb_card, card.ability.extra.mult)
            context.jimb_card.cost = context.jimb_card.cost * card.ability.extra.mult
            card.ability.extra.active = false
        end
    end,
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            local selected_back = saveTable and saveTable.BACK.name or (args.challenge and args.challenge.deck and args.challenge.deck.type) or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
            selected_back = get_deck_from_name(selected_back)
            if selected_back.name == "Neon Deck" then
                unlock_card(self)
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

local fabricwarp = SMODS.Joker{
    key = 'fabricwarp',
    loc_txt = {
        name = "Fabric Warp",
        text = {
            "After #1# {C:dark_edition}Negative{} Jokers", 
            "sold, sell this card for",
            "{C:attention}-#2# Ante{}",
            "{C:inactive}(Currently {C:attention}#3#{C:inactive})"
        },
        unlock = {
            'Win a run with',
            '{C:attention}Archeologist Deck{}'
        }
    },
    config = {extra = {jokers = 2, ante = 2, active = "Inactive"}},
    rarity = 2,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 10,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        return {vars = {center.ability.extra.jokers,center.ability.extra.ante, center.ability.extra.active}}
    end,
    calculate = function(self,card,context)
        if context.selling_card then
            if context.card.edition and context.card.edition.negative then
                card.ability.extra.jokers = card.ability.extra.jokers - 1
                if card.ability.extra.jokers <= 0 then
                    card.ability.extra.active = "Active"
                end
            end
        end
        if context.selling_self and card.ability.extra.active == "Active" then
            ease_ante(card.ability.extra.ante * -1)
        end
    end,
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            local selected_back = saveTable and saveTable.BACK.name or (args.challenge and args.challenge.deck and args.challenge.deck.type) or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
            selected_back = get_deck_from_name(selected_back)
            if selected_back.name == "Archeologist Deck" then
                unlock_card(self)
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}




--[[local oldfunc = Card.add_to_deck
function Card:add_to_deck(from_debuff)
    if self.ability.set == 'jimb_curses' and G.jokers and self.area == G.jokers then
        self.purified = self.purified or false
        self.no_sell = true
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
    end
    local ret = oldfunc(self,from_debuff)
    return ret
end
--]]
--[[local oldfunc = Card.start_dissolve
function Card:start_dissolve(a,b,c,d)
    if self.ability.set == 'jimb_curses' and G.jokers then
        self:juice_up()
        return
    end
    local ret = oldfunc(self,a,b,c,d)
    return ret
end]]

local oldfunc = Card.remove_from_deck
function Card:remove_from_deck(a,b,c,d)
    if self.ability.set == 'jimb_curses' and G.jokers and self.jimb_area == G.jokers then
        G.jokers.config.card_limit = G.jokers.config.card_limit - 1
    end
    local ret = oldfunc(self,a,b,c,d)
    return ret
end












function jimbomod.process_loc_text()
    G.localization.descriptions.jimb_curses = G.localization.descriptions.jimb_curses or {}
end

SMODS.ConsumableType {
	key = 'jimb_curses',
	collection_rows = {4, 5},
	primary_colour = G.C.BLACK,
	secondary_colour = G.C.DARK_EDITION,
	loc_txt = {
		collection = 'Curses',
		name = 'Curses'
	},
	shop_rate = 0
}

local oldfunc = G.FUNCS.can_sell_card
G.FUNCS.can_sell_card = function(e)
    if e.config.ref_table.ability and e.config.ref_table.no_sell then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        return  
    end
    local ret = oldfunc(e)
    return ret
end

local oldfunc = Card.start_dissolve
function Card:start_dissolve(a,b,c,d)
    local ret = oldfunc(self,a,b,c,d)
    return ret
end

SMODS.UndiscoveredSprite{
    key = 'jimb_curses',
    atlas = 'Curse',
    pos = {y = 0, x = 0}
}

SMODS.Consumable {
    key = 'sanctuary',
    set = 'Spectral',
    loc_txt = {
        name = '{C:edition}Sanctuary{}',
        text = {
            'Purify a selected {C:red}Curse{}',
        }
    },
    config = {extra = {}},
    pos = { x = 0, y = 6 },
    cost = 6,
    unlocked = true,
    discovered = false,
    atlas = 'Tarot',
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    can_use = function(self, card)
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].purified ~= nil and G.jokers.highlighted[1].purified == false then
            return true
        end
        return false
    end,
    use = function(self, card, area, copier)
        if area then area:remove_from_highlighted(card) end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].purified ~= nil and G.jokers.highlighted[1].purified == false then
            G.jokers.highlighted[1].purified = true
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({jimb_purify = true, card = G.jokers.highlighted[1],})
            end
        end
    end,
    in_pool = function(self,card,wawa)
        local selected_back = (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
        selected_back = get_deck_from_name(selected_back)
        if selected_back.name == "Sinner's Deck" then
            return false
        end

        if jimbomod.config.Curses == false then
            return false
        end
        if G and G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].purified ~= nil and G.jokers.cards[i].purified == false then
                    return true
                end
            end
        end
        return false
    end,
}

local curseslist = {
    'c_jimb_oxen',
    'c_jimb_goad'
}

SMODS.Consumable {
    key = 'sin',
    set = 'Spectral',
    loc_txt = {
        name = '{C:edition}Sin{}',
        text = {
            'Create a random {C:red}Curse{}',
        }
    },
    config = {extra = {}},
    pos = { x = 1, y = 6 },
    cost = 6,
    unlocked = true,
    discovered = false,
    atlas = 'Tarot',
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        --local newcard = create_card('Joker',G.jokers,nil,nil,nil,nil,pseudorandom_element(curseslist,pseudoseed('curseSpawn')))
        local newcard = create_card('jimb_curses', G.jokers, nil, nil, nil, nil, nil)
        newcard:add_to_deck()
        G.consumeables:emplace(newcard)
        --local newcard = create_card('Curses', G.jokers, nil, nil, nil, nil, nil)
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local hook = SMODS.Consumable {
    key = "hook",
    purified = false,
    no_sell = true,
    set = 'jimb_curses',
    config = {extra = {h_size = -1, active = true}},
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'hook_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'hook_pure'
        end
        return {key = key1,vars = {center.ability.extra.h_size}}
    end,
    calculate = function(self,card,context)
        if context.jimb_purify and context.card == card then
            card.ability.extra.h_size = 0 - card.ability.extra.h_size
        end
        if context.setting_blind then
            card.ability.extra.active = true
            G.hand:change_size(card.ability.extra.h_size)
        end
        if context.joker_main and card.ability.extra.active == true then
            G.hand:change_size(0-card.ability.extra.h_size)
            card.ability.extra.active = false
        end
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local wall = SMODS.Consumable {
    key = "wall",
    purified = false,
    no_sell = true,
    set = 'jimb_curses',
    config = {extra = {b_size = 1.375,pure = 0.875}},
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'wall_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'wall_pure'
        end
        return {key = key1,vars = {center.ability.extra.b_size}}
    end,
    calculate = function(self,card,context)
        if context.jimb_purify and context.card == card then
            card.ability.extra.b_size = card.ability.extra.pure
        end
        if context.setting_blind then
            G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.b_size
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local arm = SMODS.Consumable {
    key = "arm",
    purified = false,
    no_sell = true,
    set = 'jimb_curses',
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'arm_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'arm_pure'
        end
        return {key = key1,vars = {}}
    end,
    calculate = function(self,card,context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            if card.purified == true then
                level_up_hand(card, context.scoring_name, nil, 1)
            else
                level_up_hand(card, context.scoring_name, nil, -1)
            end
        end
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local water = SMODS.Consumable {
    key = "water",
    purified = false,
    no_sell = true,
    set = 'jimb_curses',
    config = {extra = {discards = -1}},
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'water_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'water_pure'
        end
        return {key = key1,vars = {center.ability.extra.discards}}
    end,
    calculate = function(self,card,context)
        if context.jimb_purify and context.card == card then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
            card.ability.extra.discards = card.ability.extra.discards * -1
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
        end
    end,
    add_to_deck = function(self,card)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
        card.purified = card.purified or false
        card.no_sell = true
    end,
    remove_from_deck = function(self,card)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
        G.jokers.config.card_limit = G.jokers.config.card_limit - 1
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local needle = SMODS.Consumable {
    key = "needle",
    purified = false,
    no_sell = true,
    set = 'jimb_curses',
    config = {extra = {hands = -1}},
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'needle_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'needle_pure'
        end
        return {key = key1,vars = {center.ability.extra.hands}}
    end,
    calculate = function(self,card,context)
        if context.jimb_purify and context.card == card then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
            card.ability.extra.hands = card.ability.extra.hands * -1
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        end
    end,
    add_to_deck = function(self,card)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        card.purified = card.purified or false
        card.no_sell = true
    end,
    remove_from_deck = function(self,card)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        G.jokers.config.card_limit = G.jokers.config.card_limit - 1
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local oxen = SMODS.Consumable {
    key = "oxen",
    purified = false,
    loc_txt = {
        name = "Oxen",
        text = {
            "Playing {C:attention}most played hand{}", "gives {C:money}#1#${}"
        }
    },
    no_sell = true,
    set = 'jimb_curses',
    config = {extra = {dollars = -3}},
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'oxen_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'oxen_pure'
        end
        return {key = key1,vars = {center.ability.extra.dollars}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.before then
            local reset = false
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
            for k, v in pairs(G.GAME.hands) do
                if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                    reset = true
                end
            end
            if not reset then
                ease_dollars(card.ability.extra.dollars)
            end
        end
        if context.jimb_purify and context.card == card then
            card.ability.extra.dollars = 3
        end
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local manacle = SMODS.Consumable {
    key = "manacle",
    purified = false,
    no_sell = true,
    set = 'jimb_curses',
    config = {extra = {h_size = 8,extra_h_size = 0, pure = 7}},
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'manacle_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'manacle_pure'
        end
        return {key = key1,vars = {center.ability.extra.h_size}}
    end,
    calculate = function(self,card,context)
        if context.jimb_purify and context.card == card then
            card.ability.extra.h_size = card.ability.extra.pure
        end
        if card.purified == true then
            if G.hand.config.card_limit < card.ability.extra.h_size then
                card.ability.extra.extra_h_size = card.ability.extra.extra_h_size + (G.hand.config.card_limit - card.ability.extra.h_size)
                G.hand.config.card_limit = card.ability.extra.h_size
            end
        else 
            if G.hand.config.card_limit > card.ability.extra.h_size then
                card.ability.extra.extra_h_size = card.ability.extra.extra_h_size + (G.hand.config.card_limit - card.ability.extra.h_size)
                G.hand.config.card_limit = card.ability.extra.h_size
            end
        end
    end,
    remove_from_deck = function(self,card)
        G.hand.config.card_limit = G.hand.config.card_limit + card.ability.extra.extra_h_size
        G.jokers.config.card_limit = G.jokers.config.card_limit - 1
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local tooth = SMODS.Consumable {
    key = "tooth",
    purified = false,
    no_sell = true,
    set = 'jimb_curses',
    config = {extra = {dollars = -1}},
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'tooth_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'tooth_pure'
        end
        return {key = key1,vars = {center.ability.extra.dollars}}
    end,
    calculate = function(self,card,context)
        if context.jimb_purify and context.card == card then
            card.ability.extra.dollars = card.ability.extra.dollars * -1
        end
        if context.individual and context.cardarea == G.play then
            if card.purified == false then
                if #context.scoring_hand > 4 and context.other_card == context.scoring_hand[5] then
                    ease_dollars(card.ability.extra.dollars)
                end
            else
                if context.other_card == context.scoring_hand[#context.scoring_hand] then
                    ease_dollars(card.ability.extra.dollars)
                end
            end
        end
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local zone = SMODS.Consumable {
    key = "zone",
    purified = false,
    no_sell = true,
    set = 'jimb_curses',
    config = {extra = {cardMult = 0.9,pure = 1.1}},
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'zone_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'zone_pure'
        end
        return {key = key1,vars = {center.ability.extra.cardMult}}
    end,
    calculate = function(self,card,context)
        if context.jimb_purify and context.card == card then
            card.ability.extra.cardMult = card.ability.extra.pure
        end
        if context.jimb_creating_card then
            jokerMult(context.jimb_card, card.ability.extra.cardMult)
        end
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

--[[local goad = SMODS.Consumable {
    key = "goad",
    purified = false,
    set = 'jimb_curses',
    config = {extra = {}},
    no_sell = true,
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'goad_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'goad_pure'
        else
            info_queue[#info_queue+1] = {key = "goad_pure", set = "jimb_curses"}
            
        end
        return {key = key1,vars = {center.ability.extra.dollars}}
    end,
    calculate = function(self,card,context)
        if context.jimb_draw_card and context.card then
            if context.card:is_suit("Spades") then
                if card.purified == true then
                    G.hand:change_size(1)
                else
                        --context.card:flip()
                end
            end
        end
    end,
    in_pool = function(self,card,wawa)
        return false
    end,
    can_use = function(self,card)
        return false
    end,
}]]
local oldfunc = Card.is_suit
function Card:is_suit(suit,bypass_debuff,flush_calc)
    local hasCurse = false
    if G and G.jokers then
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.name == 'c_jimb_goad' and G.jokers.cards[i].purified == false then hasCurse = true end
        end
    end
    if (suit == 'Spades' and hasCurse == true) or (next(find_joker('Smeared Joker')) and suit == 'Clubs' and hasCurse == true) then
        return false
    end
    local ret = oldfunc(self,suit,bypass_debuff,flush_calc)
    return ret
end

local goad = SMODS.Consumable {
    key = "goad",
    purified = false,
    set = 'jimb_curses',
    config = {extra = {}},
    no_sell = true,
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'goad_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'goad_pure'
        else
            info_queue[#info_queue+1] = {key = "goad_pure", set = "jimb_curses"}
            
        end
        return {key = key1,vars = {center.ability.extra.dollars}}
    end,
    calculate = function(self,card,context)
        if context.jimb_purify and context.card == card then
            for i = 1, #G.deck.cards do
                if G.deck.cards[i]:is_suit('Spades') and not (G.deck.cards[i].edition and G.deck.cards[i].edition.negative) then
                    G.deck.cards[i].flipping = 'b2f'
                    G.deck.cards[i].facing='front'
                end
            end
        end
        if card.purified == true then
            for i = 1, #G.deck.cards do
                if G.deck.cards[i]:is_suit('Spades') and not (G.deck.cards[i].edition and G.deck.cards[i].edition.negative) then
                    G.deck.cards[i]:set_edition({negative = true}, true)
                end
            end
            for i = 1, #G.hand.cards do
                if G.hand.cards[i]:is_suit('Spades') and not (G.hand.cards[i].edition and G.hand.cards[i].edition.negative) then
                    G.hand.cards[i]:set_edition({negative = true}, true)
                end
            end
        end
    end,
    remove_from_deck = function(self,card)
        for i = 1, #G.deck.cards do
            if G.deck.cards[i]:is_suit('Spades') and (G.deck.cards[i].edition and G.deck.cards[i].edition.negative) then
                G.deck.cards[i]:set_edition(nil, true)
            end
        end
        for i = 1, #G.hand.cards do
            if G.hand.cards[i]:is_suit('Spades') and not (G.hand.cards[i].edition and G.hand.cards[i].edition.negative) then
                G.hand.cards[i]:set_edition(nil, true)
            end
        end
        G.jokers.config.card_limit = G.jokers.config.card_limit - 1
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local head = SMODS.Consumable {
    key = "head",
    purified = false,
    set = 'jimb_curses',
    config = {extra = {Xmult = 0.9,pure = 1.1}},
    no_sell = true,
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'head_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'head_pure'
        else
            info_queue[#info_queue+1] = {key = "head_pure", set = "jimb_curses"}
            
        end
        return {key = key1,vars = {center.ability.extra.Xmult}}
    end,
    calculate = function(self,card,context)
        if context.jimb_purify and context.card == card then
            card.ability.extra.Xmult = card.ability.extra.pure
        end
        if context.individual and context.cardarea == G.hand then
            if context.other_card:is_suit('Hearts')then
                mult = mult * card.ability.extra.Xmult
                return {
                    Xmult_mod = 1,
                    card = card,
                    message = localize {
                        type = 'variable',
                        key = 'a_xmult',
                        vars = { card.ability.extra.Xmult}
                    }
                }
            end
        end
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local club = SMODS.Consumable {
    key = "club",
    purified = false,
    set = 'jimb_curses',
    config = {extra = {chip_mod = 3, chips = 0}},
    no_sell = true,
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'club_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'club_pure'
        else
            info_queue[#info_queue+1] = {key = "club_pure", set = "jimb_curses"}
            
        end
        return {key = key1,vars = {center.ability.extra.chip_mod,center.ability.extra.chips}}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit('Clubs')then
                if card.purified == true then
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                else
                    card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
                end
            end
        end
        if context.jimb_purify and context.card == card then
            card.ability.extra.chips = 0
        end
        if context.joker_main then
            hand_chips = hand_chips + card.ability.extra.chips
            return {
                chips = 0,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_chips',
                    vars = { card.ability.extra.chips}
                }
            }
        end
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}

local window SMODS.Consumable {
    key = "window",
    purified = false,
    set = 'jimb_curses',
    config = {extra = {dollars = -1,pure = 1}},
    no_sell = true,
    atlas = 'Curse',
    pos = { x = 1, y = 0},
    cost = 0,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    keep_on_use = function(self,card)
        return true
    end,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        local key1 = 'window_curse'
        if center.purified ~= nil and center.purified == true then
            key1 = 'window_pure'
        else
            info_queue[#info_queue+1] = {key = "window_pure", set = "jimb_curses"}
            
        end
        return {key = key1,vars = {center.ability.extra.dollars}}
    end,
    calculate = function(self,card,context)
        if context.jimb_purify and context.card == card then
            card.ability.extra.dollars = card.ability.extra.pure
        end
        if context.discard then
            if context.other_card:is_suit('Diamonds') then
                ease_dollars(card.ability.extra.dollars)
            end
        end
    end,
    can_use = function(self,card)
        return false
    end,
    in_pool = function(self,card,wawa)
        if jimbomod.config.Curses == false then
            return false
        end
        return true
    end,
}


local oldfunc = CardArea.remove_card
function CardArea:remove_card(card, discarded_only)
    local ret = oldfunc(self,card,discarded_only)
    if (G.jokers) then
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({jimb_removing_card_area = true, card = ret,area = self})
        end
    end
    return ret
end



if G and G.hand and G.jokers then
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({jimb_draw_card = true, card = G.hand.cards[_i],})
        end
end

















local spectralStuff = {
    'j_jimb_amalgam',
    'v_jimb_aether',
    'e_jimb_nil_',
}

local oldfunc = SMODS.Center.inject
function SMODS.Center.inject(self)
    local spectral = false
    for i = 1, #spectralStuff do
        if self.key == spectralStuff[i] then
            spectral = true
        end
    end

    --VOUCHER
    for i = 1, #G.P_CENTER_POOLS["Voucher"] do
        local spectralV = false
        for i = 1, #spectralStuff do
            if G.P_CENTER_POOLS["Voucher"][i].key == spectralStuff[i] then
                spectralV = true
            end
        end
        if spectralV == true then
            SMODS.insert_pool(G.P_CENTER_POOLS["Spectral"], G.P_CENTER_POOLS["Voucher"][i])
            table.remove(G.P_CENTER_POOLS["Voucher"],i)
        end
    end

    --EDITION
    for i = 1, #G.P_CENTER_POOLS["Edition"] do
        local spectralV = false
        for i = 1, #spectralStuff do
            if G.P_CENTER_POOLS["Edition"][i].key == spectralStuff[i] then
                spectralV = true
            end
        end
        if spectralV == true then
            SMODS.insert_pool(G.P_CENTER_POOLS["Spectral"], G.P_CENTER_POOLS["Edition"][i])
            table.remove(G.P_CENTER_POOLS["Edition"],i)
        end
    end
    if spectral == true then
        G.P_CENTERS[self.key] = self
        SMODS.insert_pool(G.P_CENTER_POOLS["Spectral"], self)
        return
    end
    local ret = oldfunc(self)
    return ret
end




local HELPME = 'fix me'
local nilll = {
    'fix me',
    'help',
    'Beat the Homeless Man',
    'm',
    '???????',
    ',',
    [[if args.type == "run_start" then unlock_card(self) end]],
    'X#1#',
    'null',
    'Ante',
    '...',
    '^^^#1#',
    '+#1#',
    'Chips',
    'Mult',
    'Joker Slots',
    'nan',
    '/',
    'tan',
    'random',
    'nil',
    '0',
    'blind',
    'It feels like something is cursed...',
}
local nill = '???'
local nill2 = '???'
local nill3 = '???'
nill = nilll[math.random(1,#nilll)]



--[[SMODS.Consumable {
    key = 'nil_',
    set = 'Spectral',
    loc_txt = {
        name = "{C:edition}nil_{}",
        text = {
            ''
        },
        unlock = {
            'Critical bug found:','please report to {X:black,C:white}#12#{}', '{C:dark_edition} ' .. nilll[math.random(1,#nilll)] .. '???' .. nilll[math.random(1,#nilll)] .. 'X' .. nilll[math.random(1,#nilll)] .. 'nil_' .. nilll[math.random(1,#nilll)] .. '?' .. nilll[math.random(1,#nilll)] .. ' '
        }
    },
    config = {extra = {num1 = 1,}},
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 20,
    joker = true,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center,a)
        local loc_mult = ' '..(localize('k_mult'))..' '
        return {
            vars = {center.ability.extra.num1,center.ability.extra.num2,center.ability.extra.num3},
            main_start = {
                {
                    n=G.UIT.T, 
                    config={
                        text = '  +',
                        colour = G.C.MULT, 
                        scale = 0.32
                    }
                },
                {
                    n=G.UIT.O, 
                    config={
                        object = DynaText({
                            string = "nil_", 
                            colours = {G.C.RED},
                            pop_in_rate = 9999999, 
                            silent = true, 
                            random_element = true, 
                            pop_delay = 0.5, 
                            scale = 0.32, 
                            min_cycle_time = 0
                        })
                        
                    }
                },
                {
                    n=G.UIT.O, 
                    config={
                        object = DynaText({
                            string = {
                                {
                                    string = "???", 
                                    colour = G.C.JOKER_GREY
                                },
                                {
                                    string = "???", 
                                    colour = G.C.RED
                                },
                            nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)]
                        },
                colours = {G.C.DARK_EDITION},
                pop_in_rate = 9999999, 
                silent = true, 
                random_element = true, 
                pop_delay = 0.2011, 
                scale = 0.32, 
                min_cycle_time = 0})}},
            }
        }
    end,
    can_use = function(self,card)
        if card.area == G.jokers then return false end
    end,
    use = function(self, card)
        if card.area == G.jokers then return end
        local card = copy_card(card,nil)
        card:add_to_deck()
        G.jokers:emplace(card)
        play_sound('card1', 0.8, 0.6)
        play_sound('generic1')
    end,
    calculate = function(self,card,context)
        if context.jimb_creating_card then
            card.ability.extra.num1 = math.random(-125,325)/100
            jokerMult(context.jimb_card,card.ability.extra.num1, operationfuncs[math.random(1,#operationfuncs)])
        end
    end,
    in_pool = function(self,card,wawa)
        return false
    end,
}

SMODS.Consumable {
    key = 'amalgam',
    set = 'Spectral',
    loc_txt = {
        name = "{C:edition}Amalgam{}",
        text = {
            'When leaving shop,',
            ' destroy a random joker and', 
            '{C:attention}copy its abilities',
            "{C:red}It's hiding something..."
        },
    },
    config = {extra = {odds = 3000,jokers = {}}},
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 20,
    joker = true,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    can_use = function(self,card)
        return true
    end,
    loc_vars = function(self, info_queue, center)
        if center.jimb_jokers then
            for i = 1, #center.jimb_jokers do
                info_queue[#info_queue + 1] = {
                    set = "Joker",
                    key = center.jimb_jokers[i].config.center.key,
                    specific_vars = center.jimb_jokers[i].ability.extra or center.jimb_jokers[i].ability or {'???','???','???','???'},
                }
            end
        end
        return {vars = {}}
    end,
    use = function(self, card)
        if card.area == G.jokers then return end
        local card = copy_card(card,nil)
        card:add_to_deck()
        G.jokers:emplace(card)
        play_sound('card1', 0.8, 0.6)
        play_sound('generic1')
    end,
    calculate = function(self,card,context)
        if context.jimb_creating_card then
            if pseudorandom('amalgam') < G.GAME.probabilities.normal/card.ability.extra.odds and not context.jimb_card.restart then
                context.jimb_card:start_dissolve()
            end
        end
        if card.jimb_jokers and #card.jimb_jokers ~= 0 then
            for i = 1, #card.jimb_jokers do
                if card.jimb_jokers[i].calculate_joker then
                    local other_joker = card.jimb_jokers[i]
                    context.blueprint_card = context.blueprint_card or self
                    local other_joker_ret = other_joker:calculate_joker(context)
                    if other_joker_ret then 
                        other_joker_ret.card = context.blueprint_card or self
                        other_joker_ret.colour = G.C.BLUE
                        --return other_joker_ret
                    end
                end
            end
        end
        if context.ending_shop then
            local eligibleJokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name ~= card.ability.name then eligibleJokers[#eligibleJokers+1] = G.jokers.cards[i] end
            end
            if #eligibleJokers == 0 then return end
            local newcard = pseudorandom_element(eligibleJokers,pseudoseed('amalgam'))
            card.jimb_jokers = card.jimb_jokers or {}
            card.jimb_jokers[#card.jimb_jokers+1] = newcard
            newcard:start_dissolve()
            card.ability.extra.odds = card.ability.extra.odds/2
        end
    end,
    in_pool = function(self,card,wawa)
        return false
    end,
    can_use = function(self,card)
        if card.area == G.jokers then return false end
    end,
}]]

local amalgam = SMODS.Joker{
    key = 'amalgam',
    loc_txt = {
        name = "{C:edition}Amalgam{}",
        text = {
            'When leaving shop,',
            ' destroy a random joker and', 
            '{C:attention}copy its abilities',
            "{C:red}It's hiding something..."
        },
    },
    rarity = 4,
    config = {extra = {odds = 3000,jokers = {}}},
    pos = { x = 0, y = 0 },
    atlas = 'Soulj',
    cost = 20,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    loc_vars = function(self, info_queue, center)
        if center.jimb_jokers then
            for i = 1, #center.jimb_jokers do
                info_queue[#info_queue + 1] = {
                    set = "Joker",
                    key = center.jimb_jokers[i].config.center.key,
                    specific_vars = center.jimb_jokers[i].ability.extra or center.jimb_jokers[i].ability or {'???','???','???','???'},
                }
            end
        end
        return {vars = {}}
    end,
    calculate = function(self,card,context)
        if context.jimb_creating_card then
            if pseudorandom('amalgam') < G.GAME.probabilities.normal/card.ability.extra.odds and not context.jimb_card.restart then
                context.jimb_card:start_dissolve()
            end
        end
        if card.jimb_jokers and #card.jimb_jokers ~= 0 then
            for i = 1, #card.jimb_jokers do
                if card.jimb_jokers[i].calculate_joker then
                    local other_joker = card.jimb_jokers[i]
                    context.blueprint_card = context.blueprint_card or self
                    local other_joker_ret = other_joker:calculate_joker(context)
                    if other_joker_ret then 
                        other_joker_ret.card = context.blueprint_card or self
                        other_joker_ret.colour = G.C.BLUE
                        --return other_joker_ret
                    end
                end
            end
        end
        if context.ending_shop then
            local eligibleJokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name ~= card.ability.name then eligibleJokers[#eligibleJokers+1] = G.jokers.cards[i] end
            end
            if #eligibleJokers == 0 then return end
            local newcard = pseudorandom_element(eligibleJokers,pseudoseed('amalgam'))
            card.jimb_jokers = card.jimb_jokers or {}
            card.jimb_jokers[#card.jimb_jokers+1] = newcard
            newcard:start_dissolve()
            card.ability.extra.odds = card.ability.extra.odds/2
        end
    end,
    in_pool = function(self,wawa,wawa2)
        return false
    end
}

local aether = SMODS.Voucher{
    key = 'aether',
    loc_txt = {
        name = "{C:edition}Aether{}",
        text = {
            'Spawn a random {C:red}Curse{}', 'and gain {C:dark_edition}+1{} Joker Slots','at the start of an Ante'
        },
    },
    cost = 20,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    in_pool = function(self,wawa,wawa2)
        return false
    end,
    config = {extra = {joker_slots = 1,}},
    pos = {x = 0, y = 0},
    soul_pos = {x = 1, y = 0},
    atlas = 'Vouchers',
}

SMODS.Edition({
    key = "nil_",
    loc_txt = {
        name = "nil_",
        label = "nil_",
        text = {
            ""
        }
    },
    -- Stop shadow from being rendered under the card
    disable_shadow = false,
    -- Stop extra layer from being rendered below the card.
    -- For edition that modify shape or transparency of the card.
    disable_base_shader = false,
    shader = "anaglyphic",
    discovered = false,
    unlocked = true,
    config = {},
    in_shop = true,
    weight = 0,
    extra_cost = 10,
    apply_to_float = true,
    loc_vars = function(self, info_queue, center,a)
        local loc_mult = ' '..(localize('k_mult'))..' '
        return {
            vars = {},
            main_start = {
                {
                    n=G.UIT.T, 
                    config={
                        text = '  +',
                        colour = G.C.MULT, 
                        scale = 0.32
                    }
                },
                {
                    n=G.UIT.O, 
                    config={
                        object = DynaText({
                            string = "nil_", 
                            colours = {G.C.RED},
                            pop_in_rate = 9999999, 
                            silent = true, 
                            random_element = true, 
                            pop_delay = 0.5, 
                            scale = 0.32, 
                            min_cycle_time = 0
                        })
                        
                    }
                },
                {
                    n=G.UIT.O, 
                    config={
                        object = DynaText({
                            string = {
                                {
                                    string = "???", 
                                    colour = G.C.JOKER_GREY
                                },
                                {
                                    string = "???", 
                                    colour = G.C.RED
                                },
                            nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)]
                        },
                colours = {G.C.DARK_EDITION},
                pop_in_rate = 9999999, 
                silent = true, 
                random_element = true, 
                pop_delay = 0.2011, 
                scale = 0.32, 
                min_cycle_time = 0})}},
            }
        }
    end,
})

local oldfunc = ease_ante
ease_ante = function(num)
    local ret = oldfunc(num)
        print('hiii')
        if G.GAME.used_vouchers['v_jimb_aether'] then
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                local newcard = create_card('jimb_curses', G.jokers, nil, nil, nil, nil, nil)
                newcard:add_to_deck()
                G.consumeables:emplace(newcard)
        end
    return ret
end

--[[SMODS.Consumable {
    key = 'aether',
    set = 'Spectral',
    loc_txt = {
        name = "{C:edition}Aether{}",
        text = {
            'Spawn a random {C:red}Curse{}', 'and gain {C:dark_edition}+#1#{} Joker Slots','at the start of an Ante'
        },
    },
    config = {extra = {joker_slots = 1,}},
    pos = {x = 0, y = 0},
    soul_pos = {x = 1, y = 0},
    atlas = 'Vouchers',
    cost = 20,
    unlocked = true,
    discovered = false,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.joker_slots}}
    end,
    use = function(self, card)
        card:redeem()
    end,
    can_use = function(self,card)
        return true
    end,
    in_pool = function(self,card,wawa)
        return false
    end,
}]]

--[[SMODS.Enhancement({
    key = "armageddon",
    atlas = "Soulj",
    pos = {x = 0, y = 0},
    discovered = false,
    config = {extra = {Xmult = 1, Xmult_mod = 0.5}},
    loc_txt = {
        name = "{C:edition}Armageddon{}",
        text = {
            '{X:mult,C:white}X#1#{} Mult and increase','its value by {X:mult,C:white}X#2#{} when scored','{C:red}???{}'
        },
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card and card.ability.extra.Xmult or self.config.extra.Xmult, card and card.ability.extra.Xmult_mod or self.config.extra.Xmult_mod, }
        }
    end,
    calculate = function(self, card, context, effect)

    end
})]]


--[[SMODS.Consumable {
    key = 'armageddon',
    set = 'Spectral',
    loc_txt = {
        name = "{C:edition}Armageddon{}",
        text = {
            '{C:mult}It{} comes to your deck',
        },
    },
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 20,
    joker = true,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    can_use = function(self,card)
        return true
    end,
    use = function(self, card)
        if card.area == G.jokers then return end
        local card = copy_card(card,nil)
        card:add_to_deck()
        G.jokers:emplace(card)
        play_sound('card1', 0.8, 0.6)
        play_sound('generic1')
    end,
    calculate = function(self,card,context)
        
    end,
    in_pool = function(self,card,wawa)
        return false
    end,
}
]]

--[[SMODS.Consumable {
    key = 'wrath',
    set = 'Spectral',
    loc_txt = {
        name = "{C:edition}Wrath{}",
        text = {
            'Lower a random non-{C:dark_edition}Joker Slot',
            'stat when round ends',
            'Increase {C:dark_edition}Joker Slots{} by 1',
            'when round ends'
        },
    },
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 20,
    joker = true,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    can_use = function(self,card)
        return true
    end,
    use = function(self, card)
        if card.area == G.jokers then return end
        local card = copy_card(card,nil)
        card:add_to_deck()
        G.jokers:emplace(card)
        play_sound('card1', 0.8, 0.6)
        play_sound('generic1')
    end,
    calculate = function(self,card,context)
        
    end,
    in_pool = function(self,card,wawa)
        return false
    end,
}]]



local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    if card.ability.set == 'jimb_curses' then
        local selected_back = (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
        selected_back = get_deck_from_name(selected_back)
        if selected_back.name == "Sinner's Deck" or SMODS.find_card("j_jimb_gehenna", false) then
            if card.purified == false then
                local use = 
                {n=G.UIT.C, config={align = "cr"}, nodes={
                
                {n=G.UIT.C, config={ref_table = card, align = "cr",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = (card.area and card.area.config.type == 'joker') and 0 or 1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_use_consumeable'}, nodes={
                    {n=G.UIT.B, config = {w=0.1,h=0.6}},
                    {n=G.UIT.T, config={text = "PURIFY 20$",colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                }}
                }}

                

                local t = {
                    n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                    {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
                        {n=G.UIT.R, config={align = 'cl'}, nodes={
                        use
                        }},
                    }},
                }}

                return t
            else

                local use = 
                {n=G.UIT.C, config={align = "cr"}, nodes={}}

                

                local t = {
                    n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                    {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
                        {n=G.UIT.R, config={align = 'cl'}, nodes={
                        use
                        }},
                    }},
                }}

                return t
            end
        else
            return {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
                  {n=G.UIT.R, config={align = 'cl'}, nodes={}},
                }},
            }}
        end
    end
    if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable and card.ability.set == 'Spectral' and card.config.center.joker then
        return {
            n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.3*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_select_card'}, nodes={
                {n=G.UIT.T, config={text = localize('b_select'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
              }},
            }}
    end
	return G_UIDEF_use_and_sell_buttons_ref(card)
end




local phonebook = SMODS.Joker{
    key = 'phonebook',
    loc_txt = {
        name = "Phonebook",
        text = {
            'This Joker gains {X:mult,C:white}X#1#{} Mult','per consecutive hand with','scoring {C:attention}face card{}','{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive} Mult)'
        },
        unlock = {
            'Win a run without','scoring a face card'
        }
    },
    config = {extra = {Xmult_mod = 0.2,Xmult = 1}},
    rarity = 2,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult_mod, center.ability.extra.Xmult}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.before then
            local faces = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_face() then faces = true end
            end
            if faces == false then
                local last_mult =card.ability.extra.Xmult
                card.ability.extra.Xmult = 1
                if last_mult > 0 then 
                    return {
                        card = card,
                        message = localize('k_reset')
                    }
                end
            else
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
            end
        end
        if context.joker_main then
            return {
                card = card,
                message = localize{
                    type='variable',
                    key='a_xmult',
                    vars={card.ability.extra.Xmult}
                },
                Xmult_mod = card.ability.extra.Xmult,
            }
        end
    end,
    check_for_unlock = function(self, args)
        if args.type == 'win' and G.GAME.scoredface == 0 then
            unlock_card(self)
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

local sanitizer = SMODS.Joker{
    key = 'sanitizer',
    loc_txt = {
        name = "Hand Sanitizer",
        text = {
            '{C:blue}+#1#{} Hands, decreases','by {C:blue}#2#{} when leaving shop'
        },
        unlock = {
            'Score a hand','{X:edition,C:white}X100{} higher than','current blind requirement'
        }
    },
    config = {extra = {hands = 3, dec = 1}},
    rarity = 2,
    pos = {x = 0, y = 2},
    atlas = 'Jokers',
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.hands, center.ability.extra.dec}}
    end,
    calculate = function(self,card,context)
        if context.setting_blind then
            ease_hands_played(card.ability.extra.hands)
        end
        if context.ending_shop then
            card.ability.extra.hands = card.ability.extra.hands - card.ability.extra.dec
            if card.ability.extra.hands <= 0 then
                card:start_dissolve()
            end
        end
    end,
    check_for_unlock = function(self, args)
        if args.type == 'chip_score' then
            if G.GAME.chips >= G.GAME.blind.chips * 100 then
                unlock_card(self)
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

local pepperspray = SMODS.Joker{
    key = 'spray',
    loc_txt = {
        name = "Pepper Spray",
        text = {
            '{X:purple,C:white}X#1#{} blind size, increases','by {X:edition,C:white}#2#{} when hand played'
        },
        unlock = {
            'Score a hand','{X:edition,C:white}X100{} higher than','current blind requirement'
        }
    },
    config = {extra = {hands = 0.3, dec = 0.1}},
    rarity = 2,
    pos = {x = 1, y = 2},
    atlas = 'Jokers',
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.hands, center.ability.extra.dec}}
    end,
    calculate = function(self,card,context)
        if context.setting_blind then
            G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.hands
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
        if context.joker_main then
            card.ability.extra.hands = card.ability.extra.hands + card.ability.extra.dec
            if card.ability.extra.hands <= 1 then
                card:start_dissolve()
            end
        end
    end,
    check_for_unlock = function(self, args)
        if args.type == 'chip_score' then
            if G.GAME.chips >= G.GAME.blind.chips * 100 then
                unlock_card(self)
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}









--------CHALLENGES---------
--------CHALLENGES---------
--------CHALLENGES---------





local oldfunc = init_localization
function init_localization()
    oldfunc()
    G.localization.misc.v_text.ch_c_jimb_no_reroll = {"You cannot {C:attention}reroll"}
    G.localization.misc.v_text.ch_c_jimb_no_shop = {"{C:attention}#1# Blinds{} don't have shops"}
end

G.localization.misc.v_text.ch_c_jimb_no_reroll = {"You cannot {C:attention}reroll"}
G.localization.misc.v_text.ch_c_jimb_no_shop = {"{C:attention}#1# Blinds{} don't have shops"}

G.localization.misc.v_text.ch_c_jimb_scavenger = {"Open a {C:attention}Mega Buffoon Pack{} at end of round"}

G.localization.misc.v_text.ch_c_jimb_xCards = {"All cards have {X:dark_edition,C:white}X#1#{} to all values"}
G.localization.misc.v_text.ch_c_jimb_rocktop = {"{C:attention}#1#{} can't be higher than base {C:attention}#1#"}

SMODS.Challenge{
    key = 'shopping_spree',
    name = 'Shopping Spree',
    loc_txt = {
        name = 'Shopping Spree',
    },
    deck = { type = "Challenge Deck" },
    rules = { 
        custom = {
            {id = 'jimb_no_shop', value = 'Big'},
            {id = 'jimb_no_shop', value = 'Small'},
            {id = 'jimb_no_reroll',},
        }, 
        modifiers = {
            {id = 'joker_slots', value = 10},}
    },
    jokers = {},
    consumeables = {},
    vouchers = {
        {id = 'v_overstock_norm'},
        {id = 'v_overstock_plus'},
        {id = 'v_overstock_plus'},
        {id = 'v_overstock_plus'},
    },
    restrictions = { 
        banned_cards = {
            {id = 'v_reroll_surplus'},
            {id = 'v_reroll_glut'},
        }, 
        banned_tags = {}, 
        banned_other = {} },
}


SMODS.Challenge{
    key = 'homeless',
    name = 'Homeless Man',
    loc_txt = {
        name = 'Homeless Man',
    },
    deck = { type = "Challenge Deck" },
    rules = { 
        custom = {
            {id = 'jimb_no_shop', value = 'Boss'},
            {id = 'jimb_no_shop', value = 'Big'},
            {id = 'jimb_no_shop', value = 'Small'},
            {id = 'no_reward'},
            {id = 'no_extra_hand_money'},
            {id = 'no_interest'},
            {id = 'jimb_scavenger'}
        }, 
        modifiers = {
            {id = 'discards', value = 2},
            {id = 'hands', value = 2},
            {id = 'dollars', value = -math.exp(123,456)},
        }
    },
    jokers = {},
    consumeables = {},
    vouchers = {
        {id = 'v_wasteful'},
        {id = 'v_grabber'},
    },
    restrictions = { 
        banned_cards = {
        }, 
        banned_tags = {}, 
        banned_other = {} },
}

SMODS.Challenge{
    key = 'solorun',
    name = 'Solo Build',
    loc_txt = {
        name = 'Solo Build',
    },
    deck = { type = "Challenge Deck" },
    rules = { 
        custom = {
            {id = 'jimb_xCards', value = 10},
        }, 
        modifiers = {
            {id = 'joker_slots', value = 1},
        }
    },
    jokers = {},
    consumeables = {},
    vouchers = {
    },
    restrictions = { 
        banned_cards = {
        }, 
        banned_tags = {}, 
        banned_other = {
            {id = 'bl_final_heart', type = 'blind'},
            {id = 'bl_final_leaf', type = 'blind'},
        } },
}

--[[SMODS.Challenge{
    key = 'rocktop',
    name = 'Rock Top',
    loc_txt = {
        name = 'Rock Top',
    },
    deck = { type = "Challenge Deck" },
    rules = { 
        custom = {
            {id = 'jimb_rocktop', value = 'discards'},
            {id = 'jimb_rocktop', value = 'hands'},
            {id = 'jimb_rocktop', value = 'reroll cost'},
            {id = 'jimb_rocktop', value = 'joker slots'},
            {id = 'jimb_rocktop', value = 'consumable slots'},
            {id = 'jimb_rocktop', value = 'hand size'},
        }, 
        modifiers = {
            {id = 'discards', value = 2},
            {id = 'hands', value = 4},
            {id = 'reroll_cost', value = 6},
            {id = 'joker_slots', value = 4},
            {id = 'consumable_slots', value = 2},
            {id = 'hand_size', value = 8},
        }
    },
    jokers = {},
    consumeables = {},
    vouchers = {
    },
    restrictions = { 
        banned_cards = {
        }, 
        banned_tags = {}, 
        banned_other = {
        } },
}]]




local vipcard = SMODS.Joker{
    key = 'vipcard',
    loc_txt = {
        name = "VIP Card",
        text = {
            "{C:attention}+#1#{} cards in shop",'Decreases by {C:attention}#2#{} when', 'leaving shop'
        },
        unlock = {
            'Beat the {C:attention}Shopping Spree',
            'Challenge'
        }
    },
    config = {extra = {cards = 3,decrease = 1}},
    rarity = 2,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.cards,center.ability.extra.decrease}}
    end,
    add_to_deck = function(self,card)
        change_shop_size(card.ability.extra.cards)
    end,
    remove_from_deck = function(self,card)
        change_shop_size(-card.ability.extra.cards)
    end,
    calculate = function(self,card,context)
        if context.ending_shop then
            change_shop_size(-card.ability.extra.decrease)
            card.ability.extra.cards = card.ability.extra.cards-card.ability.extra.decrease
            if card.ability.extra.cards <= 0 then
                card:start_dissolve()
            end
        end
    end,
    check_for_unlock = function(self, args)
        for k, v in pairs(G.CHALLENGES) do
            if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed['c_jimb_shopping_spree'] then
                unlock_card(self)
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}

local shoplifter = SMODS.Joker{
    key = 'shoplifter',
    loc_txt = {
        name = "Shoplifter",
        text = {
            '{C:green}#1# in #2# chance{} for cards', 'to cost {C:money}0${}'
        },
        unlock = {
            'Beat {C:inactive}up{} the {C:attention}Homeless Man',
            'Challenge'
        }
    },
    config = {extra = {odds = 3}},
    rarity = 2,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds}}
    end,
    calculate = function(self,card,context)
        if context.jimb_creating_card then
            if pseudorandom('shoplifter') < G.GAME.probabilities.normal/card.ability.extra.odds then
                context.jimb_card.base_cost = 0
                context.jimb_card:set_cost()
                context.jimb_card.cost = 0
            end
        end
    end,
    check_for_unlock = function(self, args)
        for k, v in pairs(G.CHALLENGES) do
            if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed['c_jimb_homeless'] then
                unlock_card(self)
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}


local chef = SMODS.Joker{
    key = 'chef',
    loc_txt = {
        name = "Chef",
        text = {
            'When sold, {C:mult}debuff{} the card',
            'on the right for {C:attention}#1#{} rounds',
            '{X:dark_edition,C:white}X#2#{} values to that card'
        },
        unlock = {
            'Beat {C:attention}Solo Build{}',
            'Challenge'
        }
    },
    config = {extra = {rounds = 2, cardMult = 1.5}},
    rarity = 3,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.rounds, center.ability.extra.cardMult}}
    end,
    calculate = function(self,card,context)
        local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                other_joker = G.jokers.cards[i+1]
            end
        end
        if context.selling_self then
            if other_joker then
                jokerMult(other_joker,card.ability.extra.cardMult)
                if other_joker.jimb_roundDebuff then
                    other_joker.jimb_roundDebuff = (other_joker.jimb_roundDebuff + card.ability.extra.rounds)
                else
                    other_joker.jimb_roundDebuff = card.ability.extra.rounds
                end
            end
        end
    end,
    check_for_unlock = function(self, args)
        for k, v in pairs(G.CHALLENGES) do
            if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed['c_jimb_solorun'] then
                unlock_card(self)
            end
        end
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Jokers"] == true then
            return true
        else
            return false
        end
    end,
}


--[[local everchanging = SMODS.Joker{
    key = 'everchanging',
    loc_txt = {
        name = "Everchanging Joker",
        text = {
            "Most stats {C:attention}can't go down{}"
        },
        unlock = {
            'Beat {C:attention}Rock Top{}',
            'Challenge'
        }
    },
    rarity = 2,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    calculate = function(self,card,context)

    end,
    check_for_unlock = function(self, args)
        for k, v in pairs(G.CHALLENGES) do
            if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed['c_jimb_solorun'] then
                unlock_card(self)
            end
        end
    end
}]]






if Cryptid then


    local grand_design = SMODS.Joker{
        key = 'granddesign',
        loc_txt = {
            name = "Grand Design",
            text = {
                "{C:green,E:1,S:1.1}#2# in #1#{} chance to","Copy the ability", "of every Joker",
            }
        },
        cursed = true,
        config = {extra = {odds = 4}},
        rarity = "cry_epic",
        pos = {x = 0, y = 0},--CHANGE THIS
        atlas = 'Mega',--CHANGE THIS
        cost = 12,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            return {vars = {center.ability.extra.odds,G.GAME.probabilities.normal}}
        end,
        calculate = function(self,card2,context)
            local totalret = nil
            local eligibleJokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name ~= card2.ability.name then eligibleJokers[#eligibleJokers+1] = G.jokers.cards[i] end
            end
            
            for i = 1, #eligibleJokers do
                if pseudorandom('granddesign') < G.GAME.probabilities.normal/card2.ability.extra.odds then
                    v = eligibleJokers[i]
                    local ret = v:calculate_joker(context)
                    if ret and type(ret) == 'table' then
                        totalret = totalret or {message = "Copying", card = card2}
                        for _i,_v in pairs(ret) do
                            if not totalret[_i] then
                                totalret[_i] = ret[_i] or _v
                                --print(totalret[_i] .. "--------------")
                            else
                                if type(totalret[_i]) == 'number' then
                                    totalret[_i] = totalret[_i] + ret[_i]
                                end
                            end
                        end
                        totalret.card = card2
                    end
                end
            end
            return totalret
        end,
        in_pool = function(self,wawa,wawa2)
            if jimbomod.config["Jokers"] == true then
                return true
            else
                return false
            end
        end,
    }


    local gehenna = SMODS.Joker{
        key = 'gehenna',
        loc_txt = {
            name = "Gehenna",
            text = {
                "Create {C:red}#1# random Curses{} at end of round",
                "You can {C:attention}purify{} {C:red}Curses{} manually",
                "When a {C:red}Curse{} is {C:attention}purified{}, destroy it and",
                "give {X:dark_edition,C:white}X#2#{} values to a random {C:attention}Joker",
                '{C:inactive}Excludes other {C:attention}Gehenna{}'
            }
        },
        config = {extra = {curses = 2, cardMult = 2}},
        rarity = "cry_exotic",
        pos = {x = 2, y = 1},
        atlas = 'Soulj',
        cost = 50,
        unlocked = true,
        discovered = false,
        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            return {vars = {center.ability.extra.curses,center.ability.extra.cardMult}}
        end,
        calculate = function(self, card, context)
            if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
                for i = 1, math.min(card.ability.extra.curses,10) do
                    local newcard = create_card('jimb_curses', G.jokers, nil, nil, nil, nil, nil)
                    newcard:add_to_deck()
                    G.consumeables:emplace(newcard)
                end
            end
            if context.jimb_purify then
                context.card:start_dissolve()
                local eligibleJokers = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].ability.name ~= card.ability.name and G.jokers.cards[i] ~= context.card then eligibleJokers[#eligibleJokers+1] = G.jokers.cards[i] end
                end
                jokerMult(pseudorandom_element(eligibleJokers,pseudoseed('gehenna')), card.ability.extra.cardMult)
            end
        end,
        in_pool = function(self,wawa,wawa2)
            if jimbomod.config["Curses"] == true and jimbomod.config["Jokers"] == true then
                return true
            else
                return false
            end
            
        end,
    }
    

end

if Reverie then
    SMODS.Atlas({key = 'Cine', path = 'cines.png', px = 71, py = 95})
    local exch_prism = SMODS.Consumable {
        key = 'prism_exchange',
        set = 'Cine',
        loc_txt = {
            name = "Exchange Coupon",
                text = {
                    "Converts to {C:cine}Neon Prism{} after",
                    "selling atleast {C:attention}#1#{} {C:legendary}Modded Jokers{}",
                    "{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)"
                }
        },
        config = {extra = {goal = 5, current = 0}},
        pos = { x = 0, y = 0 },
        cost = 6,
        unlocked = true,
        reward = 'c_jimb_prism',
        discovered = false,
        atlas = 'Cine',
        loc_vars = function(self, info_queue, center)
            return {vars = {center.ability.extra.goal,(center.ability.progress or 0)}}
        end,
        can_use = function(self, card)
            if card.ability.extra.goal <= (card.ability.progress or 0) then 
                return true
            end
            return false
        end,
    }

    local prism = SMODS.Consumable {
        key = 'prism',
        set = 'Cine',
        loc_txt = {
            name = "Neon Prism",
                text = {
                    "During this shop,",
                    "all Jokers gained have {X:dark_edition,C:white}X#1#{} values",
                    "{C:red}+$#2#{} reroll cost"
                }
        },
        config = {extra = {values = 2}},
        pos = { x = 0, y = 1 },
        cost = 6,
        unlocked = true,
        discovered = false,
        atlas = 'Cine',
        loc_vars = function(self, info_queue, center)
            return {vars = {center.ability.extra.values,center.ability.extra.values*5}}
        end,
        can_use = function(wawa,wawa,wawa)
            if G.shop_jokers then
                return true
            else
                return false
            end
        end,
        use = function(self,card)
            if G.GAME.jimb_prism then
                G.GAME.jimb_prism = G.GAME.jimb_prism * card.ability.extra.values
            else
                G.GAME.jimb_prism = card.ability.extra.values
            end
            calculate_reroll_cost(true)
        end
    }
    prism.use = Reverie.use_cine

    local calculate_reroll_cost_ref = calculate_reroll_cost
    function calculate_reroll_cost(skip_increment)
        calculate_reroll_cost_ref(skip_increment)
        if G.GAME.jimb_prism then
            G.GAME.current_round.reroll_cost = G.GAME.current_round.reroll_cost + G.GAME.jimb_prism*5
        end
    end
end
local oldfunc = Card.use_consumeable
function Card:use_consumeable(area, copier)
    if self.ability.set == 'jimb_curses' then
        if self and self.purified ~= nil and self.purified == false then
            self.purified = true
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({jimb_purify = true, card = self,})
            end
            ease_dollars(-20)
        end
        return
    end
    local is_reverie = self.ability.name == "Reverie"
    if (is_reverie) then
        if G.GAME.jimb_prism then
            G.GAME.jimb_prism = G.GAME.jimb_prism * 2
        else
            G.GAME.jimb_prism = 2
        end
        calculate_reroll_cost(true)
    end
    local ret = oldfunc(self,center,card,area,copier)
    return ret
end

local oldfunc = Card.can_use_consumeable
function Card:can_use_consumeable(any_state, skip_check)
    if self.ability.set == 'jimb_curses' and G.GAME.dollars >= 20 then
        return true
    end
    local ret = oldfunc(self,any_state,skip_check)
    return ret
end





--------------------DECKS--------------------
--------------------DECKS--------------------
--------------------DECKS--------------------

--local ordered_names = {}

SMODS.Atlas{
    key = "Decks",
    path = "Decks.png",
    px = 71,
    py = 95
}

function jokerMult(card,mult,operation)
    if not card then return end
    if not mult then mult = 1.5 end
    if not operation then operation = operationfuncs[1] end
    for k,v in pairs(card.ability) do
        if k ~= 'x_mult' and k ~= 'order' and type(v) == 'number' then
            card.ability[k] = operation(v,mult) or operation(card.ability[k],mult)
        end
        if k == 'x_mult' and v ~= 1 then
            card.ability[k] = operation(v,mult) or operation(card.ability[k],mult)
        end
    end
    if not card.ability.extra then return end
    --if type(card.ability.extra) == 'number' then card.ability.extra = card.ability.extra*mult end
    if type(card.ability.extra) == 'table' then
        for i,v in pairs(card.ability.extra) do
            
            if type(card.ability.extra[i]) == 'number' then card.ability.extra[i] = operation(v,mult) or operation(card.ability.extra[i],mult) end
        end
    end
end




local neondeck = SMODS.Back{
    key = "neon",
    name = "Neon Deck",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "Neon Deck",
        text = {
        "Switch between two joker",
        "slots at the end of round",
        "{X:dark_edition,C:white}X#1#{} card values"
        }
    },
    config = {
        extra = {
            jokers = {}, 
            jokers2 = {},
            mult = 1.5,
        }
    },
    atlas = "Decks",
    loc_vars = function(self)
        return { vars = {self.config.extra.mult} }
    end
}
local configs = neondeck.config.extra
neondeck.trigger_effect = function(self,args)
    if not args then return end
    
    if args.context == "jimb_card" then jokerMult(args.card,self.config.extra.mult) end

    if args.context == 'eval' then
        --[[configs.jokers2 = G.jokers.cards

        G.jokers.cards = {}
        for i = 1, #configs.jokers do
            configs.jokers[i]:add_to_deck()
            configs.jokers[i]:start_materialize({G.C.DARK_EDITION}, nil, 5)
            G.jokers:emplace(configs.jokers[i])
        end

        G.jokers.cards = configs.jokers
        configs.jokers = configs.jokers2]]

        --G.GAME.neonJokers2 = G.jokers.cards
        G.GAME.neonJokers2 = {}
        for i = 1, #G.jokers.cards do
            G.GAME.neonJokers2[#G.GAME.neonJokers2+1] = {}
            G.GAME.neonJokers2[#G.GAME.neonJokers2].key = G.jokers.cards[i].config.center.key
            G.GAME.neonJokers2[#G.GAME.neonJokers2].ability = G.jokers.cards[i].ability
            G.jokers.cards[i]:remove_from_deck()
        end
        G.GAME.neonJokers = G.GAME.neonJokers or {}


        G.jokers.cards = {}
        for i = 1, #G.GAME.neonJokers do
            local card = create_card('Joker', G.jokers, nil, nil, nil, nil, G.GAME.neonJokers[i].key)
            card.ability = G.GAME.neonJokers[i].ability
            card.ability.isDuped = true

            --G.GAME.neonJokers[i]:add_to_deck()
            --G.GAME.neonJokers[i]:start_materialize({G.C.DARK_EDITION}, nil, 5)
            G.jokers:emplace(card)
            card:add_to_deck()
            card:start_materialize({G.C.DARK_EDITION}, nil, 5)
        end

        --G.jokers.cards = G.GAME.neonJokers
        G.GAME.neonJokers = G.GAME.neonJokers2
    end

end

local CAI = {
    discard_W = G.CARD_W,
    discard_H = G.CARD_H,
    deck_W = G.CARD_W*1.1,
    deck_H = 0.95*G.CARD_H,
    hand_W = 6*G.CARD_W,
    hand_H = 0.95*G.CARD_H,
    play_W = 5.3*G.CARD_W,
    play_H = 0.95*G.CARD_H,
    joker_W = 4.9*G.CARD_W,
    joker_H = 0.95*G.CARD_H,
    consumeable_W = 2.3*G.CARD_W,
    consumeable_H = 0.95*G.CARD_H
}



local plantdeck = SMODS.Back{
    key = "planted",
    name = "Planted Deck",
    unlocked = false,
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "Planted Deck",
        text = {
        "Every run uses only one seed",
        "Seed changes every 10 runs",
        },
        unlock = {
            'Win a seeded',
            'run',
        }
    },
    config = {
        extra = {
            seed = nil, 
            runs = 10,
            isActive = false
        }
    },
    atlas = "Decks",
    check_for_unlock = function(self, args)
        if args.type == 'win_seeded' and args.isSeeded then
            unlock_card(self)
        end
    end
}

local oldfunc = win_game
win_game = function()
    if G.GAME.seeded then
        check_for_unlock({type = 'win_seeded'})
    end
    local ret = oldfunc()
    return ret
end

local plantDeckLock = check_for_unlock
check_for_unlock = function(args)
    if args.type == 'win_seeded' then
        args.isSeeded = true
        G.GAME.seeded = nil
    end
    local ret = plantDeckLock(args)
    if args.isSeeded then
        G.GAME.seeded = true
    end
    return ret
end



local archeologist = SMODS.Back{
    key = "archeologist",
    name = "Archeologist Deck",
    pos = {x = 0, y = 0},
    unlocked = false,
    loc_txt = {
        name = "Archeologist Deck",
        text = {
        "Start at {C:attention}Ante #1#{}",
        "{C:mult}#2#{} discards"
        },
        unlock = {
            'Reach {C:attention}Ante 0{}',
        }

    },
    config = {
        extra = {
            ante = -1,
            discards = -1
        }
    },
    atlas = "Decks",
    apply = function(back) 
        ease_ante(back.config.extra.ante-1)
        --G.GAME.round_resets.ante = back.config.extra.ante
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - back.config.extra.discards
    end,
    loc_vars = function(self)
        return { vars = {self.config.extra.ante,self.config.extra.discards} }
    end,
    check_for_unlock = function(self,args)
        if args.type == 'ante_up' then
            if args.ante <= 0 then
                unlock_card(self)
            end
        end
    end
}
if jimbomod.config.Curses == true then
    local sindeck = SMODS.Back{
        key = "sin",
        name = "Sinner's Deck",
        pos = {x = 0, y = 0},
        loc_txt = {
            name = "Sinner's Deck",
            text = {
            "Create a random {C:red}Curse{}",
            "after defeating {C:attention}Boss Blind",
            'You can {C:attention}purify{} {C:red}Curses{}'
            }
        },
        atlas = "Decks",
        trigger_effect = function(self,args)
            if not args then return end
            if args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
                local newcard = create_card('jimb_curses', G.jokers, nil, nil, nil, nil, nil)
                newcard:add_to_deck()
                G.consumeables:emplace(newcard)
            end
        end
    }
end

local blindtype = 'Small'
local oldfunc = end_round
end_round = function()
    local ret = oldfunc()
    blindtype = G.GAME.blind.name
    if blindtype ~= 'Small Blind' and blindtype ~= 'Big Blind' then blindtype = 'Boss Blind' end
    if G.GAME.modifiers.jimb_scavenger then
        add_tag(Tag('tag_buffoon'))
    end
    return ret
end

local oldfunc = G.FUNCS.cash_out
G.FUNCS.cash_out = function(e)
    local ret = oldfunc(e)
    G.GAME.jimb_prism = nil

    if G.GAME.modifiers and G.GAME.modifiers.jimb_no_shops then
        --for k,v in pairs(G.GAME.modifiers.jimb_jimb_no_shops) do print(k .. '   ?') end
        for k,v in pairs(G.GAME.modifiers.jimb_no_shops) do
            if blindtype == k .. ' Blind' then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                    G.STATE_COMPLETE = false
                    G.STATE = G.STATES.BLIND_SELECT
                    G.CONTROLLER.locks.toggle_shop = nil
                    return true
                    end
                }))

                return
            end
        end
        
    end
    return ret
end
if G.UIDEF.shop then
    local oldfunc = G.UIDEF.shop
    G.UIDEF.shop = function(self)
        --local ret = oldfunc()
        if G.GAME.modifiers and G.GAME.modifiers.jimb_no_shops then
            --for k,v in pairs(G.GAME.modifiers.jimb_jimb_no_shops) do print(k .. '   ?') end
            for k,v in pairs(G.GAME.modifiers.jimb_no_shops) do
                if blindtype == k .. ' Blind' then
                    return {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={}}
                end
            end
            
        end
        local ret = oldfunc(self)
        return ret
    end
end

local oldfunc = G.FUNCS.can_reroll
G.FUNCS.can_reroll = function(e)
    local ret = oldfunc(e)
    if G.GAME.modifiers.jimb_no_reroll then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
    return ret
  end


local oldfunc = Game.start_run
Game.start_run = function(e, args)
    --PRE hook
    local selected_back = saveTable and saveTable.BACK.name or (args.challenge and args.challenge.deck and args.challenge.deck.type) or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
    selected_back = get_deck_from_name(selected_back)
    if selected_back.name == "Planted Deck" then
        if plantdeck.config.extra.runs == 10 then
            plantdeck.config.extra.seed = generate_starting_seed()
            plantdeck.config.extra.runs = 0
        end
        plantdeck.config.extra.runs = plantdeck.config.extra.runs + 1
        args.seed = G.run_setup_seed and G.setup_seed or G.forced_seed or plantdeck.config.extra.seed or 'RTGAME'
    end
    local ret = oldfunc(e,args)
    if selected_back.name == "Planted Deck" then
        G.GAME.seeded = false
    end
    ease_ante(0)

    if args.challenge then
        G.GAME.challenge = args.challenge.id
        G.GAME.challenge_tab = args.challenge
        local _ch = args.challenge
        if _ch.rules then
            if _ch.rules.custom then
                for k, v in ipairs(_ch.rules.custom) do
                    if v.id == 'jimb_no_shop' then 
                        G.GAME.modifiers.jimb_no_shops = G.GAME.modifiers.jimb_no_shops or {}
                        G.GAME.modifiers.jimb_no_shops[v.value] = true
                        --G.GAME.modifiers.jimb_jimb_no_shops.test_val = 'hi'
                        --G.GAME.modifiers.jimb_jimb_no_shops.test_val2 = 'hello'
                        --G.GAME.modifiers.jimb_jimb_no_shops[v.value] = true
                    end
                    if v.id == 'xCards' then 
                        G.GAME.modifiers.jimb_xCards = v.value
                    end
                    if v.id == 'jimb_no_reroll' then
                        G.GAME.modifiers.jimb_no_reroll = true
                    end
                    if v.id == 'jimb_scavenger' then
                        G.GAME.modifiers.jimb_scavenger = true
                    end
                end
            end
        end
    end
    G.GAME.scoredface = 0
    G.GAME.next_Gen_Cards = G.GAME.next_Gen_Cards or {
        --{key = 'j_joker',ability = nil},
    }
    G.GAME.cardsGained = G.GAME.cardsGained or {
        --{key = 'j_joker',ability = nil},
    }
    G.GAME.cerberusMult = G.GAME.cerberusMult or 0
    G.GAME.aetherval = G.GAME.aetherval or 0
    return ret
end

local oldfunc = eval_card
function eval_card(card, context)
    local ret = oldfunc(card,context)
    if context.cardarea == G.play then
        G.GAME.scoredface = G.GAME.scoredface + 1
    end
    G.GAME.blind:jimb_cardScore(card,context)
    return ret
end


local oldfunc = Card.set_ability
Card.set_ability = function(self,a,b,c)
    local ret = oldfunc(self,a,b,c)

    self:ability_change(self,self)
    return ret
end

function Card:ability_change(self)
    if G.GAME.selected_back then G.GAME.selected_back:trigger_effect{context = 'jimb_card', card = self} end
    if G and G.jokers and G.jokers.cards then
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({jimb_creating_card = true, jimb_card = self})
        end
    end
    if G.GAME.modifiers.jimb_xCards then 
        jokerMult(self,G.GAME.modifiers.jimb_xCards)
    end

    if G.GAME.round_resets.blind_choices and G.GAME.round_resets.blind_choices.Boss and G.GAME.round_resets.blind_choices.Boss == 'bl_jimb_zone' then
        jokerMult(self,0.75)
    end
end

local oldfunc = get_next_voucher_key
function get_next_voucher_key()
    local ret =oldfunc()
    if jimbomod.config["Special Spectrals"] == true then
        if pseudorandom('_'.."Voucher"..G.GAME.round_resets.ante) > 0.994 and not G.GAME.used_vouchers['v_jimb_aether'] then
            ret = 'v_jimb_aether'
        end
    end
    return ret
end

--[[local oldfunc = G.FUNCS.buy_from_shop
function G.FUNCS.buy_from_shop(e)
    local ret = oldfunc(e)
    local c1 = e.config.ref_table
    if c1 and c1:is(Card) then
        for i = 1, #spectralvouchers do
            if spectralvouchers[i] == c1.config.center.key then
                c1:redeem()
                c1:start_dissolve()
            end
        end
    end
    return ret
end]]

local oldfunc = create_card
create_card = function(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if jimbomod.config["Special Spectrals"] == true then
        if not forced_key and soulable and (not G.GAME.banned_keys[randSpectral]) then
            if (_type == 'Joker') and
            not (G.GAME.used_jokers[randSpectral] and not next(find_joker("Showman")))  then
                if pseudorandom('_'.._type..G.GAME.round_resets.ante) > 0.998 then
                    forced_key = 'j_jimb_amalgam'
                end
            end
        end



    end


    --if ouroborosActive then
    --    forced_key = 'j_jimb_ouroboros'
    --end
    if G.GAME.next_Gen_Cards and #G.GAME.next_Gen_Cards ~= 0 and _type ~= 'Base' then
        forced_key = G.GAME.next_Gen_Cards[1].key
    end
    
    
    --end
    local ret = oldfunc(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)

    if G.GAME.next_Gen_Cards and #G.GAME.next_Gen_Cards ~= 0 then

        if G.GAME.next_Gen_Cards[1].specType and G.GAME.next_Gen_Cards[1].specType ~= _type then
            return ret
        end

        if forced_key and forced_key == G.GAME.next_Gen_Cards[1].key and _type ~= 'Base' then
            if G.GAME.next_Gen_Cards[1].ability then ret.ability = G.GAME.next_Gen_Cards[1].ability end
        end

        if G.GAME.next_Gen_Cards[1].cost then
            ret.base_cost = G.GAME.next_Gen_Cards[1].cost
        end
        ret:set_cost()

        if G.GAME.next_Gen_Cards[1].abilityMult then
            jokerMult(ret,G.GAME.next_Gen_Cards[1].abilityMult)
        end
        table.remove(G.GAME.next_Gen_Cards,1)
    end

    --POST hook
    --[[local selected_back = saveTable and saveTable.BACK.name or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
    selected_back = get_deck_from_name(selected_back)
    if selected_back.name == "Neon Deck" then
        jokerMult(ret,selected_back.config.mult)
    end]]
    return ret
end

local oldfunc = Card.set_edition
Card.set_edition = function(self,a,b,c)
    if not a and pseudorandom('_'.."Edition"..G.GAME.round_resets.ante) > 0.999 and self.ability.set == 'Joker' then
        a = {jimb_nil_ = true}
    end
    local ret = oldfunc(self,a,b,c)
    if (self.edition and (self.edition["jimb_anaglyphic"])) then
        jokerMult(self,1.5)
    end
    if (self.edition and (self.edition['jimb_nil_'])) then
            jokerMult(self,math.random(-125,325)/100, operationfuncs[math.random(1,#operationfuncs)])
    end
    if (not (self.edition)) and G and G.jokers then
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].edition and G.jokers.cards[i].edition.jimb_nil_ then
                return self:set_edition({jimb_nil_ = true},true)
            end
        end
    end
    return ret
end


--[[local oldfunc = generate_card_ui
generate_card_ui = function(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)

    local ret = oldfunc(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    --if card and card.ability and card.ability.name == "j_jimb_finger" and full_UI_table then
    --    full_UI_table.name = "Balls!!"
    --end
    if full_UI_table and card and card.ability and card.ability.pure then
        local conf = full_UI_table.name[1].config.object.config
        conf.string[1] = card.ability.extra
        full_UI_table.name[1].config.object:remove()
        full_UI_table.name[1].config.object = DynaText(conf)
    end
    return ret
end]]




if CardSleeves then
    CardSleeves.Sleeve {
        key = "jimb_neon",
        name = "Neon Sleeve",
        atlas = "Jokers",
        pos = { x = 0-1, y = 0 },
        config = { jokers = {}, jokers2 = {}, mult = 1.5 },
        loc_txt = {
            name = "Neon Sleeve",
            text = {
            "Switch between two joker",
            "slots at the end of round",
            "{X:dark_edition,C:white}X#1#{} to all card's values"
            }
        },
        unlocked = true,
        unlock_condition = { deck = "Neon Deck", stake = 1 },
        loc_vars = function(self)
            return { vars = {self.config.mult} }
        end,
        trigger_effect = function(self,args)
            if not args then return end
            if args.context == 'eval' then
                if G.GAME.blind and G.GAME.blind.chips and to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) then
                    configs.jokers2 = G.jokers.cards

                    G.jokers.cards = {}
                    for i = 1, #configs.jokers do
                        configs.jokers[i]:add_to_deck()
                        configs.jokers[i]:start_materialize({G.C.DARK_EDITION}, nil, 5)
                        G.jokers:emplace(configs.jokers[i])
                    end

                    G.jokers.cards = configs.jokers
                    configs.jokers = configs.jokers2

                    return true

                end
            end
            if args.context.newcard then
                --print(args.context.newcard.ability.name)
                jokerMult(args.context.newcard,self.config.mult)
            end
        end,
    }
end



--------------------EDITIONS--------------------
--------------------EDITIONS--------------------
--------------------EDITIONS--------------------

SMODS.Shader({ key = 'anaglyphic', path = 'anaglyphic.fs' })
SMODS.Shader({ key = 'flipped', path = 'flipped.fs' })
SMODS.Shader({ key = 'fluorescent', path = 'fluorescent.fs' })
-- SMODS.Shader({key = 'gilded', path = 'gilded.fs'})
SMODS.Shader({ key = 'greyscale', path = 'greyscale.fs' })
-- SMODS.Shader({key = 'ionized', path = 'ionized.fs'})
-- SMODS.Shader({key = 'laminated', path = 'laminated.fs'})
-- SMODS.Shader({key = 'monochrome', path = 'monochrome.fs'})
SMODS.Shader({ key = 'overexposed', path = 'overexposed.fs' })
-- SMODS.Shader({key = 'sepia', path = 'sepia.fs'})

--[[SMODS.Edition({
    key = "flipped",
    loc_txt = {
        name = "Flipped",
        label = "Flipped",
        text = {
            "nothin"
        }
    },
    -- Stop shadow from being rendered under the card
    disable_shadow = true,
    -- Stop extra layer from being rendered below the card.
    -- For edition that modify shape or transparency of the card.
    disable_base_shader = true,
    shader = "flipped",
    discovered = false,
    unlocked = true,
    config = {},
    in_shop = true,
    weight = 8,
    extra_cost = 6,
    apply_to_float = true,
    loc_vars = function(self)
        return { vars = {} }
    end
})]]
SMODS.Edition({
    key = "anaglyphic",
    loc_txt = {
        name = "Anaglyphic",
        label = "Anaglyphic",
        text = {
            "{X:dark_edition,C:white}X1.5{} values"
        }
    },
    -- Stop shadow from being rendered under the card
    disable_shadow = false,
    -- Stop extra layer from being rendered below the card.
    -- For edition that modify shape or transparency of the card.
    disable_base_shader = false,
    shader = "anaglyphic",
    discovered = false,
    unlocked = true,
    config = {},
    in_shop = true,
    weight = 2,
    extra_cost = 6,
    apply_to_float = true,
    loc_vars = function(self)
        return { vars = {} }
    end,
})

--[[SMODS.Edition({
    key = "projected",
    loc_txt = {
        name = "Projected",
        label = "Projected",
        text = {
            "Copies the abilities", "of the card", "on the left"
        }
    },
    -- Stop shadow from being rendered under the card
    disable_shadow = false,
    -- Stop extra layer from being rendered below the card.
    -- For edition that modify shape or transparency of the card.
    disable_base_shader = false,
    shader = "anaglyphic",
    discovered = false,
    unlocked = true,
    config = {},
    in_shop = true,
    weight = 5,
    extra_cost = 6,
    apply_to_float = true,
    loc_vars = function(self)
        return { vars = {} }
    end,
})]]



--------------------BLINDS---------------------
--------------------BLINDS---------------------
--------------------BLINDS---------------------
local oldfunc = get_new_boss
function get_new_boss()
    --[[local isCalm = false
    if G.GAME.round_resets.blind_choices and G.GAME.round_resets.blind_choices.Boss then
        if G.GAME.round_resets.blind_choices.Boss == 'bl_jimb_calm' then
            isCalm = true
        end
    end]]

    local ret = oldfunc()
    G.GAME.round_resets.blind_choices.Small = 'bl_small'
    G.GAME.round_resets.blind_choices.Big = 'bl_big'
    --if G.GAME.round_resets.ante == 8 then
    --end
    if ret == 'bl_jimb_cerberus3' then
        G.GAME.round_resets.blind_choices.Small = 'bl_jimb_cerberus1'
        G.GAME.round_resets.blind_choices.Big = 'bl_jimb_cerberus2'
        --reset_blinds()
        --G.GAME.round_resets.blind_choices.Boss = 'bl_jimb_calm'
        return 'bl_jimb_cerberus3'
    end
    --[[if isCalm == true then
        G.GAME.round_resets.blind_choices.Small = 'bl_jimb_storm'
        G.GAME.round_resets.blind_choices.Big = 'bl_jimb_storm'
        G.GAME.round_resets.blind_states = {Small = 'Upcoming', Big = 'Upcoming', Boss = 'Select'}
        return 'bl_jimb_storm'
    end]]
    --if ret == 'bl_jimb_storm' then return get_new_boss() end
    return ret
end


function Blind:jimb_cardScore(card,context)
    if context.cardarea == G.play then
        if G.GAME.blind.name == 'bl_jimb_cerberus1' then
            --G.GAME.blind.chips = G.GAME.blind.chips + G.GAME.starting_params.ante_scaling*(self.mult*0.01)
            --for k,v in pairs(G.P_BLINDS[G.GAME.round_resets.blind_choices]) do
                --G.P_BLINDS[G.GAME.round_resets.blind_choices][k].chips = G.P_BLINDS[G.GAME.round_resets.blind_choices][k].chips + G.GAME.starting_params.ante_scaling*(G.P_BLINDS[G.GAME.round_resets.blind_choices][k].mult*0.01)
            --end
            G.GAME.blind.chips = G.GAME.blind.chips + G.GAME.starting_params.ante_scaling*0.01
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.GAME.cerberusMult = G.GAME.cerberusMult + 0.01
            G.GAME.blind:juice_up()
        end
        if G.GAME.blind.name == 'bl_jimb_cerberus2' then
            --for k,v in pairs(G.GAME.round_resets.blind_choices) do
            --    G.GAME.round_resets.blind_choices[k].chips = G.GAME.round_resets.blind_choices[k].chips + G.GAME.starting_params.ante_scaling*(self.mult*0.02)
            --end
            G.GAME.blind.chips = G.GAME.blind.chips + G.GAME.starting_params.ante_scaling*1.5*0.02
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.GAME.cerberusMult = G.GAME.cerberusMult + 0.02
            G.GAME.blind:juice_up()
        end
        if G.GAME.blind.name == 'bl_jimb_cerberus3' then
            --for k,v in pairs(G.P_BLINDS[G.GAME.round_resets.blind_choices]) do
            --    G.P_BLINDS[G.GAME.round_resets.blind_choices][k].chips = G.P_BLINDS[G.GAME.round_resets.blind_choices][k].chips + G.GAME.starting_params.ante_scaling*(G.P_BLINDS[G.GAME.round_resets.blind_choices][k].mult*0.04)
            --end
            G.GAME.blind.chips = G.GAME.blind.chips + G.GAME.starting_params.ante_scaling*2*0.04
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.GAME.blind:juice_up()
        end
    end
end


local royal_hand = SMODS.Blind{
    key = "royal_hand",
    loc_txt = {
 		name = 'Royal Hand',
 		text = { '+3 Hands, +1.5X score', 'requirement per hand' },
 	},
    boss_colour = HEX('015482'),
    dollars = 5,
    mult = 2,
    discovered = false,
    has_played = false,
    boss = {
        min = 0,
        max = 10,
        showdown = true
    },
    pos = { x = 0, y = 30 },
    set_blind = function(self)
        G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*2*((G.GAME.current_round.hands_left + 4)*1.5)
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        ease_hands_played(3)
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Boss Blinds"] == true then
            return true
        else
            return false
        end
    end,
}

local zone = SMODS.Blind{
    key = "zone",
    loc_txt = {
 		name = 'The Zone',
 		text = { 'Cards created this Ante','have 0.75X values' },
 	},
    boss_colour = HEX('967BB6'),
    dollars = 5,
    mult = 2,
    discovered = false,
    has_played = false,
    boss = {
        min = 3,
        max = 69420,
        showdown = false
    },
    pos = { x = 0, y = 30 },
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Boss Blinds"] == true then
            return true
        else
            return false
        end
    end,
}

function Card:jimb_get_order()
    if self.ability.set ~= "Joker" then return 0 end
    local num = 0
    for i,v in pairs(G.P_CENTER_POOLS['Joker']) do
        num = num + 1
        if G.P_CENTER_POOLS['Joker'][i].key == self.config.center.key then
            return num
        end
    end
end

local vintage = SMODS.Blind{
    key = "vintage_vanilla",
    loc_txt = {
 		name = 'Vintage Vanilla',
 		text = { '1 in 3 chance for', ' vanilla Jokers to be debuffed' },
 	},
    boss_colour = HEX('F3E5AB'),
    dollars = 5,
    mult = 2,
    config = {jokers = {}},
    discovered = false,
    has_played = false,
    boss = {
        min = 0,
        max = 10,
        showdown = true
    },
    pos = { x = 0, y = 30 },
    recalc_debuff = function(self, card, from_blind)
		--[[if card.ability.set == 'Joker' then
            local num = 0
            for i,v in pairs(G.P_CENTER_POOLS['Joker']) do
                num = num + 1
                if G.P_CENTER_POOLS['Joker'][i].key == card.config.center.key and num < 150 and pseudorandom('vintage') < 1/3 then
                    return true
                end
            end
        end]]
        if card.ability.set == 'Joker' and card:jimb_get_order() < 150 and pseudorandom('vintage') < 1/3 then
            return true
        end
        return false
	end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Boss Blinds"] == true then
            return true
        else
            return false
        end
    end,
}

local luckylady = SMODS.Blind{
    key = "lady_luck",
    loc_txt = {
 		name = 'Lady Luck',
 		text = { '1 in 10 chance for a card', ' to be debuffed'},
 	},
    boss_colour = HEX('0C9E5A'),
    dollars = 5,
    mult = 2,
    discovered = false,
    has_played = false,
    boss = {
        min = 0,
        max = 10,
        showdown = true
    },
    pos = { x = 0, y = 30 },
    recalc_debuff = function(self, card, from_blind)
        if pseudorandom('ladyluck') < 1/2 then
            return true
        end
        return false
	end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Boss Blinds"] == true then
            return true
        else
            return false
        end
    end,
}

local cerberus = SMODS.Blind{
    key = "cerberus1",
    loc_txt = {
        name = 'Silver Cerberus',
        text = { 
            "All blinds gain",
            "0.01X base blind size",
            "when a card scores"
       },
    },
    boss_colour = HEX('4F6367'),
    dollars = 3,
    mult = 1,
    discovered = false,
    has_played = false,
    boss = {
        min = 69420,
        max = 69420,
        showdown = true
    },
    pos = { x = 0, y = 30 },
    in_pool = function(self,wawa,wawa2)
        return false
    end
}

local cerberus2 = SMODS.Blind{
    key = "cerberus2",
    loc_txt = {
        name = 'Dusk Cerberus',
        text = { 
            "All blinds gain",
            "0.02X base blind size",
            "when a card scores"
       },
    },
    boss_colour = HEX('4F6367'),
    dollars = 4,
    mult = 1.5,
    discovered = false,
    has_played = false,
    boss = {
        min = 69420,
        max = 69420,
        showdown = true
    },
    pos = { x = 0, y = 30 },
    in_pool = function(self,wawa,wawa2)
        return false
    end,
    set_blind = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips + get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*1.5*G.GAME.cerberusMult
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end,
}

local cerberus3 = SMODS.Blind{
    key = "cerberus3",
    loc_txt = {
 		name = 'Raven Cerberus',
 		text = { 
            "All blinds gain",
            "0.04X base blind size",
            "when a card scores"
       },
 	},
    boss_colour = HEX('4F6367'),
    dollars = 5,
    mult = 2,
    discovered = false,
    has_played = false,
    boss = {
        min = 69420,
        max = 69420,
        showdown = true
    },
    pos = { x = 0, y = 30 },
    set_blind = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips + get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*1.5*G.GAME.cerberusMult
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end,
    defeat = function(self)
        G.GAME.cerberusMult = 0
    end,
    in_pool = function(self,wawa,wawa2)
        if jimbomod.config["Boss Blinds"] == true then
            return true
        else
            return false
        end
    end,
}

SMODS.Achievement{
    loc_txt = {
        name = "Do It All Again",
        description = "Win a run with Planted Deck",
    },
    key = 'plant_win',
    unlock_condition = function(self,args)

    end,
}

local oldfunc = Game.main_menu
	Game.main_menu = function(change_context)
        --G.C.CRY_EXOTIC = HEX('764426')
		local ret = oldfunc(change_context)
        --G.C.CRY_EXOTIC = HEX('764426')
        G.title_top.cards[1]:set_ability(G.P_CENTERS.j_joker, true)
        G.title_top.cards[1].children.front = nil
        G.title_top.cards[1]:set_sprites(G.P_CENTERS.j_joker)
		check_for_unlock({type = 'run_started'})
        --[[G.C.AUTUMN_FEEL = HEX('764426')
        G.C.AUTUMN_TOUCH = HEX('A37254')
        G.SPLASH_BACK:define_draw_steps({{
			shader = 'splash',
			send = {
				{name = 'time', ref_table = G.TIMERS, ref_value = 'REAL_SHADER'},
				{name = 'vort_speed', val = 0.4},
				{name = 'colour_1', ref_table = G.C, ref_value = 'BLUE'},
				{name = 'colour_2', ref_table = G.C, ref_value = 'GREEN'},
			}}})]]
		return ret
	end

--[[local oldfunc = ease_background_colour_blind
function ease_background_colour_blind(state, blind_override)
    ease_background_colour{new_colour = G.C.BLUE, special_colour = G.C.GREEN, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3}
    if true then return end
    local ret = oldfunc(state,blind_override)
    return ret
end]]


--




--[[local calm = SMODS.Blind{
    key = "calm",
    loc_txt = {
 		name = 'The Calm',
 		text = { "Don't score over 2X", 'required score...' },
 	},
    boss_colour = HEX('4F6367'),
    dollars = 5,
    mult = 1,
    discovered = false,
    has_played = false,
    boss = {
        min = 7,
        max = 7,
        showdown = false
    },
    pos = { x = 0, y = 30 },
}

local storm = SMODS.Blind{
    key = "storm",
    loc_txt = {
 		name = 'The Storm',
 		text = { "It's all over for you" },
 	},
    boss_colour = HEX('4F6367'),
    dollars = 5,
    mult = 2,
    discovered = false,
    has_played = false,
    boss = {
        min = 69420,
        max = 69420,
        showdown = true
    },
    pos = { x = 0, y = 30 },
}

local sarvara = SMODS.Blind{
    key = "sarvara",
    loc_txt = {
 		name = 'Echidna',
 		text = { "idfk", },
 	},
    boss_colour = HEX('D3D3D3'),
    dollars = 5,
    mult = 1,
    discovered = false,
    has_played = false,
    boss = {
        min = 69420,
        max = 69420,
        showdown = false
    },
    pos = { x = 0, y = 30 },
}

local melanos = SMODS.Blind{
    key = "melanos",
    loc_txt = {
 		name = 'Typhon',
 		text = { "Apply effect of previous blind", },
 	},
    boss_colour = HEX('FF0000'),
    dollars = 5,
    mult = 1.5,
    discovered = false,
    has_played = false,
    boss = {
        min = 69420,
        max = 69420,
        showdown = false
    },
    pos = { x = 0, y = 30 },
}

local cerberus = SMODS.Blind{
    key = "cerberus",
    loc_txt = {
 		name = 'Cerberus',
 		text = { "Apply effect of previous blind", },
 	},
    boss_colour = HEX('4F6367'),
    dollars = 5,
    mult = 2,
    discovered = false,
    has_played = false,
    boss = {
        min = 69420,
        max = 69420,
        showdown = true
    },
    pos = { x = 0, y = 30 },
}]]

--[[function set_main_menu_UI()

end


local oldfunc = Game.main_menu
	Game.main_menu = function(change_context)
		local ret = oldfunc(change_context)
		

		G.SPLASH_BACK:define_draw_steps({{
			shader = 'splash',
			send = {
				{name = 'time', ref_table = G.TIMERS, ref_value = 'REAL_SHADER'},
				{name = 'vort_speed', val = 0.4},
				{name = 'colour_1', ref_table = G.C, ref_value = 'BLUE'},
				{name = 'colour_2', ref_table = G.C, ref_value = 'DARK_EDITION'},
			}}})
		--G.SPLASH_LOGO.T.w = G.SPLASH_LOGO.T.w * 1.1
		--G.SPLASH_LOGO.T.h = G.SPLASH_LOGO.T.h * 1.1
		return ret
	end
    
--cryptid banner shit]]
----------------------------------------------
------------MOD CODE END----------------------
