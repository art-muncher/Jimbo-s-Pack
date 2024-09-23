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
SMODS.Atlas({key = 'Exotic', path = 'atlasexotic.png', px = 71, py = 95})
SMODS.Atlas({key = 'Tarot', path = 'Tarots.png', px = 71, py = 95})
SMODS.Atlas{
    key = "Mega",
    path = "Jokers2.png",
    px = 710,
    py = 1520
}



---CONGRATS ON ENTERING MY SECRET EVIL SCRIPTING LAIR........ BUT BEWARE..... THIS CODE SUCKS BALLS!!! MUAHAHAHAHAHAHAHA












--Googly Joker
local googly = SMODS.Joker{
    key = 'Googly',
    loc_txt = {
        name = "Googly Joker",
        text = {
            "Cards played have a", "{C:green}#3# in #1#{} chance of", "being retriggered {C:attention}#2#{} times"
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
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.odds,center.ability.extra.retrigger_amt,G.GAME.probabilities.normal}}
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
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips,}}
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
    config = {extra = {chips = 1.2, facecard = 0}},
    pos = { x = 2, y = 0 },
    atlas = 'Jokers',
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips}}
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






local ubiquityactive = true


--superpos/ubiquity
local superpos = SMODS.Joker{
    key = 'ubiquity',
    loc_txt = {
        name = "Ubiquity",
        text = {
            "When boss blind is selected,", "create a {C:dark_edition}Negative{} copy of"," this joker. For every Ubiquity", " you have, gain {X:mult,C:white}#1#X{} Mult.","{C:inactive}(Currently {X:attention,C:white}#2#X{}{C:inactive})"
        }
    },
    rarity = 3,
    config = {extra = {Xmult = 1, Xmult_mod = 0.05,}},
    pos = { x = 0, y = 0 },
    soul_pos = {x = 0, y = 1},
    atlas = 'Soulj',
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        return {vars = {center.ability.extra.Xmult_mod, center.ability.extra.Xmult}}
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
}









--Cardboard Cutout
--[[]
local cardboard = SMODS.Joker{
    key = 'cardboard',
    loc_txt = {
        name = "Cardboard Cutout",
        text = {
            "Copies the ability of a random","Joker at end of round","{X:attention,C:white}#1#"
        }
    },
    config = {extra = {fakejoker = nil, text = "wawa", }},
    rarity = 2,
    pos = {x = 0, y = 1},
    atlas = 'Jokers',
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.text}}
    end,
    calculate = function(self,card,context)
        if card.ability.extra.fakejoker then
            local other_joker = card.ability.extra.fakejoker
            card.ability.extra.text = other_joker.ability.name
            context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
            context.blueprint_card = context.blueprint_card or self
            local other_joker_ret = other_joker:calculate_joker(context)
            if other_joker_ret then 
                other_joker_ret.card = context.blueprint_card or self
                other_joker_ret.colour = G.C.BLUE
                return other_joker_ret
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        card.ability.extra.fakejoker = nil
        local newcard = create_card('Joker', G.jokers, nil, nil, nil, nil, nil)
        card.ability.extra.fakejoker = newcard
        newcard = nil
        --newcard:start_dissolve()
    end,
}]]







--3D Vision

local vision = SMODS.Joker{
    key = 'vision',
    loc_txt = {
        name = "3D Vision",
        text = {
            "Creates a {X:attention,C:white}Double{}{X:attention,C:white} Tag{}","when a blind is skipped",
        }
    },
    config = {extra = {}},
    rarity = 2,
    pos = {x = 0, y = 0},
    soul_pos = {x=1,y=1},
    atlas = 'Soulj',
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chosenname}}
    end,
}

vision.calculate = function(self, card, context)
    if context.skip_blind then
        add_tag(Tag('tag_double'))
        return{}
    end
end


local danger = SMODS.Joker{
    key = 'sign',
    loc_txt = {
        name = "Danger Sign",
        text = {
            "{X:mult,C:white}X#1#{} Mult if no discards","have been used this round"
        }
    },
    config = {extra = {Xmult = 2}},
    rarity = 2,
    pos = {x = 1, y = 1},
    atlas = 'Jokers',
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
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
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult,center.ability.extra.mult_mod,center.ability.extra.remaining}}
    end,
    calc_dollar_bonus = function(self, card)
        card.ability.extra.remaining = card.ability.extra.remaining - 1
        if card.ability.extra.remaining <= 0 then
            card:start_dissolve()
        end
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
    end
}

gum.calculate = function(self, card, context)
    if context.joker_main then
        return {
            card = card,
            message = localize{
                type='variable',
                key='a_mult',
                vars={card.ability.extra.mult}
            },
            mult_mod = card.ability.extra.mult,
        }
    end
end

local ouroborosActive = nil
local ouroboros = SMODS.Joker{
    key = 'ouroboros',
    loc_txt = {
        name = "Ouroboros",
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult", "and {C:money}#3#${} of cost when sold", "{C:green}Next Joker generated is Ouroboros{}", "{C:inactive}(Currently {X:mult,C:white}X#1#{} Mult{C:inactive})"
        }
    },
    config = {extra = {Xmult = 1, Xmult_mod = 0.25, cost = 2}},
    rarity = 3,
    pos = {x = 0, y = 0},
    atlas = 'Soulj',
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
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
            ouroborosActive = {cost = card.ability.extra.cost, Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod}
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
    end
}


--[[
Man.
local aether = SMODS.Joker{
    key = 'aether',
    loc_txt = {
        name = "{C:dark_edition}Aether{}",
        text = {
            "Destroy a random Joker", "each round","Copy its abilities"
        }
    },
    cursed = true,
    config = {extra = {jokers = {}}},
    rarity = 4,
    pos = {x = 1, y = 6},
    atlas = 'Tarot',
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    calc_dollar_bonus = function(self, card)
        local chosenjoker = G.jokers.cards[math.random(1,#G.jokers.cards)]
        if chosenjoker.ability.name ~= card.ability.name then
            card.ability.extra.jokers[#card.ability.extra.jokers+1] = chosenjoker
            --chosenjoker:start_dissolve()
        end
    end,
    calculate = function(self,card,context)
        local totalret = {message = "Consume...",}
        for i, v in pairs(card.ability.extra.jokers) do
            local ret = v:calculate_joker(context)
            local shouldreplace = true
            if ret then 
                for _i,_v in pairs(totalret) do
                    if _i == i then
                        shouldreplace = false
                        if type(_v) == 'number' then totalret[i] = totalret[i] + ret[i]
                    end
                    print(_i)
                    print(_v)
                end
                if shouldreplace == true then
                    totalret[i] = ret[i]
                end
                print(i)
                print(v)
                print("--------------------------------------")
            end
        end
        return totalret
    end
end
}
--]]



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
        discovered = true,
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
        end
    }


    --[[local aequilibrium = SMODS.Joker{
        key = 'equilib',
        loc_txt = {
            name = "Ace Aequilibrium",
            text = {
                "All Jokers spawn in {C:dark_edition}numerical order{}",
                "Spawn {C:attention}#1#{} {C:dark_edition}Negative{} {C:attention{}Jokers{} when hand played",
                "{C:attention}Unretriggerable{}"
            }
        },
        config = {extra = {jokers = 2, num = 1}},
        rarity = "cry_exotic",
        pos = {x = 1, y = 6},
        soul_pos = {x = 0, y = 6},
        atlas = 'Exotic',
        cost = 50,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue+1] = G.P_CENTERS.e_negative
            return {vars = {center.ability.extra.jokers,}}
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                for i = 1, card.ability.extra.jokers do
                    local newcard = create_card('Joker', G.jokers, nil, nil, nil, nil, nil)
                    newcard:add_to_deck()
                    G.jokers:emplace(newcard)
                    newcard:set_edition({negative = true}, true)
                end
                --return {}
            end
        end,
    }
    

    SMODS.Consumable {
        key = 'Remove Shit',
        set = 'Spectral',
        loc_txt = {
            name = '{C:blue}Sanctuary{}',
            text = {
                'Purify a selected {C:red}Curse{}',
            }
        },
        config = {extra = {}},
        pos = { x = 0, y = 6 },
        soul_pos = { x = 69420, y = 0 },
        cost = 6,
        unlocked = true,
        discovered = true,
        atlas = 'Tarot',
        loc_vars = function(self, info_queue, center)
            return {vars = {}}
        end,
        can_use = function(self, card)
            --for i,v in pairs(G.jokers.highlighted[1].ability) do
                --print(i)
                --print(v)
                --print("------------------------------------")
            --end
            
            return true
        end,
        use = function(self, card, area, copier)
            local destructable_codecard = {}
            for i = 1, #G.consumeables.cards do
                if G.consumeables.cards[i].ability.set == 'Code' and not G.consumeables.cards[i].getting_sliced and not G.consumeables.cards[i].ability.eternal then destructable_codecard[#destructable_codecard+1] = G.consumeables.cards[i] end
            end
            local codecard_to_destroy = #destructable_codecard > 0 and pseudorandom_element(destructable_codecard, pseudoseed('cut')) or nil
            if codecard_to_destroy then
                codecard_to_destroy:start_dissolve()
                local newcard = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'sixth')
                newcard:add_to_deck()
                G.consumeables:emplace(newcard)
            end
        end
    }]]

end







--------------------CURSES--------------------
--------------------CURSES--------------------
--------------------CURSES--------------------

    --[[SMODS.Joker = SMODS.Center:extend {
        rarity = 1,
        unlocked = true,
        discovered = false,
        blueprint_compat = false,
        perishable_compat = true,
        eternal_compat = true,

        cursed = false,

        pos = { x = 0, y = 0 },
        cost = 3,
        config = {},
        set = 'Joker',
        atlas = 'Joker',
        class_prefix = 'j',
        required_params = {
            'key',
        },
        inject = function(self)
            -- call the parent function to ensure all pools are set
            SMODS.Center.inject(self)
            if self.cursed == false then
                if self.taken_ownership and self.rarity_original == self.rarity then
                    SMODS.remove_pool(G.P_JOKER_RARITY_POOLS[self.rarity_original], self.key)
                    SMODS.insert_pool(G.P_JOKER_RARITY_POOLS[self.rarity], self, false)
                else
                    SMODS.insert_pool(G.P_JOKER_RARITY_POOLS[self.rarity], self)
                end
            end
        end
    }

    function Card:purify(self,card)
        --if card.cost == -0.000000000000420691234 then
            card.ability.pure = 1
            card:start_dissolve({G.C.DARK_EDITION}, nil, 2.5)
            card:remove_from_deck(true)
            print("yes it is purified")
        --end
    end


    SMODS.Consumable {
        key = 'sanctuary_jimb',
        set = 'Spectral',
        loc_txt = {
            name = '{C:blue}Sanctuary{}',
            text = {
                'Purify a selected {C:red}Curse{}',
            }
        },
        config = {extra = {}},
        pos = { x = 0, y = 6 },
        soul_pos = { x = 69420, y = 0 },
        cost = 6,
        unlocked = true,
        discovered = true,
        atlas = 'Tarot',
        loc_vars = function(self, info_queue, center)
            return {vars = {}}
        end,
        can_use = function(self, card)
            --for i,v in pairs(G.jokers.highlighted[1].ability) do
                --print(i)
                --print(v)
                --print("------------------------------------")
            --end
            if G.jokers.highlighted[1] and G.jokers.highlighted[1].ability.pure and G.jokers.highlighted[1].ability.pure == 0 then
                return true
            end

            return false
        end,
        use = function(self, card, area, copier)
            if area then area:remove_from_highlighted(card) end
            if G.jokers.highlighted[1] and G.jokers.highlighted[1].ability.pure and G.jokers.highlighted[1].ability.pure == 0 then
                G.jokers.highlighted[1]:purify(G.jokers.highlighted[1],G.jokers.highlighted[1])
            end
        end
    }




    local popup = SMODS.Joker{
            key = 'popup',
            cursed = true,
            pure = 0,
            loc_txt = {
                name = "Pop Up",
                text = {
                    "{C:red}Self destruct on blind select{}", "{C:dark_edition}Takes up a joker slot{}"
                }
            },
            config = {extra = {}},
            rarity = 1,
            pos = {x = 1, y = 0},
            atlas = 'Curse',
            cost = -0.000000000000420691234,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {}}
            end,
            calculate = function(self, card, context)
                if context.setting_blind then
                    --card:start_dissolve({G.C.BLACK}, nil, 2.5)
                    card:purify(self,card)
                end
            end,
            add_to_deck = function(self, card, from_debuff)
                --G.jokers.config.card_limit = G.jokers.config.card_limit - 1
                --card.cost = -0.000000000000420691234
                card.ability.pure = 0
                card:set_eternal(true)
            end,
            remove_from_deck = function(self, card, from_debuff)
                --G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
    }

    local ballsmcgee = SMODS.Joker{
        key = 'balls',
        cursed = true,
        pure = 0,
        loc_txt = {
            name = "Balls mcgee",
            text = {
                "Balls"
            }
        },
        config = {extra = {}},
        rarity = 1,
        pos = {x = 1, y = 0},
        atlas = 'Curse',
        cost = -0.000000000000420691234,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            return {vars = {}}
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                --card:start_dissolve({G.C.BLACK}, nil, 2.5)
                card:purify(self,card)
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            --G.jokers.config.card_limit = G.jokers.config.card_limit - 1
            --card.cost = -0.000000000000420691234
            card:set_eternal(true)
        end,
        remove_from_deck = function(self, card, from_debuff)
            --G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
    }


    local virusjoker = SMODS.Joker{
        key = 'virus',
        loc_txt = {
            name = "You are 100th Joker",
            text = {
                "Gain {C:attention}#1#${} at end of round","{C:green,E:1,S:1.1}#3# in #2#{} chance to create", "a useless Pop Up at end of round"
            }
        },
        config = {extra = {money = 5, odds = 2}},
        rarity = 2,
        pos = {x = 0, y = 0},
        atlas = 'Curse',
        cost = 5,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            return {vars = {center.ability.extra.money, center.ability.extra.odds,G.GAME.probabilities.normal}}
        end,
        calc_dollar_bonus = function(self, card)
            if pseudorandom('popupget') < G.GAME.probabilities.normal/card.ability.extra.odds then
                local newcard = create_card('Joker', G.other, nil, nil, nil, nil, popup.key)
                newcard:add_to_deck()
                --newcard:set_eternal(true)
                G.jokers:emplace(newcard)
                --newcard:start_materialize()
                --newcard:set_eternal(true)
            end
            if card.ability.extra.money > 0 then
                return card.ability.extra.money
            end
        end,
        calculate = function(self, card, context)
            
        end,
    }

    local finger = SMODS.Joker{
        key = 'finger',
        loc_txt = {
            name = "Index Finger",
            text = {
                "{C:blue}-#1# Hands{}",
                "{C:red}Cursed{}"
            }
        },
        config = {extra = {hands = 1}},
        cursed = true,
        pure = 0,
        rarity = 1,
        pos = {x = 1, y = 0},
        atlas = 'Curse',
        cost = -0.000000000000420691234,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            return {vars = {center.ability.extra.hands}}
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                --card:purify(self,card)
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            --G.jokers.config.card_limit = G.jokers.config.card_limit - 1
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
            --card.cost = -0.000000000000420691234
            card.ability.pure = 0
            print(card.ability.pure)
            card:set_eternal(true)
        end,
        remove_from_deck = function(self, card, from_debuff)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
            if card.ability.pure == 1 then
                local newcard = create_card('Joker', G.other, nil, nil, nil, nil, "j_jimb_finger")
                newcard:add_to_deck()
                G.jokers:emplace(newcard)
                newcard:start_materialize({G.C.DARK_EDITION}, nil, 5)
            end
            --G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
    }

    local finger2 = SMODS.Joker{
        key = 'finger2',
        pure = 1,
        cursed = true,
        loc_txt = {
            name = "Index Finger",
            text = {
                "{C:blue}X#1# blind req{}", "per hand above/below #2#",
                "{C:red}Purified{}"
            }
        },
        config = {extra = {req = 1/0.9, hands = 4}},
        rarity = 1,
        pos = {x = 1, y = 0},
        atlas = 'Curse',
        cost = 5,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            --print(self.effect[1])
            return {vars = {1/center.ability.extra.req,center.ability.extra.hands}}
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                G.GAME.blind.chips = G.GAME.blind.chips * (1/card.ability.extra.req)
                self.loc_txt.text = {"balls"}
                --for i,v in pairs(self.loc_txt.text) do print(v) end

            end
            
        end,
        add_to_deck = function(self, card, from_debuff)
            --G.jokers.config.card_limit = G.jokers.config.card_limit - 1
            --G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
            card.ability.pure = 1
            print(card.ability.pure)
        end,
        remove_from_deck = function(self, card, from_debuff)
            --G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
            --G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
    }

    local debt = SMODS.Joker{
        key = 'interest',
        loc_txt = {
            name = "Interest",
            text = {
                "Lose {C:money}#1#${} per round",
                "Gain {X:money,C:white}X#2#{} of lost {C:money}${} when {C:red}purified{}",
                "{C:red}Cursed{}, {C:inactive}(Currently{} {C:money}#3#${}{C:inactive}){}"
            }
        },
        config = {extra = {dollars = 3,dollarmult = 2,dollarlost = 0}},
        cursed = true,
        pure = 0,
        rarity = 1,
        pos = {x = 1, y = 0},
        atlas = 'Curse',
        cost = 0,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            return {vars = {center.ability.extra.dollars,center.ability.extra.dollarmult,center.ability.extra.dollarlost*center.ability.extra.dollarmult}}
        end,
        calc_dollar_bonus = function(self, card)
            ease_dollars(card.ability.extra.dollars * -1)
            card.ability.extra.dollarlost = card.ability.extra.dollarlost + card.ability.extra.dollars
        end,
        add_to_deck = function(self, card, from_debuff)
            card.ability.pure = 0
            card:set_eternal(true)
        end,
        remove_from_deck = function(self, card, from_debuff)
            
            if card.ability.pure == 1 then
                ease_dollars(card.ability.extra.dollarlost * card.ability.extra.dollarmult)
            end
            --G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end
    }
    ]]


    --]]
    --im tired, boss....
    --im adding curses some update later





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

--[[function jokerMult(card, mult)
        local namedBonus={'s_mult','h_plays','size','faces','min','max','chip_mod','Xmult','Xmult_mod','remaining','discards','chips','dollars','bonus','h_mult','mult','t_mult','h_dollars','extra_value','h_size','perma_bonus','p_dollars','h_x_mult','t_chips','d_size','odds','h_mod','hand_add','discard_sub'}
        for k, v in pairs(namedBonus) do
            if card.ability[v] then
                card.ability[v]=card.ability[v] * mult
            end
            if card.ability.extra and type(card.ability.extra) ~= 'number' and card.ability.extra[v] then
                card.ability.extra[v] = card.ability.extra[v] * mult
            end
        end
        if card.ability.extra then
            if type(card.ability.extra)=='table' then
                for k, v in pairs(card.ability.extra) do
                    if type(v)=='number' then
                        v = v * mult
                    end
                end
            elseif type(card.ability.extra)=='number' then
                card.ability.extra = card.ability.extra * mult
            end
        end
end]]
function jokerMult(card,mult)
    if not card.ability then return end
    if not card.ability.extra then return end
    if type(card.ability.extra) == 'number' then card.ability.extra = card.ability.extra*mult end
    if type(card.ability.extra) == 'table' then
        for i,v in pairs(card.ability.extra) do
            
            if type(card.ability.extra[i]) == 'number' then card.ability.extra[i] = card.ability.extra[i] * mult  end
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
        "{X:dark_edition,C:white}X#1#{} Card Values"
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
    apply = function(back)
        
    end,
    loc_vars = function(self)
        return { vars = {self.config.extra.mult} }
    end
}
local configs = neondeck.config.extra
neondeck.trigger_effect = function(args)
    if not args then return end
    

    if to_big(G.GAME.chips) >= G.GAME.blind.chips then
        configs.jokers2 = G.jokers.cards

        G.jokers.cards = {}
        for i = 1, #configs.jokers do
            configs.jokers[i]:add_to_deck()
            configs.jokers[i]:start_materialize({G.C.DARK_EDITION}, nil, 5)
            G.jokers:emplace(configs.jokers[i])
        end

        G.jokers.cards = configs.jokers
        configs.jokers = configs.jokers2
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
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "Planted Deck",
        text = {
        "Every run uses only one seed",
        "Seed changes every 10 runs",
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
}



local archeologist = SMODS.Back{
    key = "archeologist",
    name = "Archeologist Deck",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "Archeologist Deck",
        text = {
        "Start at {C:attention}Ante #1#{}",
        "{C:mult}#2#{} discards"
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
        --ease_ante(-2)
        G.GAME.round_resets.ante = back.config.extra.ante
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - back.config.extra.discards
    end,
    loc_vars = function(self)
        return { vars = {self.config.extra.ante,self.config.extra.discards} }
    end
}


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
    return ret
end


local oldfunc = create_card
create_card = function(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)

    if ouroborosActive then
        forced_key = 'j_jimb_ouroboros'
    end
    
    
    --end
    local ret = oldfunc(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)

    if ouroborosActive then
        ret.cost = ret.cost + ouroborosActive.cost
        ret:set_cost()
        ret.ability.extra.Xmult = ouroborosActive.Xmult
        ret.cost = ret.cost + ouroborosActive.cost or 69420
        ouroborosActive = nil
    end

    --POST hook
    local selected_back = saveTable and saveTable.BACK.name or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
    selected_back = get_deck_from_name(selected_back)
    if selected_back.name == "Neon Deck" then
        jokerMult(ret,selected_back.config.mult)
    end
    if (ret.edition and (ret.edition["jimb_anaglyphic"])) then
        jokerMult(ret,1.5)
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

                    local key = 'p_arcana_mega_'..(math.random(1,2))
                    local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                    G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                    card.cost = 0
                    card.from_tag = false
                    G.FUNCS.use_card({config = {ref_table = card}})
                    card:start_materialize()
                    G.CONTROLLER.locks[lock] = nil
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
    discovered = true,
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
    discovered = true,
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
    discovered = true,
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

local the_hand = SMODS.Blind{
    key = "the_hand",
    loc_txt = {
 		name = 'The Hand',
 		text = { '+3 Hands, +1.5X score', 'requirement per hand' },
 	},
    boss_colour = HEX('015482'),
    dollars = 5,
    mult = 2,
    discovered = true,
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
}


----------------------------------------------
------------MOD CODE END----------------------