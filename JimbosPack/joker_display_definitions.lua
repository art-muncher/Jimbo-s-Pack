local jd_def = JokerDisplay.Definitions

jd_def['j_jimb_Googly'] = { -- Googly Joker
    text = {
        { text = '+', colour = G.C.CHIPS },
        { ref_table = 'card.joker_display_values', ref_value = 'a_chips', colour = G.C.CHIPS },
        { text = ' +', colour = G.C.MULT },
        { ref_table = 'card.joker_display_values', ref_value = 'a_mult', colour = G.C.MULT },
    },
    reminder_text = {
        { text = '(Random)' },
    },
    extra = {
        {
            {
                border_nodes = {
                    { text = 'X', },
                    { ref_table = 'card.joker_display_values', ref_value = 'x_mult' },
                }
            }
        }
    },
    calc_function = function (card)
        card.joker_display_values.a_chips = card.ability.extra.a_chips * card.ability.extra.triggers
        card.joker_display_values.a_mult = card.ability.extra.a_mult * card.ability.extra.triggers
        card.joker_display_values.x_mult = 1 + (card.ability.extra.x_mult * card.ability.extra.triggers)
    end
}

jd_def['j_jimb_sadlad'] = { -- Sad Lad
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips" }
    },
    text_config = { colour = G.C.CHIPS },
    reminder_text = { --
        { text = "(" },
        {
            ref_table = "card.joker_display_values",
            ref_value = "localized_text_clubs",
            colour = lighten(loc_colour("clubs"), 0.35)
        },
        { text = "/" },
        {
            ref_table = "card.joker_display_values",
            ref_value = "localized_text_spades",
            colour = lighten(loc_colour("spades"), 0.35)
        },
        { text = ")" },
    },
    calc_function = function(card)
        local chips = 0
        local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
        local text, _, scoring_hand = JokerDisplay.evaluate_hand(hand)
        for k, v in pairs(scoring_hand) do
            if v:is_suit('Clubs') or v:is_suit('Spades') then
                chips = chips +
                    card.ability.extra.a_chips *
                    JokerDisplay.calculate_card_triggers(v, not (text == 'Unknown') and scoring_hand or nil)
            end
        end
        card.joker_display_values.chips = chips
        card.joker_display_values.localized_text_clubs = localize("Clubs", 'suits_plural')
        card.joker_display_values.localized_text_spades = localize("Spades", 'suits_plural')
    end
}

jd_def['j_jimb_digitalclown'] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult" }
            },
            border_colour = G.C.CHIPS
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
        local text, _, scoring_hand = JokerDisplay.evaluate_hand(hand)
        for k, v in pairs(scoring_hand) do
            if v:is_face() then
                count = count +
                    JokerDisplay.calculate_card_triggers(v, not (text == 'Unknown') and scoring_hand or nil)
            end
        end
        card.joker_display_values.x_mult = tonumber(string.format("%.2f", (card.ability.extra.chips ^ count)))
        card.joker_display_values.localized_text = localize("k_face_cards")
    end
}