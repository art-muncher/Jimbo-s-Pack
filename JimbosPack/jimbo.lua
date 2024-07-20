--- STEAMODDED HEADER
--- MOD_NAME: Jimbo's New Pack
--- MOD_ID: JimbosPack
--- MOD_AUTHOR: [elial1, Jimbo Himself (real)]
--- MOD_DESCRIPTION: jim bo


local jimbomod = SMODS.current_mod

SMODS.Atlas({ key = 'Jokers', path = 'Jokers.png', px = 71, py = 95 })
--this is from bunco i had NO IDEA how to add sprites i forgot please dont judge me im new!!!!!!!!!!!!!!!!!!


--Googly Joker
local googly = SMODS.Joker {
    key = 'Googly',
    loc_txt = {
        name = "Googly Joker",
        text = {
            "For each time first card in ", "hand is scored, gives {C:chips}+#1#{}", " Chips, {C:mult}#2# Mult{} or {X:mult,C:white} X#3# {} Mult", "{C:inactive}(Currently {C:attention}#4# time(s) {}{C:inactive})"
        }
    },
    rarity = 3,
    config = { extra = { a_chips = 15, a_mult = 3, x_mult = 0.1, triggers = 0, retriggers = 1 } },
    pos = { x = 0, y = 0 },
    atlas = 'Jokers',
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.a_chips, center.ability.extra.a_mult, center.ability.extra.x_mult, center.ability.extra.triggers, } }
    end,
}

googly.calculate = function(self, card, context)
    local googlyval = 0
    if context.individual and context.cardarea == G.play and context.scoring_hand ~= nil and context.other_card == context.scoring_hand[1] then
        card.ability.extra.triggers = card.ability.extra.triggers + card.ability.extra.retriggers
    end

    if context.joker_main then
        local list = {
            {
                Xmult_mod = 1 + card.ability.extra.x_mult * card.ability.extra.triggers,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = { card.ability.extra.x_mult * card.ability.extra.triggers + 1 }
                }
            },
            {
                mult_mod = card.ability.extra.a_mult * card.ability.extra.triggers,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = { card.ability.extra.a_mult * card.ability.extra.triggers }
                }
            },
            {
                chip_mod = card.ability.extra.a_chips * card.ability.extra.triggers,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_chips',
                    vars = { card.ability.extra.a_chips * card.ability.extra.triggers }
                }
            },
        }
        local rng = pseudorandom_element(list, pseudoseed('jimbosadd'))
        return rng
    end
end

googly:register()

---Sad Lad
local sadlad = SMODS.Joker {
    key = 'sadlad',
    loc_txt = {
        name = "Sad Lad",
        text = {
            "Gives {C:chips}+#1#{} Chips when", "a card with {X:clubs,C:white}Clubs{} or", " {X:purple,C:white}Spades{} suit is scored"
        }
    },
    rarity = 1,
    config = { extra = { a_chips = 20 } },
    pos = { x = 1, y = 0 },
    atlas = 'Jokers',
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.a_chips, } }
    end,
}

sadlad.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
        if context.other_card:is_suit('Clubs') or context.other_card:is_suit('Spades') then
            return {
                chips = card.ability.extra.a_chips,
                card = card,
                message = localize {
                    type = 'variable',
                    key = 'a_chips',
                    vars = { card.ability.extra.a_chips }
                }
            }
        end
    end
end




---Clown
local clown = SMODS.Joker {
    key = 'digitalclown',
    loc_txt = {
        name = "Digital Clown",
        text = {
            "Face cards give {X:chips,C:white}X#1#{} {C:chips}chips{}", " when scored"
        }
    },
    rarity = 3,
    config = { extra = { chips = 1.2, facecard = 0 } },
    pos = { x = 2, y = 0 },
    atlas = 'Jokers',
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.chips } }
    end,
}
clown.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
        if context.other_card:is_face() then
            card.ability.extra.facecard = card.ability.extra.facecard + 1
        end
    end
    if context.cardarea == G.jokers and not context.before and not context.after then
        local handchips = 0
        local chipsmultvis = 1
        for i = 1, card.ability.extra.facecard do
            handchips = hand_chips * card.ability.extra.chips - hand_chips
            chipsmultvis = chipsmultvis * card.ability.extra.chips
        end
        hand_chips = handchips + hand_chips
        card.ability.extra.facecard = 0
        return {
            message = localize {
                type = 'variable',
                key = 'a_chips',
                vars = { "X" .. chipsmultvis .. " Chips" }
            },
        }
    end
end

-- JokerDisplay Support

if _G["JokerDisplay"] then
    local path = SMODS.current_mod.path
    NFS.load(path .. "joker_display_definitions.lua")()
end

----------------------------------------------
------------MOD CODE END----------------------
