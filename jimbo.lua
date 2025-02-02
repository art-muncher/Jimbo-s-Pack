--- STEAMODDED HEADER
--- MOD_NAME: Jimbo's Pack
--- MOD_ID: JimbosPack
--- MOD_AUTHOR: [elial1, Jimbo Himself (real)]
--- MOD_DESCRIPTION: jim bo
--- PRIORITY: 999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999


--necessities
    --to do:
    --linked cards: linked card's effects also apply to the other linked card



    local jimbomod = SMODS.current_mod

    SMODS.Atlas({key = 'Jokers', path = 'Jokers.png', px = 71, py = 95})
    SMODS.Atlas({key = 'Soulj', path = 'Soulj.png', px = 71, py = 95})
    SMODS.Atlas({key = 'Curse', path = 'Curses.png', px = 71, py = 95})
    SMODS.Atlas({key = 'Tarot', path = 'Tarots.png', px = 71, py = 95})
    SMODS.Atlas({key = 'blinds', path = 'blinds.png', px = 34, py = 34, frames = 21, atlas_table = 'ANIMATION_ATLAS'})
    SMODS.Atlas{
        key = "Mega",
        path = "Jokers2.png",
        px = 710,
        py = 1520
    }
    SMODS.Atlas({key = 'Vouchers', path = 'Vouchers.png', px = 71, py = 95})
    SMODS.Atlas({key = 'Stakes', path = 'stakes.png', px = 29, py = 29})
    SMODS.Atlas({key = 'Stickers', path = 'stickers.png', px = 71, py = 95})
    local littleguy_atlas = SMODS.Atlas({key = 'littleguy', path = 'littleguy.png', px = 177, py = 100, atlas_table = "ASSET_ATLAS",})


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
    if jimbomod.config["Summoned Blinds"] == nil then
        jimbomod.config["Summoned Blinds"]  = {}
    end
--necessities


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

----functions
    --


    function create_card_example(keys)
        local area = CardArea( 0, 0, math.min(5,#keys) * G.CARD_W, G.CARD_H*1.5, {card_limit = #keys, type = 'title', highlight_limit = 0})
        --if type(keys) == 'string' then keys = {keys} end
        local cards = {}
        for i = 1, #keys do
            local card = create_card('Joker', G.jokers, nil,nil,nil,nil, keys[i])
            --print(card.config.center.key .. '  CENTER')
            --print(keys[i] .. '  og key')
            area:emplace(card)
            cards[#cards+1]= card
        end
        
        return {
            n=G.UIT.R, config = {
                align = "cm", colour = G.C.CLEAR, r = 0.0
            }, 
            nodes={
                {
                    n=G.UIT.C, 
                    config = {align = "cm"}, 
                    nodes={
                        {n=G.UIT.O, config = {object = area}}
                    }
                }
            },
            
        }, cards
    end


    local blindtype = 'Small'
    local oldfunc = end_round
    end_round = function()

        for i = 1, #G.jokers.cards do
            local card= G.jokers.cards[i]
            card.jimb_roundDebuff = card.jimb_roundDebuff and card.jimb_roundDebuff - 1 or nil
        end

        for i = 1, #G.consumeables.cards do
            local card= G.consumeables.cards[i]
            card.jimb_roundDebuff = card.jimb_roundDebuff and card.jimb_roundDebuff - 1 or nil
        end

        for i = 1, #G.playing_cards do
            local card= G.playing_cards[i]
            card.jimb_roundDebuff = card.jimb_roundDebuff and card.jimb_roundDebuff - 1 or nil
        end

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
        if not G.GAME.cry_double_scale then
            G.GAME.cry_double_scale = { double_scale = true } --doesn't really matter what's in here as long as there's something
        end
        rkeyargs = e
        local rkey = e and e.rkey or args and args.rkey
        if rkey then
            args.seed = rkey.seed
        end
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
        if not G.GAME.cry_double_scale then
            G.GAME.cry_double_scale = { double_scale = true } --doesn't really matter what's in here as long as there's something
        end


        local ret = oldfunc(e,args)


        if not G.GAME.cry_double_scale then
            G.GAME.cry_double_scale = { double_scale = true } --doesn't really matter what's in here as long as there's something
        end
        if selected_back.name == "Planted Deck" or rkey then
            G.GAME.seeded = false
        end
        if rkey then
            for i = 1, #rkey.jokers do
                local card = create_card('Joker', G.jokers,nil,nil,nil,nil,rkey.jokers[i].key)
                card.ability = rkey.jokers[i].ability
                card:add_to_deck()
                G.jokers:emplace(card)
            end
        end
        --ease_ante(0)

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
                        if v.id == 'jimb_probability' then
                            G.GAME.probabilities.normal = G.GAME.probabilities.normal * v.value
                        end

                        if v.id == 'jimb_rocktop' then
                            G.GAME.modifiers.jimb_rocktop = G.GAME.modifiers.jimb_rocktop or {}
                            G.GAME.modifiers.jimb_rocktop[v.value] = G.GAME.modifiers.jimb_rocktop[v.otherval]
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
        G.GAME.money_spend_this_round = G.GAME.money_spend_this_round or 0


        G.mid_screen = CardArea(
        0.5,
        0.5,
        0,
        0, 
        {card_limit = 0, type = 'shop', highlight_limit = 0})
        return ret
    end

    function evaluate_effect(effects)
        for ii = 1, #effects do
            --If chips added, do chip add event and add the chips to the total
            if effects[ii].chips then 
                if effects[ii].card then juice_card(effects[ii].card) end
                hand_chips = mod_chips(hand_chips + effects[ii].chips)
                update_hand_text({delay = 0}, {chips = hand_chips})
                card_eval_status_text(effects[ii].card, 'chips', effects[ii].chips, percent)
            end

            --If mult added, do mult add event and add the mult to the total
            if effects[ii].mult then 
                if effects[ii].card then juice_card(effects[ii].card) end
                mult = mod_mult(mult + effects[ii].mult)
                update_hand_text({delay = 0}, {mult = mult})
                card_eval_status_text(effects[ii].card, 'mult', effects[ii].mult, percent)
            end

            --If play dollars added, add dollars to total
            if effects[ii].p_dollars then 
                if effects[ii].card then juice_card(effects[ii].card) end
                ease_dollars(effects[ii].p_dollars)
                card_eval_status_text(effects[ii].card, 'dollars', effects[ii].p_dollars, percent)
            end

            --If dollars added, add dollars to total
            if effects[ii].dollars then 
                if effects[ii].card then juice_card(effects[ii].card) end
                ease_dollars(effects[ii].dollars)
                card_eval_status_text(effects[ii].card, 'dollars', effects[ii].dollars, percent)
            end

            --Any extra effects
            if effects[ii].extra then 
                if effects[ii].card then juice_card(effects[ii].card) end
                local extras = {mult = false, hand_chips = false}
                if effects[ii].extra.mult_mod then mult =mod_mult( mult + effects[ii].extra.mult_mod);extras.mult = true end
                if effects[ii].extra.chip_mod then hand_chips = mod_chips(hand_chips + effects[ii].extra.chip_mod);extras.hand_chips = true end
                if effects[ii].extra.swap then 
                    local old_mult = mult
                    mult = mod_mult(hand_chips)
                    hand_chips = mod_chips(old_mult)
                    extras.hand_chips = true; extras.mult = true
                end
                if effects[ii].extra.func then effects[ii].extra.func() end
                update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult})
                card_eval_status_text(effects[ii].card, 'extra', nil, percent, nil, effects[ii].extra)
            end

            --If x_mult added, do mult add event and mult the mult to the total
            if effects[ii].x_mult then 
                if effects[ii].card then juice_card(effects[ii].card) end
                mult = mod_mult(mult*effects[ii].x_mult)
                update_hand_text({delay = 0}, {mult = mult})
                card_eval_status_text(effects[ii].card, 'x_mult', effects[ii].x_mult, percent)
            end

            --calculate the card edition effects
            if effects[ii].edition then
                hand_chips = mod_chips(hand_chips + (effects[ii].edition.chip_mod or 0))
                mult = mult + (effects[ii].edition.mult_mod or 0)
                mult = mod_mult(mult*(effects[ii].edition.x_mult_mod or 1))
                update_hand_text({delay = 0}, {
                    chips = effects[ii].edition.chip_mod and hand_chips or nil,
                    mult = (effects[ii].edition.mult_mod or effects[ii].edition.x_mult_mod) and mult or nil,
                })
                card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil, {
                    message = (effects[ii].edition.chip_mod and localize{type='variable',key='a_chips',vars={effects[ii].edition.chip_mod}}) or
                            (effects[ii].edition.mult_mod and localize{type='variable',key='a_mult',vars={effects[ii].edition.mult_mod}}) or
                            (effects[ii].edition.x_mult_mod and localize{type='variable',key='a_xmult',vars={effects[ii].edition.x_mult_mod}}),
                    chip_mod =  effects[ii].edition.chip_mod,
                    mult_mod =  effects[ii].edition.mult_mod,
                    x_mult_mod =  effects[ii].edition.x_mult_mod,
                    colour = G.C.DARK_EDITION,
                    edition = true})
            end
        end
    end



    local oldfunc = eval_card
    function eval_card(card, context)
        local ret = oldfunc(card,context)
        --[[
        local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
        context = context or {}
        if card.ability.jimb_link and not context.is_rescore then
            context.is_rescore = true
            local effects = {}
            for i = 1, #G.I.CARD do
                if G.I.CARD[i] ~= card and G.I.CARD[i].ability and G.I.CARD[i].ability.jimb_link and G.I.CARD[i].ability.jimb_link == card.ability.jimb_link then
                    --print('hiiii')
                    local effect = eval_card(G.I.CARD[i],context)
                    if effect then
                        effect.card = G.I.CARD[i]
                        effects[#effects+1] = effect
                    end
                    context.individual = true
                        context.scoring_name = text 
                        context.poker_hands = poker_hands 
                        context.other_card = G.I.CARD[i]
                    for k=1, #G.jokers.cards do
                        --calculate the joker individual card effects

                        local eval = G.jokers.cards[k]:calculate_joker(context)
                        if eval then 
                            table.insert(effects, eval)
                        end
                    end
                end
            end
            evaluate_effect(effects)
        end
        ]]
        if context.cardarea == G.play then
            G.GAME.scoredface = G.GAME.scoredface + 1
        end
        G.GAME.blind:jimb_cardScore(card,context)
        return ret
    end


    local oldfunc = Card.set_ability
    Card.set_ability = function(self, center, initial, delay_sprites)
        
        self.jimb_jokers = self.jimb_jokers or {}

        if self.ability and self.ability.jimb_link and not self.changing_ability then
            self.changing_ability = true
            for i = 1, #G.I.CARD do
                if G.I.CARD[i] ~= self and G.I.CARD[i].ability and G.I.CARD[i].ability.jimb_link and G.I.CARD[i].ability.jimb_link == self.ability.jimb_link then
                    oldfunc(G.I.CARD[i], center,initial,delay_sprites)
                end
            end
        end
        self.changing_ability = nil

        if self.ability and center then
            local stats = {
                mult = center.config.mult and center.config.mult+self.ability.mult or self.ability.mult,
                h_mult = center.config.h_mult and center.config.h_mult+self.ability.h_mult or self.ability.h_mult,
                h_x_mult = center.config.h_x_mult and center.config.h_x_mult + self.ability.h_x_mult or self.ability.h_x_mult,
                h_dollars = center.config.h_dollars and center.config.h_dollars+ self.ability.h_dollars or self.ability.h_dollars,
                p_dollars = center.config.p_dollars and center.config.p_dollars + self.ability.p_dollars or self.ability.p_dollars,
                t_mult = center.config.t_mult and center.config.t_mult+self.ability.t_mult or self.ability.t_mult,
                t_chips = center.config.t_chips and center.config.t_chips+self.ability.t_chips or self.ability.t_chips,
                x_mult = center.config.Xmult and center.config.Xmult + math.max(1, self.ability.Xmult and self.ability.Xmult-1 or 0) or math.max(1, self.ability.Xmult and self.ability.Xmult-1 or 1),
            }
        end

        local ret = oldfunc(self, center, initial, delay_sprites)

        if next(find_joker('Painted Joker')) and self.ability then
            for k,v in pairs(stats) do
                self.ability[k] = stats[k]
            end
        end
        

        self:ability_change(self,self)
        return ret
    end

    function Card:ability_change(self)
        if G.GAME.selected_back then G.GAME.selected_back:trigger_effect{context = 'card', other_card = self} end
        if G and G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({jimb_creating_card = true, other_card = self})
            end
        end
        if G.GAME.modifiers.jimb_xCards then 
            jokerMult(self,G.GAME.modifiers.jimb_xCards)
        end

        if G.GAME.round_resets.blind_choices and G.GAME.round_resets.blind_choices.Boss and G.GAME.round_resets.blind_choices.Boss == 'bl_jimb_zone' and not next(find_joker('Chicot')) then
            SMODS.Stickers['jimb_deteriorating']:apply(self, true)
            if G.GAME.boss_summoned then
                self:set_perishable(true)
            end
        end
    end

    local oldfunc = get_next_voucher_key
    function get_next_voucher_key()
        local ret =oldfunc()
        if jimbomod.config["Special Spectrals"] == true then
            if pseudorandom('_'.."Voucher"..G.GAME.round_resets.ante) > 0.9994+1 and not G.GAME.used_vouchers['v_jimb_release'] then
                ret = 'v_jimb_release'
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
        local selected_back = saveTable and saveTable.BACK.name or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
        selected_back = selectedback and get_deck_from_name(selected_back) or get_deck_from_name('Red Deck')
        if selected_back.name == "Deck Against Humanity" and not forced_key and _type == 'Joker' then
            _type = 'AgainstHumanity'
            area = G.jokers or area
        end

        if jimbomod.config["Special Spectrals"] == true then
            if not forced_key and soulable and (not G.GAME.banned_keys[randSpectral]) then
                if (_type == 'Joker') and
                not (G.GAME.used_jokers[randSpectral] and not next(find_joker("Showman")))  then
                    if pseudorandom('_'.._type..G.GAME.round_resets.ante) > 0.9991 then
                        forced_key = 'j_jimb_amalgam'
                    end
                end
            end



        end

        local stuff = {_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append}
        --if ouroborosActive then
        --    forced_key = 'j_jimb_ouroboros'
        --end

        if G and G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({jimb_pre_create_card = true, _type = _type, area = area, legendary = legendary, _rarity = _rarity, skip_materialize = skip_materialize, soulable = soulable, forced_key = forced_key, key_append})
            end
        end
        
        if G.GAME.next_Gen_Cards and #G.GAME.next_Gen_Cards ~= 0 and _type ~= 'Base' and G.GAME.next_Gen_Cards[1].key then
            forced_key = G.GAME.next_Gen_Cards[1].key or forced_key
        end
        
        
        --end
        local ret = oldfunc(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        if G and G.jokers and ret and ret.calculate_joker then ret:calculate_joker({self_created = true}) end
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
            if G.GAME.next_Gen_Cards[1].stickers then
                for k,v in pairs(G.GAME.next_Gen_Cards[1].stickers) do
                    if k == 'eternal' then ret.ability.eternal = true
                    elseif k == 'perishable' then ret.ability.perishable = true
                        ret.ability.perish_tally = G.GAME.perishable_rounds
                    elseif k == 'rental' then ret:set_rental(true) 
                    else SMODS.Stickers[k]:apply(ret, true)
                    end
                end
            end
            if G.GAME.next_Gen_Cards[1].edition then
                ret:set_edition({[G.GAME.next_Gen_Cards[1].edition] = true})
            end
            table.remove(G.GAME.next_Gen_Cards,1)
        end

        if G and G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({jimb_post_create_card = true, _type = _type, area = area, legendary = legendary, _rarity = _rarity, skip_materialize = skip_materialize, soulable = soulable, forced_key = forced_key, key_append, other_card = ret})
            end
        end

        if G.GAME.enable_impure_sticker and _type == 'jimb_curses' then
            if pseudorandom(('impure')..G.GAME.round_resets.ante) > 0.85 then
                SMODS.Stickers['jimb_impure']:apply(ret, true)
            end
        end
        if (area == G.shop_jokers) or (area == G.pack_cards) then
            if G.GAME.enable_deteriorating_sticker and pseudorandom(('deteriorating')..G.GAME.round_resets.ante) > 0.85 then
                SMODS.Stickers['jimb_deteriorating']:apply(ret, true)
            end
        end
        if G.GAME.negative_playing_card_spawn and  (ret.ability.set == 'Default' or ret.ability.set == 'Enhanced') then
            print('hi')
            if pseudorandom('editioned_playingcard') < G.GAME.negative_playing_card_spawn then
                ret:set_edition({negative = true},true)
            end
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
        if not a and pseudorandom('_'.."Edition"..G.GAME.round_resets.ante) > 0.9999999 and self.ability.set == 'Joker' then
            a = {jimb_nil_ = true}
            --self:add_speech_bubble('nil_' .. math.random(1,30),nil,{quip = true})
            --self:say_stuff(2,nil,{pitch = math.random(2,4)*0.2})
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
        if G.GAME.used_vouchers['v_jimb_quintessence'] then
            if self.edition and self.edition.negative then
                self.edition.card_limit = self.edition.card_limit + 0.5
            end
        end


        if self.ability and self.ability.jimb_link then
            for i = 1, #G.I.CARD do
                if G.I.CARD[i] ~= self and G.I.CARD[i].ability and G.I.CARD[i].ability.jimb_link and G.I.CARD[i].ability.jimb_link == self.ability.jimb_link then
                    oldfunc(G.I.CARD[i], a,b,c)
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


    local oldfunc = poll_edition
    function poll_edition(_key, _mod, _no_neg, _guaranteed, _options)
        _mod = _mod or 1
        if G.GAME.allow_negative then
            _no_neg = nil
        end
        local ret = oldfunc(_key, G.GAME.negative_appear_chance and _mod*G.GAME.negative_appear_chance or _mod, _no_neg, _guaranteed, _options)
        if ret and ret.negative then
            return ret
        else
            return oldfunc(_key, _mod, _no_neg, _guaranteed, _options)
        end
    end

    local oldfunc = Card.use_consumeable
    function Card:use_consumeable(area, copier)
        if self.ability.set == 'jimb_curses' then
            if self and self.purified ~= nil and self.purified == false then
                self.purified = true
                for i = 1, #G.jokers.cards do
                    G.jokers.cards[i]:calculate_joker({jimb_purify = true, other_card = self,})
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
        if ret == 'bl_jimb_zone' then
            if to_big(G.GAME.round_resets.ante) < to_big(4) then
                return get_new_boss()
            end
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

    local oldfunc = to_big
    function to_big(num)
        if oldfunc then return oldfunc(num) end
        return num
    end

    local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
    function G.UIDEF.use_and_sell_buttons(card)
        if card.ability.set == 'jimb_curses' then
            local selected_back = (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
            selected_back = get_deck_from_name(selected_back)
            if selected_back.name == "Sinner's Deck" then
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


    function Card:add_speech_bubble(text_key, align, loc_vars)
        if self.children.speech_bubble then self.children.speech_bubble:remove() end
        self.config.speech_bubble_align = {align=align or 'bm', offset = {x=0,y=0},parent = self}
        self.children.speech_bubble = 
        UIBox{
            definition = G.UIDEF.speech_bubble(text_key, loc_vars),
            config = self.config.speech_bubble_align
        }
        self.children.speech_bubble:set_role{
            role_type = 'Minor',
            xy_bond = 'Weak',
            r_bond = 'Strong',
            major = self,
        }
        self.children.speech_bubble.states.visible = false
    end

    function Card:say_stuff(n, not_first, args)
        --args stuff

        --args.pitch
        --args.monologue
        if not args.monologue then return end

        if not self.children.speech_bubble then
            if type(args.monologue) ~= 'table' then args.monologue = {args.monologue} end
            self:add_speech_bubble(args.monologue[1], nil, {quip = true})
        end

        self.children.speech_bubble.states.visible = true
        self.talking = true
        if not not_first then 
            self.starting_talk = n
            --n = n * math.max(G.SETTINGS.GAMESPEED,1)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blockable = true, blocking = false,
                delay = 0.1,
                func = function()
                    if self.children.speech_bubble then self.children.speech_bubble.states.visible = true end
                    self:say_stuff(n, true,args)
                return true
                end
            }))
        else
            if n <= 0 then 
                self.talking = false
                if self.children.speech_bubble then

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = true, blocking = false, timer = 'REAL',
                        delay = 3,
                        func = function()
                            self.children.speech_bubble.states.visible = false 
                        return true
                        end
                    }), 'tutorial')
                end

                table.remove(args.monologue,1)
                if args.monologue[1] then
                    delay(1)
                    self:add_speech_bubble(args.monologue[1], nil, {quip = true})
                    self:say_stuff(self.starting_talk or 10, not_first, args) 
                end
                --[[G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = args and args.duration or 7,
                    func = function()
                        if self.children.speech_bubble then self.children.speech_bubble.states.visible = false end
                    return true
                    end
                }))]]
                return 
            end
            local new_said = math.random(1, 11)
            while new_said == self.last_said do 
                new_said = math.random(1, 11)
            end
            self.last_said = new_said
            --if n % math.max(G.SETTINGS.GAMESPEED,1) == 0 then
                play_sound('voice'..math.random(1, 11), args and args.pitch or 1, 0.5)
                self:juice_up()
            --end
            


            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blockable = true, blocking = false, timer = 'REAL',
                delay = 0.2,
                func = function()
                    self:say_stuff(n-1, true,args)
                return true
                end
            }), 'tutorial')
        end
    end


    local oldfunc = level_up_hand
    function level_up_hand(card, hand, instant, amount)
        if G and G.jokers then
            for i = 1, #G.jokers.cards do
                local effect = G.jokers.cards[i]:calculate_joker({jimb_pre_level_up = true, hand = hand, instant = instant, amount = amount})
                if effect then

                    if effect.level then
                        amount = effect.level
                    end
                    if effect.hand then
                        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {
                            handname = effect.hand,
                            chips = G.GAME.hands[effect.hand].chips,
                            mult = G.GAME.hands[effect.hand].mult,
                            level= G.GAME.hands[effect.hand].level})
                        hand = effect.hand
                    end
                    if effect.card then
                        if effect.message then
                            card_eval_status_text(effect.card, 'extra', nil, nil, nil, {message = effect.message})
                        end
                    end

                end
            end
        end

        local ret = oldfunc(card,hand,instant,amount)

        if G and G.jokers then
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({jimb_level_up = true, hand = hand, instant = instant, amount = amount})
            end
        end

        return ret
    end


    local oldfunc = mod_mult
    function mod_mult(_mult)
        if G and G.jokers then
            for i = 1, #G.jokers.cards do
                local thingy = G.jokers.cards[i]:calculate_joker({jimb_modify_mult = true, mod = _mult})
                --[[if thingy then
                    _mult = to_big(_mult) + to_big(thingy)
                end]]
            end
        end
        return oldfunc(_mult)--to_big(mod_mult)
        --local ret = oldfunc(_mult)
        --return ret
    end

    local oldfunc = mod_chips
    function mod_chips(_chips)
        if G and G.jokers then
            for i = 1, #G.jokers.cards do
                local thingy = G.jokers.cards[i]:calculate_joker({jimb_modify_chips = true, mod = _chips})
                --[[if thingy then
                    _chips = to_big(_chips) + to_big(thingy)
                end]]
            end
        end
        return oldfunc(_chips)--to_big(mod_mult)
        --local ret = oldfunc(_mult)
        --return ret
    end



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
    --[
    local oldfunc = Card.start_dissolve
    function Card:start_dissolve(a,b,c,d)
        if self.ability.set == 'jimb_curses' and G.jokers then
            self:juice_up()
            return
        end
        local ret = oldfunc(self,a,b,c,d)
        return ret
    end
    --]]
    local oldfunc = Card.remove_from_deck
    function Card:remove_from_deck(a,b,c,d)
        if (self.ability.set == 'jimb_curses' or self.ability.set == 'AgainstHumanity') and G.jokers and self.jimb_area == G.jokers then
            G.jokers.config.card_limit = G.jokers.config.card_limit - 1
        end
        local ret = oldfunc(self,a,b,c,d)
        return ret
    end
    
    local spectralStuff = {
        'j_jimb_amalgam',
        'v_jimb_release',
        'e_jimb_nil_',
        'bl_storm'
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
        
        --BLIND
        for i = 1, #G.P_BLINDS do
            local spectralV = false
            for i = 1, #spectralStuff do
                if G.P_BLINDS[i].key == spectralStuff[i] then
                    spectralV = true
                end
            end
            if spectralV == true then
                SMODS.insert_pool(G.P_CENTER_POOLS["Spectral"], G.P_BLINDS[i])
                table.remove(G.P_BLINDS,i)
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

        local tableNum = 0
        for i = 1, #G.P_CENTER_POOLS['Consumeables'] do
            if G.P_CENTER_POOLS['Consumeables'][i-tableNum].set == 'jimb_curses' then
                tableNum = tableNum + 1
                table.remove(G.P_CENTER_POOLS["Consumeables"],i)
            end
        end
        local ret = oldfunc(self)
        return ret
    end


    local oldfunc = CardArea.emplace
    CardArea.emplace = function(self,card, location, stay_flipped,idunno,b,c,d)
        if card.ability.set == 'jimb_curses' and G.jokers and self == G.consumeables then
            G.jokers:emplace(card)
            return
        end
        if card.ability.set == 'jimb_curses' and G.jokers and self == G.jokers then
            card.purified = self.purified or false
            card.no_sell = true
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            card.jimb_area = G.jokers
        end
        if card.ability.set == 'AgainstHumanity' and G.jokers and self == G.consumeables then
            G.jokers:emplace(card)
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            card.jimb_area = G.jokers
            return
        end
        if G and G.jokers then 
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({pre_jimb_card_gain = true, other_card = card, area = self})
            end
        end
        
        local ret = oldfunc(self,card,location,stay_flipped,idunno,b,c,d)
        
        if G and G.jokers then 
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] then G.jokers.cards[i]:calculate_joker({jimb_card_gain = true, other_card = card, area = self}) end
            end
        end
        if G.GAME.jimb_prism and G.jokers and self == G.jokers then
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

    
    local isSuit = Card.is_suit
    function Card:is_suit(suit,bypass_debuff,flush_calc)
        local check_suit = nil
        if G and G.jokers then
            for i = 1, #G.jokers.cards do
                check_suit = G.jokers.cards[i]:calculate_joker({check_suit = true, other_card = self, suit = suit, bypass_debuff = bypass_debuff, flush_calc = flush_calc}) or check_suit
            end
        end
        if check_suit then return check_suit end

        --[[local hasCurse = false
        if G and G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == 'c_jimb_goad' and G.jokers.cards[i].purified == false then hasCurse = true end
            end
        end
        if (suit == 'Spades' and hasCurse == true) or (next(find_joker('Smeared Joker')) and suit == 'Clubs' and hasCurse == true) then
            return false
        end]]
        local ret = isSuit(self,suit,bypass_debuff,flush_calc)
        return ret
    end

    --[[local oldfunc = Card.remove_from_area
    function Card:remove_from_area()
        if next(SMODS.find_card("c_jimb_goad")).purified == true then
            self.config.real_card_limit = (self.config.real_card_limit or self.config.card_limit) - 1
            self.config.card_limit = math.max(0, self.config.real_card_limit)
        end
        local ret = oldfunc(self)
        return ret
    end
    --]]

    local oldfunc = Card.save
    function Card:save()
        local cardTable = oldfunc(self)
        if self.purified ~= nil then cardTable.purified = self.purified end
        if self.jimb_jokers then
            for i = 1, #self.jimb_jokers do
                cardTable.jimb_jokers = cardTable.jimb_jokers or {}
                cardTable.jimb_jokers[#cardTable.jimb_jokers+1] = {key = self.jimb_jokers[i].config.center.key, ability = self.jimb_jokers[i].ability}
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
                --print(self.jimb_jokers[#self.jimb_jokers].config.center.key .. ' woohoo yesss')
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

    local oldfunc = Card.calculate_joker
    Card.calculate_joker = function(self,context)

        if context.check_suit and context.blueprint then return end
        if context.jimb_modify_mult and context.blueprint then return end
        if context.jimb_modify_chips and context.blueprint then return end

        if self.ability and self.ability.jimb_link then
            for i = 1, #G.I.CARD do
                if G.I.CARD[i] ~= self and G.I.CARD[i].ability and G.I.CARD[i].ability.jimb_link and G.I.CARD[i].ability.jimb_link == self.ability.jimb_link then
                    oldfunc(G.I.CARD[i], context)
                end
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
        if context.joker_main then
            if self.ability.deteriorating then
                jokerMult(self,0.95)
            end
        end
        local ret = oldfunc(self,context)

        if context and context.blueprint and context.blueprint > 1 then
            check_for_unlock({type = 'jimb_cardboard'})
        end
        return ret
    end


    local oldfunc = G.FUNCS.toggle_shop
    G.FUNCS.toggle_shop = function(self,e)
        --if G and G.GAME and G.GAME.jimb_prism then G.GAME.jimb_prism = nil end
        local ret = oldfunc(self,e)
        return ret
    end

    local oldfunc = get_current_pool
    function get_current_pool(_type, _rarity, _legendary, _append)
        local _pool, _pool_key = oldfunc(_type, _rarity, _legendary, _append)
        if _type == 'AgainstHumanity' then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == _type then
                    _pool[#_pool+1] = G.jokers.cards[i].config.center.key
                end
            end
        end
        return _pool, _pool_key
    end

    local oldfunc = Card.update
    function Card:update(dt)

        if self.jimb_roundDebuff then
            if self.jimb_roundDebuff <= 0 then
                self.jimb_roundDebuff = nil
            else
                self:set_debuff(true)
            end
        end
        local ret = oldfunc(self,dt)
        return ret
    end

    if not G.localization.descriptions.Other['card_extra_mult'] then
        local oldfunc = generate_card_ui
        function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end,card)
            full_UI_table = oldfunc(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end,card)
            if card and card.ability and card.ability.set and (card.ability.set == 'Enhanced' or card.ability.set == 'Default') then
                local desc_nodes = full_UI_table.main
                if card.ability.mult ~= 0 and not (_c and _c.effect == 'Mult Card') and not (_c and _c.effect == 'Lucky Card') then
                    localize{type = 'other', key = 'card_extra_mult', nodes = desc_nodes, vars = {card.ability.mult}}
                end
                if card.ability.h_mult ~= 0 then
                    localize{type = 'other', key = 'card_extra_h_mult', nodes = desc_nodes, vars = {card.ability.h_mult}}
                end
                if card.ability.x_mult ~= 1 and not (_c and _c.effect == 'Glass Card') then
                    localize{type = 'other', key = 'card_extra_x_mult', nodes = desc_nodes, vars = {card.ability.x_mult}}
                end
                if card.ability.h_x_mult ~= 0 and not (_c and _c.effect == 'Steel Card') then
                    localize{type = 'other', key = 'card_extra_h_x_mult', nodes = desc_nodes, vars = {card.ability.h_x_mult}}
                end
                if card.ability.h_dollars ~= 0 and not (_c and _c.effect == 'Gold Card') then
                    localize{type = 'other', key = 'card_extra_h_dollars', nodes = desc_nodes, vars = {card.ability.h_dollars}}
                end
                if card.ability.p_dollars ~= 0 and not (_c and _c.effect == 'Lucky Card') then
                    localize{type = 'other', key = 'card_extra_p_dollars', nodes = desc_nodes, vars = {card.ability.p_dollars}}
                end
            end
            return full_UI_table
        end
    end
    local function print_table(table, num)
        num = num or 0
        local string = ''
        if num ~= 0 then
            for i = 1, num do
                string = string .. ' >>>> '
            end
            
        end
        string = string .. 'key:  '

        if table[1] then
            for i = 1, #table do
                local v = table[i]
                local k = i
                if type(v) == 'number' or type(v) == 'string' then
                    print(string .. k .. '  value: ' .. v)
                elseif type(v) == 'table' then
                    print(string ..' TABLE:')
                    print_table(v, num+1)
                else
                    print(string .. k)
                end
            end
        else
            for k,v in pairs(table) do
                if type(v) == 'number' or type(v) == 'string' then
                    print(string .. k .. '  value: ' .. v)
                elseif type(v) == 'table' then
                    print(string ..' TABLE:  ' .. k)
                    print_table(v, num+1)
                else
                    print(string .. k)
                end
            end

        end
    end

    G.FUNCS.jimb_lock_all = function(e)
        --check_for_unlock({type = 'jimb_lock_all'})
        --print('hi')
        for k,v in pairs(G.P_CENTERS) do
            if v.check_for_unlock and v.mod == jimbomod then

                v:check_for_unlock({type = 'jimb_lock_all'})
                --print('hiya bros')
            end
        end
    end

    function getStake(num)
        --code by cg or @fpschess
        local t = {}
        for i, v in pairs(G.P_STAKES) do
         t[v.order] = v
        end
        return t[num]
    end

    G.FUNCS.jimb_unlock_all = function(e)
        check_for_unlock({type = 'jimb_unlock_all'})
    end

    function lock_card(card)
        --print('yo')
        --if card.unlocked == true then
        --card.alerted = false
            --card.discovered = false
            --card.unlocked = false
            G.P_CENTERS[card.key].unlocked = false
            --if card.set == 'Back' then discover_card(card) end
            --table.sort(G.P_CENTER_POOLS["Back"], function (a, b) return (a.order - (a.unlocked and 100 or 0)) < (b.order - (b.unlocked and 100 or 0)) end)
            G:save_progress()
            --G.FILE_HANDLER.force = true
            --print(card.unlocked)
            --notify_alert(card.key, card.set)
        --end
    end
    --[[
    function create_UIBox_card_unlock(card_center)
        G.your_collection = CardArea(
        G.ROOM.T.x + G.ROOM.T.w/2,G.ROOM.T.h,
        1*G.CARD_W,
        1*G.CARD_H, 
        {card_limit = 2, type = 'consumeable', highlight_limit = 0})
        
        local card = Card(G.your_collection.T.x + G.your_collection.T.w/2 - G.CARD_W/2, G.your_collection.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, card_center, {bypass_discovery_center = true, bypass_discovery_ui = true})
        local locked_card = Card(G.your_collection.T.x + G.your_collection.T.w/2 - G.CARD_W/2, G.your_collection.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, card_center.set == 'Voucher' and G.v_locked or G.j_locked)
        locked_card:remove_UI()
        locked_card.ID = card.ID
        card.states.click.can = false
        locked_card.states.click.can = false
        card.states.visible = false
        card.no_ui = true

        locked_card:say_stuff(8, true,{
            pitch = math.random(4,6)/10,
            monologue = {'tredecim1'}
        })
    
        G.E_MANAGER:add_event(Event({timer = 'REAL',blockable = true,blocking = false,
        func = (function() G.OVERLAY_MENU.joker_unlock_table = card.ID return true end) }))
        G.E_MANAGER:add_event(Event({timer = 'REAL',blockable = true,blocking = false, trigger = 'after', delay = 0.6,
        func = (function() if G.OVERLAY_MENU and G.OVERLAY_MENU.joker_unlock_table == card.ID then locked_card:juice_up(0.3, 0.2); play_sound('cancel', 0.8) end; return true end) }))
        G.E_MANAGER:add_event(Event({timer = 'REAL',blockable = true,blocking = false, trigger = 'after', delay = 1.15,
        func = (function() if G.OVERLAY_MENU and G.OVERLAY_MENU.joker_unlock_table == card.ID then locked_card:juice_up(0.45, 0.3); play_sound('cancel', 0.92) end; return true end) }))
        G.E_MANAGER:add_event(Event({timer = 'REAL',blockable = true,blocking = false, trigger = 'after', delay = 1.8,
        func = (function() if G.OVERLAY_MENU and G.OVERLAY_MENU.joker_unlock_table == card.ID then locked_card:juice_up(0.6, 0.4); play_sound('cancel', 1.03) end; return true end) }))
    
        G.E_MANAGER:add_event(Event({
        timer = 'REAL',
        blockable = true,
        blocking = false,
        trigger = 'after', 
        delay = 2.3,
        func = (function() 
            if G.OVERLAY_MENU and G.OVERLAY_MENU.joker_unlock_table == card.ID then locked_card:start_dissolve({G.C.BLACK}) end
            return true end)
        }))
        G.E_MANAGER:add_event(Event({
        timer = 'REAL',
        blockable = true,
        blocking = false,
        trigger = 'after', 
        delay = 2.7,
        func = (function() 
            if G.OVERLAY_MENU and G.OVERLAY_MENU.joker_unlock_table == card.ID then 
                card:start_materialize({G.C.BLUE}, true)
                play_sound('crumple1', 0.8, 1);
                card:say_stuff(10, true,{
                    pitch = math.random(4,6)/10,
                    monologue = {'tredecim2'}
                })
            end
            return true end)
        }))
        G.E_MANAGER:add_event(Event({timer = 'REAL',blockable = false,blocking = false, trigger = 'after', delay = 2.78,
        func = (function() if G.OVERLAY_MENU and G.OVERLAY_MENU.joker_unlock_table == card.ID then card.no_ui = nil; play_sound('timpani', 0.8, 1.8) end return true end) }))
        G.E_MANAGER:add_event(Event({timer = 'REAL',blockable = false,blocking = false, trigger = 'after', delay = 2.95,
        func = (function() if G.OVERLAY_MENU and G.OVERLAY_MENU.joker_unlock_table == card.ID then play_sound('timpani', 1, 1.8)  end return true end) }))
        
        G.your_collection:emplace(card)
        G.your_collection:emplace(locked_card)
    
        local t = create_UIBox_generic_options({padding = 0,back_label = localize('b_continue'), no_pip = true, snap_back = true, back_func = 'continue_unlock', minw = 4.5, contents = {
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                    {n=G.UIT.O, config={object = DynaText({string = {card_center.set == 'Voucher' and localize('k_voucher') or localize('k_joker')}, colours = {G.C.BLUE},shadow = true, rotate = true, bump = true, pop_in = 0.3, pop_in_rate = 2, scale = 1.2})}}
                }},
                {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                    {n=G.UIT.O, config={object = DynaText({string = {localize('k_unlocked_ex')}, colours = {G.C.RED},shadow = true, rotate = true, bump = true, pop_in = 0.6, pop_in_rate = 2, scale = 0.8})}}
                }},
                }},
                {n=G.UIT.R, config={align = "cm", padding = 0, draw_layer = 1}, nodes={
                {n=G.UIT.O, config={object = G.your_collection}}
                }},
                {n=G.UIT.R, config={align = "cm", padding = 0.2}, nodes={
                {n=G.UIT.R, config={align = "cm", padding = 0.05, emboss = 0.05, colour = G.C.WHITE, r = 0.1}, nodes={
                    desc_from_rows(card:generate_UIBox_unlock_table(true).main)
                }}
                }}
            }}
            }}
        }})
        return t
    end
    --]]

    local stupid_events = {
        function(context)
            local rarity = math.random(1,4)
            --joker rarity change to one specific rarity
            for k,v in pairs(G.P_CENTER_POOLS['Joker']) do
                if k ~= 'j_joker' and k~='j_mime' and k~='j_blueprint' and j~='j_perkeo' then
                    G.P_CENTER_POOLS['Joker'][k].rarity = rarity
                end
            end
            print('rarity change')
        end,
        function(context)
            local jolly = G.P_CENTERS['j_jolly']
            for k,v in pairs(G.P_CENTER_POOLS['Joker']) do
                if G.P_CENTER_POOLS['Joker'][k].key ~='j_jolly' and G.P_CENTER_POOLS['Joker'][k].key ~='j_mime' and G.P_CENTER_POOLS['Joker'][k].key ~='j_blueprint' and G.P_CENTER_POOLS['Joker'][k].key ~='j_perkeo' then
                    --local key = G.P_CENTER_POOLS['Joker'][k].key
                    --local rarity = G.P_CENTER_POOLS['Joker'][k].rarity
                    G.P_CENTER_POOLS['Joker'][k] = jolly
                    --G.P_CENTER_POOLS['Joker'][k].key = key
                    --G.P_CENTER_POOLS['Joker'][k].rarity = rarity
                end
            end
            print('Jolly.')
        end,
        function(context)
            local os1 = love._o
            if os1 == "OS X" then
                os.execute("open https://www.youtube.com/watch?v=Zp-4U5TlbxY")
                print('os x')
            elseif os1 == "Windows" then
                os.execute("start https://www.youtube.com/watch?v=Zp-4U5TlbxY")
                print('windows')
            elseif os1 == "Linux" then
                os.execute("xdg-open https://www.youtube.com/watch?v=Zp-4U5TlbxY")
                print('linux')
            end
            print('Start')
        end,
        
    }

    G.FUNCS.jimb_fuck_shit_up = function(e)
        pseudorandom_element(stupid_events,pseudoseed('stupidity'))()
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
    --
                settings.nodes[#settings.nodes + 1] =
                    UIBox_button({button = 'jimb_lock_all', label = {"Lock All"},  minw = 5, minh = 1.7, scale = 0.6, id = 'jimb_lock_all'})
                settings.nodes[#settings.nodes + 1] =
                    UIBox_button({button = 'jimb_unlock_all', label = {"Unlock All"},  minw = 5, minh = 1.7, scale = 0.6, id = 'jimb_lock_all'})

                settings.nodes[#settings.nodes + 1] =
                    UIBox_button({button = 'jimb_fuck_shit_up', label = {"Fuck shit up"},  minw = 5, minh = 1.7, scale = 0.6, id = 'jimb_fuck_shit_up'})

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


----functions





---CONGRATS ON ENTERING MY SECRET EVIL SCRIPTING LAIR........ BUT BEWARE..... THIS CODE SUCKS BALLS!!! MUAHAHAHAHAHAHAHA





----vouchers
    local aether = SMODS.Voucher{
        key = 'aether',
        loc_txt = {
            name = "Aether",
            text = {
                '{C:dark_edition}Negative{} playing cards may appear',
                'and have a {C:attention}#1#% chance{}',
                'to appear in packs'
            },
        },
        cost = 10,
        unlocked = true,
        discovered = false,
        loc_vars = function(self, info_queue, center)
            return {vars = {center.ability.extra.chance}}
        end,
        in_pool = function(self,wawa,wawa2)
            return false
        end,
        redeem = function(self)
            G.GAME.allow_negative = true
            G.GAME.negative_playing_card_spawn = self.config.extra.chance / 100
        end,
        config = {extra = {chance = 10,}},
        --pos = {x = 0, y = 0},
        --atlas = 'Vouchers',
    }
    local quintessence = SMODS.Voucher{
        key = 'quintessence',
        loc_txt = {
            name = "Quintessence",
            text = {
                '{C:dark_edition}Negative{} playing cards',
                'give {C:attention}+#1#{} hand size',
            },
        },
        requires = {'v_jimb_aether'},
        cost = 10,
        unlocked = true,
        discovered = false,
        loc_vars = function(self, info_queue, center)
            return {vars = {center.ability.extra.cardlimit}}
        end,
        redeem = function(self)
            for i = 1, #G.playing_cards do
                local card = G.playing_cards[i]
                if card.edition and card.edition.negative then
                    card.edition.card_limit = card.edition.card_limit + self.config.extra.cardlimit
                end
            end
        end,
        in_pool = function(self,wawa,wawa2)
            return false
        end,
        config = {extra = {cardlimit = 0.5,}},
        --pos = {x = 0, y = 0},
        --atlas = 'Vouchers',
    }
----vouchers


-----consumables and related    
    SMODS.Consumable {
        key = 'antiparticle',
        set = 'Spectral',
        loc_txt = {
            name = 'Antiparticle',
            text = {
                '{C:green}#1# in #2#{} chance to',
                'add {C:dark_edition}Negative{} to up',
                'to {C:attention}#3#{} selected cards, otherwise',
                '{C:red}destroy{} selected cards'
            }
        },
        config = {extra = {odds = 3, cards = 3}},
        pos = { x = 2, y = 6 },
        cost = 6,
        unlocked = true,
        discovered = false,
        atlas = 'Tarot',
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue+1] = G.P_CENTERS.e_negative
            return {vars = {G.GAME.probabilities.normal*2, center.ability.extra.odds, math.ceil(center.ability.extra.cards)}}
        end,
        can_use = function(self, card)
            if #G.hand.highlighted <= math.ceil(card.ability.extra.cards) and #G.hand.highlighted ~= 0 then
                return true
            end
            return false
        end,
        use = function(self, card, area, copier)
            if area then area:remove_from_highlighted(card) end
            if pseudorandom('antiparticle') < G.GAME.probabilities.normal*2/card.ability.extra.odds then
                for i = 1, #G.hand.highlighted do
                    if not (G.hand.highlighted.edition and G.hand.highlighted.edition.negative) then G.hand.highlighted[i]:set_edition({negative = true},true) end
                end
            else
                for i = 1, #G.hand.highlighted do
                    G.hand.highlighted[i]:start_dissolve()
                end
            end
        end,
        in_pool = function(self,card,wawa)
            return true
        end,
    }

    local frames = 0
    SMODS.Consumable {
        key = 'chaos',
        set = 'Spectral',
        loc_txt = {
            name = 'Chaos',
            text = {
                '{C:legendary}Randomizes{} values of',
                'up to {C:attention}#1#{} selected cards'
            }
        },
        config = {extra = {odds = 3, cards = 3}},
        pos = { x = 6, y = 6 },
        cost = 6,
        unlocked = true,
        discovered = false,
        atlas = 'Tarot',
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue+1] = G.P_CENTERS.e_negative
            return {vars = {math.ceil(center.ability.extra.cards)}}
        end,
        can_use = function(self, card)
            if #G.hand.highlighted <= math.ceil(card.ability.extra.cards) and #G.hand.highlighted ~= 0 then
                return true
            end
            return false
        end,
        use = function(self, card, area, copier)
            if area then area:remove_from_highlighted(card) end
            for i = 1, #G.hand.highlighted do
                local stats = {
                    'mult', --played mult
                    'h_mult', --held mult
                    'h_x_mult', --held xmult
                    'h_dollars', --held dollar gain
                    'p_dollars', --played dollar gain
                    'x_mult', --played xmult
                }
                for ii = 1, 3 do
                    local index = pseudorandom('chaos',1,#stats)
                    local min = -100
                    local max = 350
                    local operation = operationfuncs[2]
                    if stats[index] == 'x_mult' or stats[index] == 'h_x_mult' then
                        min = 50
                        max = 300
                        operation = operationfuncs[1]
                    end
                    G.hand.highlighted[i].ability[stats[index]] = G.hand.highlighted[i].ability[stats[index]] == 0 and 1 or G.hand.highlighted[i].ability[stats[index]]
                    local stat = pseudorandom('chaos_stat', min, max)/100
                    G.hand.highlighted[i].ability[stats[index]] = operation(G.hand.highlighted[i].ability[stats[index]], stat)
                    table.remove(stats,index)
                end
            end
        end,
        in_pool = function(self,card,wawa)
            return true
        end,
        update = function(self,card,dt)
            frames = frames+1
            if frames % 5 == 0 then
                card.children.center:set_sprite_pos({x = math.random(6,8), y = 6})
            end
        end,
        remove_from_deck = function(self,card,from_debuff)
            frames = 0
        end,
    }

    --[

    function jimb_link_cards(cards)
        --literally just bunco linking cards. i'll ask em about it later lmfao. sorry firch :heart:
        G.GAME.jimb_last_card_group = (G.GAME.jimb_last_card_group or 0) + 1

        for i = 1, #cards do
            --if (not ignore_groups) or (ignore_groups and not cards[i].ability.group) then
                cards[i].ability.jimb_link = G.GAME.jimb_last_card_group
            --end
        end
    end

    local oldfunc = Card.set_debuff
    function Card:set_debuff(should_debuff)
        local ret = oldfunc(self,should_debuff)
        if self.ability and self.ability.jimb_link then
            for i = 1, #G.I.CARD do
                if G.I.CARD[i] ~= self and G.I.CARD[i].ability and G.I.CARD[i].ability.jimb_link and G.I.CARD[i].ability.jimb_link == self.ability.jimb_link then
                    oldfunc(G.I.CARD[i], should_debuff)
                end
            end
        end
        return ret
    end


    --[[]
    SMODS.Consumable {
        key = 'bind',
        set = 'Spectral',
        loc_txt = {
            name = 'Bind',
            text = {
                '{C:blue}Link{} {C:attention}#1#{} selected',
                'cards',
                'and add {C:blue}Perishable{}',
                'to them'
            }
        },
        config = {extra = {cards = 3}},
        pos = { x = 9, y = 6 },
        cost = 6,
        unlocked = true,
        discovered = false,
        atlas = 'Tarot',
        loc_vars = function(self, info_queue, center)
            return {vars = {math.ceil(center.ability.extra.cards)}}
        end,
        can_use = function(self, card)
            if G and G.hand and G.hand.highlighted and G.hand.highlighted[1] and #G.hand.highlighted <= math.ceil(card.ability.extra.cards) then
                return true
            end
            return false
        end,
        use = function(self, card, area, copier)
            jimb_link_cards(G.hand.highlighted)
            for i = 1, #G.hand.highlighted do
                G.hand.highlighted[i].ability.perishable = true
            end
        end,
        in_pool = function(self,card,wawa)
            return true
        end,
    }
    local bindeddeck = SMODS.Back{
        key = "binded",
        name = "Binded Deck",
        pos = {x = 0, y = 0},
        unlocked = true,
        loc_txt = {
            name = "Binded Deck",
            text = {
            "Start with a",
            "linked deck",
            },
        },
        atlas = "Decks",
        apply = function(back) 
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blockable = false,
                delay =  1,
                func = (function()
                    for i = 1, #G.playing_cards do
                        --if (not ignore_groups) or (ignore_groups and not cards[i].ability.group) then
                        G.playing_cards[i].ability.jimb_link = 1
                        --end
                    end
                    return true 
                end)
            }))
        end,
        trigger_effect = function(self,args)
            if args.context == "card" then
                args.other_card.ability.jimb_link = 1
            end
        end
    }

    --]]

    --[[

    SMODS.Consumable {
        key = 'mutilate',
        set = 'Spectral',
        loc_txt = {
            name = 'Mutilate',
            text = {
                "Enhances {C:attention}#1#",
                "selected cards to",
                "{C:red}Flesh Cards"
            }
        },
        config = {extra = {cards = 3}},
        pos = { x = 9, y = 5 },
        cost = 6,
        unlocked = true,
        discovered = false,
        atlas = 'Tarot',
        loc_vars = function(self, info_queue, center)
            info_queue[#info_queue+1] = G.P_CENTERS['m_jimb_flesh']
            return {vars = {math.ceil(center.ability.extra.cards)}}
        end,
        can_use = function(self, card)
            if #G.hand.highlighted <= math.ceil(card.ability.extra.cards) and #G.hand.highlighted ~= 0 then
                return true
            end
            return false
        end,
        use = function(self, card, area, copier)
            if area then area:remove_from_highlighted(card) end
            for i = 1, #G.hand.highlighted do
                G.hand.highlighted[i]:set_ability(G.P_CENTERS['m_jimb_flesh'])
            end
        end,
        in_pool = function(self,card,wawa)
            return true
        end,
    }
    local stupidnumber = 1
    local flesh = SMODS.Enhancement {
        key = 'flesh',
        loc_txt = {
            name = 'Flesh Card',
            text = {
                "I don't know :("
            }
        },
        pos = {x = 0, y = 0}, 
        atlas = 'Soulj', 
        config = {x_mult = 1, extra ={Xmult_mod = 0.2}},
        discovered = false,
        loc_vars = function(self, info_queue, card)
            return { vars = {card and card.ability.x_mult or 1, self and self.config and self.config.extra and self.config.extra.Xmult_mod or 0.2} }
        end,
        calculate = function(self, card, context)
            
            if context.cardarea == G.play and not card.getting_sliced then
                if stupidnumber == 1 then
                    stupidnumber = 2
                    
                else
                    stupidnumber = 1 
                end
            end
        end,
        update = function(self, card, dt)
            card.frames = card.frames or 0
            card.frames = card.frames+1
            if card.frames <= 10 then
                --
            elseif card.frames >= 10 then
                --
            elseif card.frames >= 30 then
                card.frames = 0
            else
                --
            end

            
            --print('yooo')
        end
    }
    --]]
-----consumables and related

----boring jokers
    --Googly Joker
    local googly = SMODS.Joker{
        key = 'googly',
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
    --[[
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
        cost = 4,
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
                    chip_mod = card.ability.extra.chips, 
                    card = card,
                    message = '+' ..card.ability.extra.chips
                }
            end
        end
    end]]
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
        config = {extra = {chips = 1.3}},
        pos = { x = 2, y = 0 },
        atlas = 'Jokers',
        cost = 8,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,
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
                    chip_mod = 0,
                    message = "X" .. card.ability.extra.chips,
                    colour = G.C.BLACK
                }
            end
        end
    end

    local unlockedjokers = 0
    local triedthat = false
    local pixel = SMODS.Joker{
        key = 'pixel',
        loc_txt = {
            name = "Pixel Joker",
            text = {
                "{C:mult}+#1#{} Mult for",
                'every unlocked card',
                '{C:inactive}(Currently{} {C:mult}+#2#{} {C:inactive}Mult)'
            }
        },
        rarity = 2,
        config = {extra = {mult = 0.075}},
        pos = { x = 0, y = 8 },
        atlas = 'Jokers',
        cost = 8,
        unlocked = true,
        discovered = false,
        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            if triedthat == false then
                triedthat = true
                unlockedjokers = 0
                for k,v in pairs(G.P_CENTERS) do
                    if v.unlocked == true then
                        unlockedjokers = unlockedjokers+1
                    end
                end
            end
            return {vars = {center.ability.extra.mult, unlockedjokers*center.ability.extra.mult}}
        end,
        in_pool = function(self,wawa,wawa2)
            if jimbomod.config["Jokers"] == true then
                return true
            else
                return false
            end
        end,
        calculate = function(self, card, context)
            unlockedjokers = 0
            for k,v in pairs(G.P_CENTERS) do
                if v.unlocked == true then
                    unlockedjokers = unlockedjokers+1
                end
            end
            if context.joker_main then
                return{
                    mult_mod = math.floor(unlockedjokers*card.ability.extra.mult),
                    message = '+'.. math.floor(unlockedjokers*card.ability.extra.mult),
                    card = card,
                }
            end
        end
    }

    local graffiti = SMODS.Joker{
        key = 'Graffiti',
        loc_txt = {
            name = "Graffiti Joker",
            text = {
                "Whenever a modified card",
                'is scored, give {C:mult}+#1#{} Mult'
            }
        },
        rarity = 2,
        config = {extra = {mult = 7}},
        pos = { x = 1, y = 7 },
        atlas = 'Jokers',
        cost = 8,
        unlocked = true,
        discovered = false,
        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            return {vars = {center.ability.extra.mult}}
        end,
        in_pool = function(self,wawa,wawa2)
            if jimbomod.config["Jokers"] == true then
                return true
            else
                return false
            end
        end,
        calculate = function(self, card, context)
        
            if context.individual and context.cardarea == G.play then
                if (context.other_card.config.center ~= G.P_CENTERS.c_base) or (context.other_card.edition) or (context.other_card.seal) then
                    --print('hi')
                    return {
                        mult = card.ability.extra.mult, 
                        card = card,
                        message = localize {
                            type = 'variable',
                            key = 'a_mult',
                            vars = { card.ability.extra.mult}
                        }
                    }
                end
            end
        end
    }
    --[[
    local painted = SMODS.Joker{
        key = 'painted',
        loc_txt = {
            name = "Painted Joker",
            text = {
                "{C:attention}Changing, readding or removing",
                'an {C:attention}enhancement{} will not',
                'remove the enhancement effect'
            }
        },
        rarity = 3,
        config = {extra = {}},
        pos = { x = 1, y = 14 },
        atlas = 'Jokers',
        cost = 8,
        unlocked = true,
        discovered = false,
        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,
        in_pool = function(self,wawa,wawa2)
            if jimbomod.config["Jokers"] == true then
                return true
            else
                return false
            end
        end,
    }
    ]]


    local danger = SMODS.Joker{
        key = 'sign',
        loc_txt = {
            name = "Danger Sign",
            text = {
                "{X:mult,C:white}X#1#{} Mult if no discards","have been used this round"
            },
        },
        config = {extra = {Xmult = 2}},
        rarity = 2,
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
----boring jokers

---food? jokers

    local vinyl = SMODS.Joker{
        key = 'vinyl',
        loc_txt = {
            name = "Vinyl",
            text = {
                "{C:attention}Copies the ability{} of",
                'a random {C:attention}Joker{} every round',
                "{C:green}#1# in #2#{} chance this card",
                "is destroyed at end of round",
            }
        },
        config = {extra = {odds = 6}},
        rarity = 2,
        pos = {x = 1, y = 15},
        atlas = 'Jokers',
        cost = 7,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        loc_vars = function(self, info_queue, center)
            local card_example = nil
            if center.jimb_jokers then
                local cardkeys = {}
                for i = 1, #center.jimb_jokers do
                    cardkeys[#cardkeys+1]=center.jimb_jokers[i].config.center.key
                end

                card_example, cards = center and center.jimb_jokers and center.jimb_jokers[1] and create_card_example(cardkeys) or ((not (G and G.jokers)) and create_card_example({'j_joker'})) or nil


                for i = 1, #center.jimb_jokers do
                    info_queue[#info_queue + 1] = {
                        set = "Joker",
                        key = center.jimb_jokers[i].config.center.key,
                        specific_vars = false and center.jimb_jokers[i].config.center.loc_vars and center.jimb_jokers[i].config.center:loc_vars(info_queue, center.jimb_jokers[i]) or {'???','???','???','???'},
                    }
                end
            end
            return {
                vars = {G.GAME.probabilities.normal, center.ability.extra.odds},
                main_end = center and center.jimb_jokers and {card_example}
            }
        end,
        calculate = function(self,card,context)
            local other_joker = card.jimb_jokers[1]
            if other_joker and other_joker.calculate_joker then
                context.blueprint = (context.blueprint and (context.blueprint + 1)) or 0
                context.blueprint_card = context.blueprint_card or self
                local other_joker_ret = other_joker:calculate_joker(context)
                if other_joker_ret then 
                    other_joker_ret.card = context.blueprint_card or self
                    other_joker_ret.colour = G.C.BLUE
                    card:juice_up()
                    --return other_joker_ret
                end
            end

            if context.setting_blind then
                local list = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] and G.jokers.cards[i] ~= card and G.jokers.cards[i].config.center.blueprint_compat == true then
                        list[#list+1] = G.jokers.cards[i]
                    end
                end

                card.jimb_jokers[1] = pseudorandom_element(list, pseudoseed('hoi'))
            end

            if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
                if pseudorandom('vinyl') < G.GAME.probabilities.normal/card.ability.extra.odds then 
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(card)
                                        card:remove()
                                        card = nil
                                    return true; end})) 
                            return true
                        end
                    })) 
                    G.GAME.jimb_vinyl_broken = true
                    return {
                        message = 'Broken!'
                    }
                else
                    return {
                        message = "Rockin'!"
                    }
                end
            end
        end,
        in_pool = function(self,wawa,wawa2)
            if jimbomod.config["Jokers"] == true and not G.GAME.jimb_vinyl_broken then
                return true
            else
                return false
            end
        end,
    }

    local broken_record = SMODS.Joker{
        key = 'broken_record',
        loc_txt = {
            name = "Broken Record",
            text = {
                "{C:attention}Copies the ability{} of",
                'every {C:attention}Joker{} sold',
                "this Ante",
            }
        },
        config = {extra = {odds = 6}},
        rarity = 2,
        pos = {x = 2, y = 15},
        atlas = 'Jokers',
        cost = 7,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        loc_vars = function(self, info_queue, center)
            local card_example = nil
            if center.jimb_jokers then
                local cardkeys = {}
                for i = 1, #center.jimb_jokers do
                    cardkeys[#cardkeys+1]=center.jimb_jokers[i].config.center.key
                end

                card_example, cards = center and center.jimb_jokers and center.jimb_jokers[1] and create_card_example(cardkeys) or ((not (G and G.jokers)) and create_card_example({'j_joker'})) or nil


                for i = 1, #center.jimb_jokers do
                    info_queue[#info_queue + 1] = {
                        set = "Joker",
                        key = center.jimb_jokers[i].config.center.key,
                        specific_vars = false and center.jimb_jokers[i].config.center.loc_vars and center.jimb_jokers[i].config.center:loc_vars(info_queue, center.jimb_jokers[i]) or {'???','???','???','???'},
                    }
                end
            end
            return {
                vars = {G.GAME.probabilities.normal, center.ability.extra.odds},
                main_end = center and center.jimb_jokers and center.jimb_jokers[1] and {card_example}
            }
        end,
        calculate = function(self,card,context)
            if not context.selling_card then
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
            end

            if context.selling_card and context.card.ability.set == 'Joker' and context.card.ability.name ~= card.ability.name then
                card.jimb_jokers[#card.jimb_jokers+1] = context.card
            end

            if context.jimb_new_ante then card.jimb_jokers = {} end

        end,
        in_pool = function(self,wawa,wawa2)
            if jimbomod.config["Jokers"] == true and G.GAME.jimb_vinyl_broken then
                return true
            else
                return false
            end
        end,
    }


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
        pos = {x = 1, y = 6},
        atlas = 'Jokers',
        cost = 5,
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
        config = {extra = {Xmult = 1, Xmult_mod = 0.2}},
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

    local pizzabox = SMODS.Joker{
        key = 'pizzabox',
        loc_txt = {
            name = "Pizza Box",
            text = {
                "In {C:attention}#1# rounds,",
                "sell this card to create",
                "{C:attention}#2# Regular{} Pizza Slices",
            }
        },
        config = {extra = {rounds = 3, slices = 5}},
        rarity = 3,
        pos = {x = 1, y =8},
        atlas = 'Jokers',
        cost = 10,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            return {vars = {math.max(math.floor(center.ability.extra.rounds),0),math.floor(center.ability.extra.slices)}}
        end,
        calculate = function(self,card,context)
            if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
                card.ability.extra.rounds = math.floor(card.ability.extra.rounds - 1)
            end
            if context.selling_self and card.ability.extra.rounds <= 0 then
                for i = 1, math.max(math.floor(card.ability.extra.slices),1) do
                    local newcard = create_card("Joker",G.jokers,nil,nil,nil,nil,'j_jimb_pizzaslice')
                    newcard:add_to_deck()
                    G.jokers:emplace(newcard)
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

    local pizzaslice = SMODS.Joker{
        key = 'pizzaslice',
        loc_txt = {
            name = "Pizza Slice",
            text = {
                '{C:dark_edition}+1 Joker Slot',
                "Whenever a {C:attention}Pizza Slice{}",
                "is sold, gain {X:mult,C:white}X#1#{} Mult",
                "{C:inactive}(Currently{} {X:mult,C:white}X#2#{} {C:inactive}Mult)"
            }
        },
        config = {extra = {Xmult = 1, Xmult_mod = 0.2}},
        rarity = 3,
        pos = {x = 2, y = 8},
        atlas = 'Jokers',
        cost = 1,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = true,
        loc_vars = function(self, info_queue, center)
            return {vars = {center.ability.extra.Xmult_mod,center.ability.extra.Xmult}}
        end,
        calculate = function(self,card,context)
            if context.selling_card and context.card.ability.name == card.ability.name then
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
        add_to_deck = function(self,card, from_debuff)
            if G and G.jokers then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,
        remove_from_deck = function(self,card,from_debuff)        
            if G and G.jokers then
                G.jokers.config.card_limit = G.jokers.config.card_limit - 1
            end
        end,
        in_pool = function(self,wawa,wawa2)
            return false
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
        cost = 5,
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
---food? jokers


--cool jokers

    ----regular jokers
        local prosopometamorphopsia = SMODS.Joker{
            key = 'prosopometamorphopsia',
            loc_txt = {
                name = "Prosopometamorphopsia",
                text = {
                    "Every played {C:attention}face card{}", 
                    "permanently gains", 
                    "{C:mult}+#1#{} Mult when scored"
                }
            },
            config = {extra = {mult_mod = 3}},
            rarity = 2,
            pos = {x = 0, y = 11},
            atlas = 'Jokers',
            cost = 6,
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
        local ritual = SMODS.Joker{
            key = 'ritual',
            loc_txt = {
                name = "Ritual",
                text = {
                    "Destroy all {C:attention}unscoring cards{}", 
                    "{C:attention}Scored{} cards gain {X:mult,C:white}X#1#{} Mult", 
                    "per {C:attention}unscoring card"
                }
            },
            config = {extra = {mult_mod = 0.05}},
            rarity = 3,
            pos = {x = 2, y = 10},
            atlas = 'Jokers',
            cost = 8,
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
                    unscored = 0
                    local unscoredd = {}
                    for i = 1, #context.full_hand do
                        local unscoring = true
                        for _i = 1, #context.scoring_hand do
                            if context.full_hand[i] == context.scoring_hand[_i] then
                                unscoring = false
                            end
                        end
                        if unscoring == true then
                            unscoredd[#unscoredd+1] = context.full_hand[i]
                            unscored = unscored + 1
                        end
                    end
                    local num = 0
                    for i = 1, #unscoredd do
                        unscoredd[i]:remove()
                        num = num + 1
                    end
                    num = 0
                    unscoredd = {}
                end
                    if context.individual and context.cardarea == G.play then
                            context.other_card.ability.x_mult = context.other_card.ability.x_mult + card.ability.extra.mult_mod*unscored or card.ability.extra.mult_mod*unscored
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


        local ambidextrous = SMODS.Joker{
            key = 'ambidextrous',
            loc_txt = {
                name = "Ambidextrous",
                text = {
                    "Cards also count as",
                    '{C:attention}held in hand{} when',
                    '{C:attention}scored'
                }
            },
            config = {extra = {}},
            rarity = 2,
            pos = {x = 0, y = 0},
            atlas = 'Soulj',
            cost = 8,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {}}
            end,
            calculate = function(self,card,context)
                if context.individual and context.cardarea == G.play then
                    local effects = {eval_card(context.other_card, {cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands})}
                    for k=1, #G.jokers.cards do
                        --calculate the joker individual card effects
                        local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = context.other_card, individual = true})
                        if eval then 
                            mod_percent = true
                            table.insert(effects, eval)
                        end
                    end
                    for ii = 1, #effects do
                        --if this effect came from a joker
                        if effects[ii].card then
                            mod_percent = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'immediate',
                                func = (function() effects[ii].card:juice_up(0.7);return true end)
                            }))
                        end
                        
                        --If hold mult added, do hold mult add event and add the mult to the total
                        
                        --If dollars added, add dollars to total
                        if effects[ii].dollars then 
                            ease_dollars(effects[ii].dollars)
                            card_eval_status_text(context.other_card, 'dollars', effects[ii].dollars, percent)
                        end

                        if effects[ii].h_mult then
                            mod_percent = true
                            mult = mod_mult(mult + effects[ii].h_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(context.other_card, 'h_mult', effects[ii].h_mult, percent)
                        end

                        if effects[ii].x_mult then
                            mod_percent = true
                            mult = mod_mult(mult*effects[ii].x_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(context.other_card, 'x_mult', effects[ii].x_mult, percent)
                        end

                        if effects[ii].message then
                            mod_percent = true
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(context.other_card, 'extra', nil, percent, nil, effects[ii])
                        end
                    end
                    --return trueEffects
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
                name = "Doomsday Clock",
                text = {
                    "{C:attention}Duplicate all Jokers you gain{}",
                    "{C:green}#1# in #2#{} chance to destroy all {C:attention}Jokers{}",
                    "whenever a context is triggered",
                    '{C:inactive}ie. playing hand, discarding...',
                    '{C:inactive}Bypasses Eternal'

                }
            },
            config = {extra = {odds = 100000}},
            rarity = 3,
            pos = {x = 1, y = 9},
            atlas = 'Jokers',
            cost = 8,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {G.GAME.probabilities.normal,center.ability.extra.odds}}
            end,
            calculate = function(self,card,context)
                card:set_eternal(true)
                if context.jimb_card_gain and not context.other_card.ability.isDuped and context.other_card.ability.set == 'Joker' and context.other_card ~= card and context.area == G.jokers and not context.self_created then
                    context.other_card.ability.isDuped = true
                    local newcard = copy_card(context.other_card,nil)
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
            pos = {x = 3, y = 0},
            soul_pos = {x = 3, y = 1},
            atlas = 'Soulj',
            cost = 7,
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
            pos = {x = 0, y = 10},
            atlas = 'Jokers',
            cost = 0,
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
                        os.execute("open https://www.youtube.com/watch?v=Zp-4U5TlbxY")
                        print('os x')
                    elseif os1 == "Windows" then
                        os.execute("start https://www.youtube.com/watch?v=Zp-4U5TlbxY")
                        print('windows')
                    elseif os1 == "Linux" then
                        os.execute("xdg-open https://www.youtube.com/watch?v=Zp-4U5TlbxY")
                        print('linux')
                    end
                    card:start_dissolve()
                end
            end,
            in_pool = function(self,wawa,wawa2)
                if jimbomod.config["Jokers"] == true then
                    return false
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
                    'When sold, the next card',
                    'generated is {C:attention}#1#{}',
                    'Joker changes at end of round'
                }
            },
            config = {extra = {
                joker = nil,
            }},
            rarity = 3,
            pos = {y = 4, x = 0},
            atlas = 'Jokers',
            cost = 8,
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

        local skyjo = SMODS.Joker{
            key = 'skyjo',
            loc_txt = {
                name = "Skyjo",
                text = {
                    '{C:dark_edition}+#1# Joker slots{}',
                    '{C:red}Self destructs{} if you have 2',
                    'or more {C:dark_edition}Negative Jokers'
                }
            },
            config = {extra = {
                joker_slots = 2,
            }},
            rarity = 2,
            pos = {y = 4, x = 1},
            atlas = 'Jokers',
            cost = 7,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {center.ability.extra.joker_slots}}
            end,
            add_to_deck = function(self,card)
                G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots
            end,
            remove_from_deck = function(self,card)
                G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.joker_slots
            end,
            calculate = function(self,card,context)
                local negativejokers=0
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].edition and G.jokers.cards[i].edition.negative then negativejokers = negativejokers+1 end
                end
                if negativejokers > 1 then
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

        local pumpkin = SMODS.Joker{
            key = 'pumpkin',
            loc_txt = {
                name = "Spooky Pumpkin",
                text = {
                    'The next {C:attention}#1# Boss Blinds',
                    'have their abilities disabled'
                }
            },
            config = {
                extra = {
                    disables = 2,
                }
            },
            rarity = 2,
            pos = {x = 1, y = 10},
            atlas = 'Jokers',
            cost = 5,
            unlocked = true,
            discovered = false,
            blueprint_compat = false,
            eternal_compat = false,
            perishable_compat = false,
            loc_vars = function(self, info_queue, center)
                return {vars = {center.ability.extra.disables}}
            end,
            calculate = function(self,card,context)
                if context.setting_blind and G.GAME.blind:get_type() == 'Boss' then
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
                    G.GAME.blind:disable()
                    card.ability.extra.disables = card.ability.extra.disables - 1
                    if card.ability.extra.disables <= 0 then
                        card:start_dissolve()
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

        local blank = SMODS.Joker{
            key = 'blank',
            loc_txt = {
                name = "      Joker",
                text = {
                    "When selecting a blind,","{C:attention}copies the ability{} of", "3 random {C:attention}Jokers"
                },
            },
            config = {extra = {}},
            rarity = 1,
            pos = {x = 0, y = 0},
            atlas = 'Soulj',
            cost = 5,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                local card_example = nil
            if center.jimb_jokers then
                    local cardkeys = {}
                    for i = 1, #center.jimb_jokers do
                        cardkeys[#cardkeys+1]=center.jimb_jokers[i].config.center.key
                    end
    
                    card_example, cards = center and center.jimb_jokers and center.jimb_jokers[1] and create_card_example(cardkeys) or ((not (G and G.jokers)) and create_card_example({'j_joker'})) or nil
    
    
                    for i = 1, #center.jimb_jokers do
                        info_queue[#info_queue + 1] = {
                            set = "Joker",
                            key = center.jimb_jokers[i].config.center.key,
                            specific_vars = false and center.jimb_jokers[i].config.center.loc_vars and center.jimb_jokers[i].config.center:loc_vars(info_queue, center.jimb_jokers[i]) or {'???','???','???','???'},
                        }
                    end
                end
                return {
                    vars = {},
                    main_end = center and center.jimb_jokers and {card_example}
                }
            end,
            calculate = function(self,card,context)
                if card.jimb_jokers and #card.jimb_jokers ~= 0 then
                    for i = 1, #card.jimb_jokers do
                        if card.jimb_jokers[i] and card.jimb_jokers[i].calculate_joker then
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
                if context.setting_blind then
                    local card1 = create_card("Joker",G.jokers)
                    local card2 = create_card("Joker",G.jokers)
                    local card3 = create_card("Joker",G.jokers)
                    card.jimb_jokers = {card1,card2,card3}
                    card1:remove()
                    card2:remove()
                    card3:remove()
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

        local unpleasant = SMODS.Joker{
            key = 'unpleasant',
            loc_txt = {
                name = "Unpleasant Joker",
                text = {
                    "When selecting a blind,",
                    "{C:red}disable{} Jokers {C:attention}adjacent{} to this card",
                    'In {C:attention}#1# rounds, sell this card',
                    'to create a {C:dark_edition}Negative',
                    'copy of a {C:attention}Joker{}'
                },
            },
            config = {extra = {rounds = 4}},
            rarity = 3,
            pos = {x = 0, y = 5},
            atlas = 'Jokers',
            cost = 5,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = false,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {center.ability.extra.rounds}}
            end,
            calculate = function(self,card,context)
                if context.setting_blind then
                    local other_joker1 = nil
                    local other_joker2 = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == card then
                            other_joker1 = G.jokers.cards[i+1] 
                            other_joker2 = G.jokers.cards[i-1] 
                        end
                    end
                    if other_joker1 then other_joker1.jimb_roundDebuff = other_joker1.jimb_roundDebuff and other_joker1.jimb_roundDebuff + 1 or 1 end
                    if other_joker2 then other_joker2.jimb_roundDebuff = other_joker2.jimb_roundDebuff and other_joker2.jimb_roundDebuff + 1 or 1 end
                end

                if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
                    card.ability.extra.rounds = math.max(card.ability.extra.rounds - 1, 0)
                    if card.ability.extra.rounds <= 0 then
                        --local eval = function(card) return not card.REMOVED end
                        --juice_card_until(card, eval, true)
                    end
                end
                if context.selling_self then
                    --local eval = function(card) return (card.ability.loyalty_remaining == 0) and not G.RESET_JIGGLES end
                    --juice_card_until(card, eval, true)
                    local jokers = {}
                    for i=1, #G.jokers.cards do 
                        if G.jokers.cards[i] and G.jokers.cards[i] ~= card then
                            jokers[#jokers+1] = G.jokers.cards[i]
                        end
                    end
                    if #jokers > 0 and card.ability.extra.rounds <= 0 then 
                        if #G.jokers.cards <= G.jokers.config.card_limit then 
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                            local chosen_joker = pseudorandom_element(jokers, pseudoseed('invisible'))
                            local newcard = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative)
                            if newcard.ability.invis_rounds then newcard.ability.invis_rounds = 0 end
                            newcard:set_edition({negative = true},true)
                            newcard:add_to_deck()
                            G.jokers:emplace(newcard)
                        else
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_no_room_ex')})
                        end
                    else
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_no_other_jokers')})
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

        local rain = SMODS.Joker{
            key = 'rainfall',
            loc_txt = {
                name = "Rainfall",
                text = {
                    "Cards held in hand have",
                    'a {C:green}#1# in #2#{} chance',
                    'to score'
                }
            },
            cursed = true,
            config = {extra = {odds = 3}},
            rarity = 1,
            pos = {x = 2, y = 12},
            atlas = 'Jokers',
            cost = 5,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds }}
            end,
            calculate = function(self,card,context)
                --[[if context.jimb_before then
                    
                    for i = 1, #G.hand.cards do
                        if pseudorandom('rain_joker') < G.GAME.probabilities.normal/card.ability.extra.odds then
                            context.scoring_hand[#context.scoring_hand+1] = G.hand.cards[i]
                        end
                    end
                    return context.scoring_hand
                end]]
                if context.before then
                    for i = 1, #G.hand.cards do
                        if pseudorandom('rain_joker') < G.GAME.probabilities.normal/card.ability.extra.odds then
                            context.scoring_hand[#context.scoring_hand+1] = G.hand.cards[i]
                        end
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
        --[[
        local hurricane = SMODS.Joker{
            key = 'hurricane',
            loc_txt = {
                name = "Hurricane",
                text = {
                    "Cards in deck have a",
                    'a {C:green}#1# in #2#{} chance',
                    'to score'
                }
            },
            cursed = true,
            config = {extra = {odds = 1}},
            rarity = 3,
            pos = {x = 2, y = 12},
            atlas = 'Jokers',
            cost = 10,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds }}
            end,
            calculate = function(self,card,context)

                if context.before then
                    for i = 1, #G.deck.cards do
                        if pseudorandom('rain_joker') < G.GAME.probabilities.normal/card.ability.extra.odds then
                            context.scoring_hand[#context.scoring_hand+1] = G.deck.cards[i]
                        end
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
        --]]

        local jamaisvu = SMODS.Joker{
            key = 'jamais_vu',
            loc_txt = {
                name = "Jamais Vu",
                text = {
                    "{C:attention}Red Sealed cards{}",
                    'are {C:attention}rescored{}'
                }
            },
            cursed = true,
            config = {extra = {card_ID = math.random()}},
            rarity = 3,
            pos = {x = 5, y = 0},
            soul_pos = {x = 5, y = 1},
            atlas = 'Soulj',
            cost = 5,
            unlocked = true,
            discovered = false,
            blueprint_compat = false,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {}}
            end,
            calculate = function(self,card,context)
                if context.before then
                    for i = 1, #context.scoring_hand do
                        if context.scoring_hand[i].seal and context.scoring_hand[i].seal == 'Red' then
                            context.scoring_hand[#context.scoring_hand+1] = context.scoring_hand[i]
                        end
                    end
                end
                if context.individual and not context.is_rescore and context.other_card and context.other_card.seal and context.other_card.seal == 'Red' then
                    context.is_rescore = true
                    local effects = {eval_card(context.other_card, context)}
                    for k=1, #G.jokers.cards do
                        --calculate the joker individual card effects
                        --local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = context.other_card, individual = true, is_rescore = true})
                        
                        local eval = G.jokers.cards[k]:calculate_joker(context)
                        if eval then 
                            --mod_percent = true
                            --table.insert(effects, eval)
                        end
                    end
                    for ii = 1, #effects do
                        --if this effect came from a joker
                        if effects[ii].card then
                            mod_percent = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'immediate',
                                func = (function() effects[ii].card:juice_up(0.7);return true end)
                            }))
                        end
                        
                        --If hold mult added, do hold mult add event and add the mult to the total
                        
                        --If dollars added, add dollars to total
                        if effects[ii].dollars then 
                            ease_dollars(effects[ii].dollars)
                            card_eval_status_text(context.other_card, 'dollars', effects[ii].dollars, percent)
                        end

                        if effects[ii].h_mult then
                            mod_percent = true
                            mult = mod_mult(mult + effects[ii].h_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(context.other_card, 'h_mult', effects[ii].h_mult, percent)
                        end

                        if effects[ii].x_mult then
                            mod_percent = true
                            mult = mod_mult(mult*effects[ii].x_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(context.other_card, 'x_mult', effects[ii].x_mult, percent)
                        end

                        if effects[ii].message then
                            mod_percent = true
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(context.other_card, 'extra', nil, percent, nil, effects[ii])
                        end
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

        --[[
        local pocket = SMODS.Joker{
            key = 'pocket',
            loc_txt = {
                name = "Pocket Joker",
                text = {
                    "When hand is played,",
                    '{C:attention}shuffle a random Joker{}',
                    'into your hand, played',
                    '{C:attention}Jokers{} trigger effects',
                    'when scored'
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
            calculate = function(self,card,context)
                if context.cardarea == G.jokers and context.before then
                    local newcard = pseudorandom_element(G.jokers.cards,pseudoseed('pocketJimbo'))
                    context.full_hand[#context.full_hand+1] = newcard
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] ==  newcard then
                            local effects = eval_card(newcard, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true})
                            table.remove(G.jokers.cards,i)
                            return effects
                        end
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
        ]]
    ----regular jokers


    ---negative jokers
        local annihilation = SMODS.Joker{
            key = 'annihilation',
            loc_txt = {
                name = "Annihilation",
                text = {
                    "If two cards with the same",
                    '{C:attention}rank and suit{} score,',
                    'destroy the second card and add',
                    '{C:dark_edition}Negative{} to first card',
                    '{C:inactive,s:0.9}Only works once per hand'
                }
            },
            config = {extra = {}},
            rarity = 1,
            pos = {x = 0, y = 0},
            atlas = 'Soulj',
            cost = 8,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {}}
            end,
            calculate = function(self,card,context)
                if context.before then
                    for i = 1, #context.scoring_hand do
                        local card1 = context.scoring_hand[i]
                        for _i = 1, #context.scoring_hand do
                            local card2 = context.scoring_hand[_i]

                            if card1~=card2 and card1:get_id() == card2:get_id() and card1:is_suit(card2.base.suit) then
                                card2:remove()
                                card1:set_edition({negative = true},true)
                                return
                            end

                        end
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

        local accelerator = SMODS.Joker{
            key = 'accelerator',
            loc_txt = {
                name = "Accelerator",
                text = {
                    'Cards in {C:attention}winning hand',
                    'have a {C:green}#1# in #2#{} chance', 
                    'turn {C:dark_edition}Negative',
                    'otherwise {C:red}destroy them{}'
                }
            },
            config = {extra = {cards = {}, odds = 3}},
            rarity = 3,
            pos = {x = 0, y = 0},
            atlas = 'Soulj',
            cost = 8,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds}}
            end,
            calculate = function(self,card,context)
                if context.after and context.scoring_name and context.scoring_hand then
                    card.ability.extra.cards = {}
                    for i = 1, #context.full_hand do
                        card.ability.extra.cards[#card.ability.extra.cards+1] = context.full_hand[i]
                    end
                end
                if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
                    for i = 1, #card.ability.extra.cards do
                        if pseudorandom('accelerator') < G.GAME.probabilities.normal/card.ability.extra.odds then
                            if card.ability.extra.cards[i] then card.ability.extra.cards[i]:set_edition({negative = true},true) end
                        else
                            if card.ability.extra.cards[i] then card.ability.extra.cards[i]:remove() end
                        end
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


        local genetic_engineering = SMODS.Joker{
            key = 'genetic_engineering',
            loc_txt = {
                name = "Genetic Engineering",
                text = {
                    "If first hand contains",
                    'only one card,',
                    'turn the card {C:dark_edition}Negative'
                }
            },
            config = {extra = {}},
            rarity = 3,
            pos = {x = 0, y = 0},
            atlas = 'Soulj',
            cost = 8,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {}}
            end,
            calculate = function(self,card,context)
                if context.before and context.cardarea == G.jokers then
                    if #context.full_hand == 1 then
                        context.full_hand[1]:set_edition({negative = true},true)
                        return {
                            message = 'Negated!',
                            colour = G.C.CHIPS,
                            card = card,
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
    ---negative jokers

    ---dagger jokers

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
            cost = 8,
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
            config = {extra = {chips = 0}},
            rarity = 2,
            pos = {x = 2, y = 3},
            atlas = 'Jokers',
            cost = 6,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {center.ability.extra.chips}}
            end,
            calculate = function(self,card,context)
                if context.setting_blind then
                    local num = 0
                    local my_pos = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == card then my_pos = i; break end
                    end
                    if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].getting_sliced and not G.jokers.cards[my_pos+1].debuff then 
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
                            card.ability.extra.chips = card.ability.extra.chips + sliced_card.sell_cost*2
                            card:juice_up(0.8, 0.8)
                            --sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                            play_sound('slice1', 0.96+math.random()*0.08)
                        return true end }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.mult+2*sliced_card.sell_cost}}, colour = G.C.BLUE, no_juice = true})
                    end
                end


                if context.joker_main then
                    return {
                        chip_mod = card.ability.extra.chips,
                        card = card,
                        message = localize {
                            type = 'variable',
                            key = 'a_chips',
                            vars = { card.ability.extra.chips }
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
            cost = 9,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                local card_example = nil
            if center.jimb_jokers then
                    local cardkeys = {}
                    for i = 1, #center.jimb_jokers do
                        cardkeys[#cardkeys+1]=center.jimb_jokers[i].config.center.key
                    end
    
                    card_example, cards = center and center.jimb_jokers and center.jimb_jokers[1] and create_card_example(cardkeys) or ((not (G and G.jokers)) and create_card_example({'j_joker'})) or nil
    
    
                    for i = 1, #center.jimb_jokers do
                        info_queue[#info_queue + 1] = {
                            set = "Joker",
                            key = center.jimb_jokers[i].config.center.key,
                            specific_vars = false and center.jimb_jokers[i].config.center.loc_vars and center.jimb_jokers[i].config.center:loc_vars(info_queue, center.jimb_jokers[i]) or {'???','???','???','???'},
                        }
                    end
                end
                return {
                    vars = {center.ability.extra.rounds,center.ability.extra.currentrounds},
                    main_end = center and center.jimb_jokers and {card_example}
                }
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

        --[
        local katana = SMODS.Joker{
            key = 'katana',
            loc_txt = {
                name = "Honorful Katana",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "destroy {C:attention}the Joker on the right",
                    "and gain {X:mult,C:white}XMult{} depending on",
                    "the {C:attention}Joker's rarity",
                    '{C:inactive,s:0.7}#2# for Common, #3# for Uncommon,',
                    '{C:inactive,s:0.7}#4# for Rare, #5# for Other',
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}Mult)"
                }
            },
            config = {extra = {Xmult = 1, rarities = {common = 0.15, uncommon = 0.35, rare = 0.5, other = 1}}},
            rarity = 3,
            pos = {x = 2, y = 6},
            atlas = 'Jokers',
            cost = 8,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {center.ability.extra.Xmult, 
                    center.ability.extra.rarities.common, 
                    center.ability.extra.rarities.uncommon, 
                    center.ability.extra.rarities.rare, 
                    center.ability.extra.rarities.other
                }}
            end,
            calculate = function(self,card,context)

                if context.setting_blind then
                    local num = 0
                    local my_pos = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == card then my_pos = i; break end
                    end
                    if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].getting_sliced and not G.jokers.cards[my_pos+1].debuff then 
                        local sliced_card = G.jokers.cards[my_pos+1]
                        G.E_MANAGER:add_event(Event({func = function()
                            sliced_card:start_dissolve()
                            --G.GAME.joker_buffer = 0
                            local modification = card.ability.extra.rarities.other
                            if sliced_card.config.center.rarity then
                                modification = sliced_card.config.center.rarity == 1 and card.ability.extra.rarities.common or
                                sliced_card.config.center.rarity == 2 and card.ability.extra.rarities.uncommon or
                                sliced_card.config.center.rarity == 3 and card.ability.extra.rarities.rare or
                                card.ability.extra.rarities.other
                            end
                            card.ability.extra.Xmult = card.ability.extra.Xmult + modification
                            card:juice_up(0.8, 0.8)
                            --sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                            play_sound('slice1', 0.96+math.random()*0.08)
                        return true end }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_x_mult', vars = {card.ability.mult+2*sliced_card.sell_cost}}, colour = G.C.BLUE, no_juice = true})
                    end
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
        --]]
        --[[
        local cutlass = SMODS.Joker{
            key = 'cutlass',
            loc_txt = {
                name = "Cutlass",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "destroy {C:attention}the Joker on the right",
                    "and gain {C:money}${} equal to triple",
                    "its sell value",
                }
            },
            config = {extra = {}},
            rarity = 3,
            pos = {x = 2, y = 3},
            atlas = 'Jokers',
            cost = 6,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {}}
            end,
            calculate = function(self,card,context)
                if context.setting_blind then
                    local num = 0
                    local my_pos = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == card then my_pos = i; break end
                    end
                    for i = 1, 1 do
                        if my_pos and G.jokers.cards[my_pos+i] and not card.getting_sliced and not G.jokers.cards[my_pos+1].getting_sliced and not G.jokers.cards[my_pos+1].debuffed then 
                            local sliced_card = G.jokers.cards[my_pos+i]
                            sliced_card.getting_sliced = true
                            G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                            G.E_MANAGER:add_event(Event({func = function()
                                G.GAME.joker_buffer = 0
                                card:juice_up(0.8, 0.8)
                                ease_dollars(sliced_card.sell_cost*3)
                                sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                                play_sound('slice1', 0.96+math.random()*0.08)
                            return true end }))
                        end
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
        --]]
        if SMODS.Mods['Bunco'] then
            local claymore = SMODS.Joker{
                key = 'claymore',
                loc_txt = {
                    name = "Claymore",
                    text = {
                        "When {C:attention}Boss Blind{} is selected,",
                        "destroy {C:attention}the Joker on the right",
                        "and create a {C:attention}Breaking Tag",
                    }
                },
                config = {extra = {}},
                rarity = 3,
                pos = {x = 0, y = 15},
                atlas = 'Jokers',
                cost = 6,
                unlocked = true,
                discovered = false,
                blueprint_compat = true,
                eternal_compat = true,
                perishable_compat = true,
                loc_vars = function(self, info_queue, center)
                    info_queue[#info_queue + 1] = {key = 'tag_bunc_breaking', set = 'Tag'}
                    if self.mod then self.mod.display_name = "JimbosPack/Bunco" end
                    return {vars = {}}
                end,
                calculate = function(self,card,context)
                    
                    if context.setting_blind and G.GAME.blind:get_type() == 'Boss' then
                        local num = 0
                        local my_pos = nil
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i] == card then my_pos = i; break end
                        end
                        for i = 1, 1 do
                            if my_pos and G.jokers.cards[my_pos+i] and not card.getting_sliced and not G.jokers.cards[my_pos+1].getting_sliced and not G.jokers.cards[my_pos+1].debuffed then 
                                local sliced_card = G.jokers.cards[my_pos+i]
                                sliced_card.getting_sliced = true
                                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                                G.E_MANAGER:add_event(Event({func = function()
                                    G.GAME.joker_buffer = 0
                                    card:juice_up(0.8, 0.8)
                                    --G.GAME.blind:disable()
                                    add_tag(Tag('tag_bunc_breaking'))
                                    sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                                    play_sound('slice1', 0.96+math.random()*0.08)
                                return true end }))
                            end
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
        else
            local claymore = SMODS.Joker{
                key = 'claymore',
                loc_txt = {
                    name = "Claymore",
                    text = {
                        "When {C:attention}Boss Blind{} is selected,",
                        "destroy {C:attention}the Joker on the right",
                        "and disable the {C:attention}Boss Blind",
                    }
                },
                config = {extra = {}},
                rarity = 3,
                pos = {x = 0, y = 15},
                atlas = 'Jokers',
                cost = 6,
                unlocked = true,
                discovered = false,
                blueprint_compat = true,
                eternal_compat = true,
                perishable_compat = true,
                loc_vars = function(self, info_queue, center)
                    return {vars = {}}
                end,
                calculate = function(self,card,context)
                    if context.setting_blind and G.GAME.blind:get_type() == 'Boss' then
                        local num = 0
                        local my_pos = nil
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i] == card then my_pos = i; break end
                        end
                        for i = 1, 1 do
                            if my_pos and G.jokers.cards[my_pos+i] and not card.getting_sliced and not G.jokers.cards[my_pos+1].getting_sliced and not G.jokers.cards[my_pos+1].debuffed then 
                                local sliced_card = G.jokers.cards[my_pos+i]
                                sliced_card.getting_sliced = true
                                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                                G.E_MANAGER:add_event(Event({func = function()
                                    G.GAME.joker_buffer = 0
                                    card:juice_up(0.8, 0.8)
                                    G.GAME.blind:disable()
                                    sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                                    play_sound('slice1', 0.96+math.random()*0.08)
                                return true end }))
                            end
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
        end
        --]]
    ---dagger jokers

--cool jokers

--unlocked jokers

    --funky unlocks
        local ubiquityactive = true
        local ubiquity = SMODS.Joker{
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
            cost = 7,
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
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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
                    "{C:green}#1# in #2#{} chance for a {C:attention}card{}",
                    "to be replaced with a {C:dark_edition}Negative Fractal Joker",
                    'When obtaining another {C:attention}Fractal Joker{},',
                    'destroy it and gain {C:mult}#3#%{} of current {X:mult,C:white}XMult{}',
                    '{C:inactive}(Currently {}{X:mult,C:white}X#4#{} {C:inactive}Mult)'
                },
                unlock = {
                    'Gain the same {C:attention}Joker 5', 'times','in one run'
                }
            },
            rarity = 3,
            config = {extra = {odds = 10, Xmult = 1, Xmult_mod = 25}},
            pos = { x = 2, y = 4 },
            atlas = 'Jokers',
            cost = 7,
            unlocked = false,
            discovered = false,
            blueprint_compat = false,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds,center.ability.extra.Xmult_mod,center.ability.extra.Xmult}}
            end,
            check_for_unlock = function(self, args)
                if args.type == 'jimb_manyJokers' then
                    unlock_card(self)
                end
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
                    unlock_card(self)
                end
            end,
            
            calculate = function(self, card, context)
                if context.joker_main then
                    return{
                        Xmult_mod = card.ability.extra.Xmult,
                        card = card,
                        message = localize {
                            type = 'variable',
                            key = 'a_xmult',
                            vars = { card.ability.extra.Xmult }
                        },
                    }
                end
                if context.jimb_pre_create_card and pseudorandom('fractal') < G.GAME.probabilities.normal/card.ability.extra.odds and context._type ~= 'Base' then
                    G.GAME.next_Gen_Cards[#G.GAME.next_Gen_Cards+1] = {key = card.config.center.key}
                end
                if context.jimb_post_create_card and card.ability.name == context.other_card.ability.name and context.other_card ~= card then
                    context.other_card:set_edition({negative = true},true)
                    context.other_card.cost = context.other_card.cost - context.other_card.extra_cost + G.GAME.inflation
                end

                if context.jimb_card_gain and context.area == G.jokers and context.other_card and context.other_card.ability.name == card.ability.name and context.other_card ~= card then
                    context.other_card:start_dissolve()
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult * card.ability.extra.Xmult_mod/100
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
            cost = 4,
            unlocked = false,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                local card_example = nil
            if center.jimb_jokers then
                    local cardkeys = {}
                    for i = 1, #center.jimb_jokers do
                        cardkeys[#cardkeys+1]=center.jimb_jokers[i].config.center.key
                    end
    
                    card_example, cards = center and center.jimb_jokers and center.jimb_jokers[1] and create_card_example(cardkeys) or ((not (G and G.jokers)) and create_card_example({'j_joker'})) or nil
    
    
                    for i = 1, #center.jimb_jokers do
                        info_queue[#info_queue + 1] = {
                            set = "Joker",
                            key = center.jimb_jokers[i].config.center.key,
                            specific_vars = false and center.jimb_jokers[i].config.center.loc_vars and center.jimb_jokers[i].config.center:loc_vars(info_queue, center.jimb_jokers[i]) or {'???','???','???','???'},
                        }
                    end
                end
                return {
                    vars = {},
                    main_end = center and center.jimb_jokers and {card_example}
                }
            end,
            calculate = function(self,card,context)
                if not context.selling_card then
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
                end
                if context.selling_card and context.card.ability.set == 'Joker' and context.card.ability.name ~= card.ability.name then
                    --card.ability.extra.fakejoker = context.other_card
                    card.jimb_jokers = {context.card}
                end
                
            end,
            check_for_unlock = function(self, args)
                if args.type == 'jimb_cardboard' then
                    unlock_card(self)
                end
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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
                    '{C:blue}+#1#{} Hands, decreases','by {C:blue}#2#{} at end of round'
                },
                unlock = {
                    'Score a hand','{X:purple,C:white}X100{} higher than','current blind requirement'
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
                if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
                    card.ability.extra.hands = card.ability.extra.hands - card.ability.extra.dec
                    if card.ability.extra.hands <= 0 then
                        card:start_dissolve()
                    end
                end
            end,
            check_for_unlock = function(self, args)
                if args.type == 'chip_score' then
                    if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips * 100) then
                        unlock_card(self)
                    end
                end
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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

        local pepperspray = SMODS.Joker{
            key = 'spray',
            loc_txt = {
                name = "Pepper Spray",
                text = {
                    '{X:purple,C:white}X#1#{} blind size, increases','by {X:purple,C:white}#2#{} when hand played'
                },
                unlock = {
                    'Score a hand','{X:purple,C:white}X200{} higher than','current blind requirement'
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
                    if card.ability.extra.hands >= 1 then
                        card:start_dissolve()
                    end
                end
            end,
            check_for_unlock = function(self, args)
                if args.type == 'chip_score' then
                    if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips * 200) then
                        unlock_card(self)
                    end
                end
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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
    --funky unlocks

    --deck unlocks
        local phonebook = SMODS.Joker{
            key = 'phonebook',
            loc_txt = {
                name = "Phonebook",
                text = {
                    'This Joker gains {X:mult,C:white}X#1#{} Mult','per consecutive hand with','scoring {C:attention}face card{}','{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive} Mult)'
                },
                unlock = {
                    'Win a run without','with {C:attention}Abandoned Deck'
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
                if args.type == 'win' then
                    local selected_back = saveTable and saveTable.BACK.name or (args.challenge and args.challenge.deck and args.challenge.deck.type) or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
                    selected_back = get_deck_from_name(selected_back)
                    if selected_back.name == "Abandoned Deck" then
                        unlock_card(self)
                    end
                end
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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
            cost = 6,
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
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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
        vision.calculate = function(self, card, context)
            if context.skip_blind then
                add_tag(Tag('tag_double'))
                return{}
            end
        end


        local prism = SMODS.Joker{
            key = 'prism',
            loc_txt = {
                name = "Prism",
                text = {
                    "Cards with the {V:1}#1#{} suit",
                    "count as every suit",
                    "suit changes every round",
                },
                unlock = {
                    'Win a run',
                    'with {C:attention}Checkered Deck{}'
                }
            },
            config = {extra = {suit = nil}},
            rarity = 3,
            pos = {x = 0, y = 0},
            soul_pos = {x=4,y=1},
            atlas = 'Soulj',
            cost = 6,
            unlocked = false,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {G.GAME.current_round.prism_suit or center.ability.extra.suit or "Hearts", colours = {G.C.SUITS[G.GAME.current_round.prism_suit or center.ability.extra.suit or 'Hearts']}}}
            end,
            calculate = function(self,card,context)
                --[[if context.check_suit and isSuit(context.other_card, G.GAME.current_round.prism_suit) and not context.from then
                    return true
                end]]
                --if G and G.GAME and G.GAME.current_round and not G.GAME.current_round.prism_suit then G.GAME.current_round.prism_suit = 'Hearts' end
                --if context.check_suit and isSuit(context.other_card, card.ability.extra.suit) then
                --    return true
                --end
                if context.check_suit and isSuit(context.other_card, card.ability.extra.suit or 'Hearts') then
                    return true 
                end
                if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
                    local suits = {}
                    for k, v in ipairs(G.playing_cards) do
                        if v.ability.effect ~= 'Stone Card' and v.base.suit and v.base.suit ~= card.ability.extra.suit then
                            suits[#suits+1] = v.base.suit
                            --print(v.base.suit)
                        end
                    end
                    local suit = pseudorandom_element(suits, pseudoseed('prism'..G.GAME.round_resets.ante)) or 'Hearts'
                    card.ability.extra.suit = suit
                end
            end,
            check_for_unlock = function(self, args)
                if args.type == 'win' then
                    local selected_back = saveTable and saveTable.BACK.name or (args.challenge and args.challenge.deck and args.challenge.deck.type) or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
                    selected_back = get_deck_from_name(selected_back)
                    if selected_back.name == "Checkered Deck" then
                        unlock_card(self)
                    end
                end
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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

        local conspiracy_theory = SMODS.Joker{
            key = 'conspiracy_theory',
            loc_txt = {
                name = "Conspiracy Theory",
                text = {
                    "{C:blue}Upgrading{} a hand has",
                    "a {C:green}#1# in #2#{} chance",
                    "upgrade most played",
                    'hand instead'
                },
                unlock = {
                    'Win a run',
                    'with {C:attention}Nebula Deck{}'
                }
            },
            config = {extra = {odds = 2}},
            rarity = 2,
            pos = {x = 1, y = 13},
            atlas = 'Jokers',
            cost = 6,
            unlocked = false,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds}}
            end,
            calculate = function(self,card,context)
                if context.jimb_pre_level_up then
                    local quips = {
                        'Fake!',
                        'Photoshopped...',
                        'Nuh uh!',
                        'I could disprove that',
                        'Nope!',
                        'Science believers...',
                        'Liberals...',
                        'The government is lying'
                    }
                    if pseudorandom('flatearth') < G.GAME.probabilities.normal/card.ability.extra.odds then

                        local mostplayedhand = nil
                        local playedtimes = -420/69
                        for k, v in ipairs(G.handlist) do
            
                            if G.GAME.hands[v].visible and G.GAME.hands[v].played > playedtimes then
                                playedtimes = G.GAME.hands[v].played
                                mostplayedhand = v
                            end
                        end

                        return{
                            card = card,
                            message = pseudorandom_element(quips, pseudoseed('flat_earth')),
                            hand = mostplayedhand or 'High Card',
                        }
                    end
                end
            end,
            check_for_unlock = function(self, args)
                if args.type == 'win' then
                    local selected_back = saveTable and saveTable.BACK.name or (args.challenge and args.challenge.deck and args.challenge.deck.type) or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
                    selected_back = get_deck_from_name(selected_back)
                    if selected_back.name == "Nebula Deck" then
                        unlock_card(self)
                    end
                end
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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

        local ionization = SMODS.Joker{
            key = 'ionization',
            loc_txt = {
                name = "Ionization",
                text = {
                    "Whenever {C:mult}Mult{} is modified,",
                    'gain {C:attention}#1#%{} of modification',
                    'as {C:chips}Chips'
                },
                unlock = {
                    'Win a run',
                    'with {C:attention}Plasma Deck{}'
                }
            },
            config = {extra = {percentage = 50}},
            rarity = 3,
            pos = {x = 0, y = 0},
            --soul_pos = {x=4,y=1},
            atlas = 'Soulj',
            cost = 6,
            unlocked = false,
            discovered = false,
            blueprint_compat = false,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {center.ability.extra.percentage}}
            end,
            calculate = function(self,card,context)
                if context.jimb_modify_mult then
                    hand_chips = mod_chips(hand_chips + (context.mod-mult)* to_big(card.ability.extra.percentage/100))
                    update_hand_text({delay = 0}, {chips = hand_chips})
                end
            end,
            check_for_unlock = function(self, args)
                if args.type == 'win' then
                    local selected_back = saveTable and saveTable.BACK.name or (args.challenge and args.challenge.deck and args.challenge.deck.type) or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
                    selected_back = get_deck_from_name(selected_back)
                    if selected_back.name == "Plasma Deck" then
                        unlock_card(self)
                    end
                end
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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

        local cosmicray = SMODS.Joker{
            key = 'cosmicrays',
            loc_txt = {
                name = "Cosmic Rays",
                text = {
                    "{C:dark_edition}Negative{} cards held in hand",
                    'at end of round gain',
                    '{X:mult,C:white}X#1#{} held Mult'
                }
            },
            config = {extra = {Xmult_mod = 0.05}},
            rarity = 3,
            pos = {x = 0, y = 13},
            atlas = 'Jokers',
            cost = 8,
            unlocked = false,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {center.ability.extra.Xmult_mod}}
            end,
            calculate = function(self,card,context)
                if context.after and context.scoring_name and context.scoring_hand then
                    card.ability.extra.cards = {}
                    for i = 1, #G.hand.cards do
                        card.ability.extra.cards[#card.ability.extra.cards+1] = G.hand.cards[i]
                    end
                end
                if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
                    for i = 1, #card.ability.extra.cards do
                        if card.ability.extra.cards[i].ability.h_x_mult == 0 then
                            card.ability.extra.cards[i].ability.h_x_mult=card.ability.extra.Xmult_mod + 1
                        else
                            card.ability.extra.cards[i].ability.h_x_mult = card.ability.extra.cards[i].ability.h_x_mult + card.ability.extra.Xmult_mod
                        end
                        -- or card.ability.extra.Xmult_mod
                    end
                    card.ability.extra.cards = nil
                end
            end,
            check_for_unlock = function(self, args)
                if args.type == 'win' then
                    local selected_back = saveTable and saveTable.BACK.name or (args.challenge and args.challenge.deck and args.challenge.deck.type) or (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
                    selected_back = get_deck_from_name(selected_back)
                    if selected_back.name == "Negated Deck" then
                        unlock_card(self)
                    end
                end
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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
            pos = {x = 0, y = 9},
            atlas = 'Jokers',
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
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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


        local commercial = SMODS.Joker{
            key = 'commercial',
            loc_txt = {
                name = "Commercial",
                text = {
                    "Jokers in first slot", 
                    'of the shop have',
                    "{X:dark_edition,C:white}X#1#{} to all values",
                },
                unlock = {
                    'Win a run with',
                    '{C:attention}Neon Deck{}'
                }
            },
            config = {extra = {mult = 1.25, active = true}},
            rarity = 3,
            pos = {x = 2, y = 7},
            atlas = 'Jokers',
            cost = 8,
            unlocked = false,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {center.ability.extra.mult}}
            end,
            calculate = function(self,card,context)
                if context.jimb_card_gain and G.shop_jokers and context.other_card.ability.set == 'Joker' and context.other_card == G.shop_jokers.cards[1]  then
                    jokerMult(context.other_card, card.ability.extra.mult)
                    context.other_card.cost = context.other_card.cost * card.ability.extra.mult
                    context.other_card:juice_up()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = (function() card:juice_up(0.7);return true end)
                    }))
                    return {}
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
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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
            pos = {x = 0, y = 7},
            atlas = 'Jokers',
            cost = 5,
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
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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
    --deck unlocks
    
--unlocked jokers

--decks
    --

    SMODS.Atlas{
        key = "Decks",
        path = "Decks.png",
        px = 71,
        py = 95
    }

    local neondeck = SMODS.Back{
        key = "neondeck",
        name = "Neon Deck",
        pos = {x = 0, y = 0},
        loc_txt = {
            name = "Neon Deck",
            text = {
            "Switch between two sets",
            "of jokers at the end of round",
            "{X:dark_edition,C:white}X#1#{} card values"
            },
            unlock = {
                'Win a run on at least',
                '{C:attention}Rotting Stake{} difficulty',
            }
        },
        unlocked = false,
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
        end,
        check_for_unlock = function(self, args)
            if args.type == 'win_stake' and getStake(G.GAME.stake).key == 'stake_jimb_rotting' then
                unlock_card(self)
            end
            if args.type == 'jimb_lock_all' then
                lock_card(self)
            end
            if args.type == 'jimb_unlock_all' then
                unlock_card(self)
            end
        end,
        trigger_effect = function(self,args)
            if not args then return end
            
            if args.context == "card" then jokerMult(args.other_card,self.config.extra.mult) end
        
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
                    G.GAME.neonJokers2[#G.GAME.neonJokers2].saveables = {
                        ability = G.jokers.cards[i].ability,
                        pinned = G.jokers.cards[i].pinned,
                        edition = G.jokers.cards[i].edition,
                        base_cost = G.jokers.cards[i].base_cost,
                        extra_cost = G.jokers.cards[i].extra_cost,
                        cost = G.jokers.cards[i].cost,
                        sell_cost = G.jokers.cards[i].sell_cost,
                    }
                    G.jokers.cards[i]:remove_from_deck()
                end
                G.GAME.neonJokers = G.GAME.neonJokers or {}
        
        
                G.jokers.cards = {}
                for i = 1, #G.GAME.neonJokers do
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, G.GAME.neonJokers[i].key)
                    for k,v in pairs(G.GAME.neonJokers[i].saveables) do
                        card[k] = G.GAME.neonJokers[i].saveables[k]
                    end
                    --card.ability = G.GAME.neonJokers[i].ability
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
    }

    local negated = SMODS.Back{
        key = "negated",
        name = "Negated Deck",
        pos = {x = 2, y = 0},
        loc_txt = {
            name = "Negated Deck",
            text = {
                "{C:dark_edition}Negative{} playing cards",
                'may naturally appear',
                'When defeating a {C:attention}Boss Blind{}',
                'add {C:dark_edition}Negative{} to {C:attention}3{} random cards in deck'
            },
            unlock = {
                'Have atleast 15 {C:dark_edition}Negative',
                'cards in your deck',
            }
        },
        unlocked = true,
        config = {
            extra = {
                
            }
        },
        atlas = "Decks",
        loc_vars = function(self)
            return { vars = {} }
        end,
        apply = function(back) 
            G.GAME.allow_negative = true
        end,
        trigger_effect = function(self,args)
            if not args then return end
                if args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
                    local cards = {}
                    for i = 1, #G.playing_cards do
                        if not G.playing_cards[i].edition then
                            cards[#cards+1] = G.playing_cards[i]
                        end
                    end
                    for i = 1, 3 do
                        if cards[i] then
                            local card = pseudorandom_element(cards,pseudoseed('negateddeck'))
                            card:set_edition({negative = true},true)
                        end
                    end
                end
        end,
        check_for_unlock = function(self, args)
            if args.type == 'modify_deck' then
                local count = 0
                for _, v in pairs(G.playing_cards) do
                    if v.edition and v.edition.negative then count = count + 1 end
                end
                if count >= 15 then
                    unlock_card(self)
                end
            end
            if args.type == 'jimb_lock_all' then
                lock_card(self)
            end
            if args.type == 'jimb_unlock_all' then
                unlock_card(self)
            end
        end
    }

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
            if args.type == 'jimb_lock_all' then
                lock_card(self)
            end
            if args.type == 'jimb_unlock_all' then
                unlock_card(self)
            end
        end
    }

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
                if G.GAME.round_resets.ante <= 0 then
                    unlock_card(self)
                end
            end
            if args.type == 'jimb_lock_all' then
                lock_card(self)
            end
            if args.type == 'jimb_unlock_all' then
                unlock_card(self)
            end
        end
    }

    --[[
    local drawndeck = SMODS.Back{
        key = "drawn",
        name = "Drawn Deck",
        pos = {x = 0, y = 0},
        loc_txt = {
            name = "Drawn Deck",
            text = {
                'After defeating a Boss Blind,',
                'switch to another deck',
                '{C:inactive}Currently{} {C:attention}#1#'
            }
        },
        config = {
            extra = {
                deck = nil
            }
        },
        atlas = "Decks",
        loc_vars = function(self)
            
            return { vars = {self.config.extra.deck and self.config.extra.deck.name or 'Red Deck'} }
        end,
        trigger_effect = function(self,args)
            if not args then return end
            if not self.config.deck then self.config.extra.deck = Back(pseudorandom_element(G.P_CENTER_POOLS['Back'],pseudoseed('drawn_deck'))) end
            self.config.extra.deck:trigger_effect{context = 'card', other_card = self}

            if args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
                self.config.extra.deck = Back(pseudorandom_element(G.P_CENTER_POOLS['Back'],pseudoseed('drawn_deck')))
            end
        end
    }
    ]]

    if jimbomod.config.Curses == 123 then
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

    --[[]
    local CAHDeck = SMODS.Back{
        key = "against_humanity",
        name = "Deck Against Humanity",
        unlocked = true,
        pos = {x = 0, y = 0},
        loc_txt = {
            name = "Deck Against Humanity",
            text = {
            "Jokers are replaced with",
            "{C:legendary}Cards Against Humanity", 
            },
        },
        config = {
            extra = {

            }
        },
        atlas = "Decks",
    }
    ]]

--decks

--editions
    --
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
--editions

--Blinds
    --
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
            text = { 'Cards created this Ante','spawn with Deteriorating Sticker' },
        },
        boss_colour = HEX('967BB6'),
        dollars = 5,
        mult = 2,
        discovered = false,
        has_played = false,
        boss = {
            min = 4,
            max = 69420,
            showdown = false
        },
        atlas = 'blinds',
        pos = { x = 0, y = 0},
        in_pool = function(self,wawa,wawa2)
            if jimbomod.config["Boss Blinds"] == true then
                return true
            else
                return false
            end
        end,
    }

    local statue = SMODS.Blind{
        key = "statue",
        loc_txt = {
            name = 'The Statue',
            text = { 'All sealed cards','are debuffed' },
        },
        boss_colour = HEX('808080'),
        dollars = 5,
        mult = 2,
        discovered = false,
        has_played = false,
        boss = {
            min = 2,
            max = 69420,
            showdown = false
        },
        atlas = 'blinds',
        pos = { x = 0, y = 1 },
        in_pool = function(self,wawa,wawa2)
            if jimbomod.config["Boss Blinds"] == true then
                if G.deck then 
                    for i = 1, #G.deck.cards do
                        if G.deck.cards[i].seal then
                            return true 
                        end
                    end
                end
            end
            return false
        end,
        recalc_debuff = function(self, card, from_blind)
        
            if card.seal then return true end
            return false
        end,
    }



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

    local beryl = SMODS.Blind{
        key = "berylluck",
        loc_txt = {
            name = 'Beryl Luck',
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
            if pseudorandom('ladyluck') < 1/10 then
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

    local rainfall = SMODS.Blind{
        key = "rainfall",
        loc_txt = {
            name = 'Immaculate Rainfall',
            text = { 'Debuff all cards in hand ', 'when hand is played'},
        },
        boss_colour = HEX('9AB9DB'),
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
        press_play = function(self)
            for i = 1, #G.hand.cards do
                local worksOrNah = true
                for _i = 1, #G.hand.highlighted do
                    if G.hand.highlighted[_i] == G.hand.cards[i] then
                        worksOrNah = false 
                    end
                end
                if worksOrNah == true then G.hand.cards[i]:set_debuff(true) end
            end
        end,
        in_pool = function(self,wawa,wawa2)
            if jimbomod.config["Boss Blinds"] == true then
                return true
            else
                return false
            end
        end,
    }
--Blinds

--challenges

    --challenge texts
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

        G.localization.misc.v_text.ch_c_jimb_probability = {"{C:green}Probabilities{} are set to {C:green}#1#"}
    --challenge texts

    --challenge stuff
        SMODS.Challenge{
            key = 'mandelbrot_set',
            name = 'Mandelbrot Set',
            loc_txt = {
                name = 'Mandelbrot Set',
            },
            deck = { type = "Challenge Deck" },
            rules = { 
                custom = {
                    {id = 'jimb_probability', value = 1e100},
                }, 
                modifiers = {}
            },
            jokers = {
                {id = 'j_jimb_fractal'}
            },
            consumeables = {},
            vouchers = {
            },
            restrictions = { 
                banned_cards = {
                }, 
                banned_tags = {}, 
                banned_other = {} },
        }

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
                    {id = 'dollars', value = -4},
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

        --[[
        SMODS.Challenge{
            key = 'rocktop',
            name = 'Rock Top',
            loc_txt = {
                name = 'Rock Top',
            },
            deck = { type = "Challenge Deck" },
            rules = { 
                custom = {
                    {id = 'jimb_rocktop', value = 'discards', otherval = 2},
                    {id = 'jimb_rocktop', value = 'hands', otherval = 4},
                    {id = 'jimb_rocktop', value = 'reroll cost', otherval = 6},
                    {id = 'jimb_rocktop', value = 'joker slots', otherval = 4},
                    {id = 'jimb_rocktop', value = 'consumable slots', otherval = 2},
                    {id = 'jimb_rocktop', value = 'hand size', otherval = 8},
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
        }
        --]]
    --challenge stuff

    --challenge unlocks
        local dissolveVal = {val = 100}
        local vipcard = SMODS.Joker{
            key = 'vipcard',
            loc_txt = {
                name = "VIP Card",
                text = {
                    "{C:attention}+#1#{} cards in shop",'Decreases by {C:attention}#2#{} when', 'at end of round'
                },
                unlock = {
                    'Beat the {C:attention}Shopping Spree',
                    'Challenge'
                }
            },
            config = {extra = {cards = 4,decrease = 1}},
            rarity = 2,
            pos = {x = 0, y = 6},
            atlas = 'Jokers',
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
                if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
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
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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

        local coupon = SMODS.Joker{
            key = 'coupon',
            loc_txt = {
                name = "Coupon",
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
            pos = {x = 1, y = 11},
            atlas = 'Jokers',
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
                        context.other_card.base_cost = 0
                        context.other_card:set_cost()
                        context.other_card.cost = 0
                    end
                end
            end,
            check_for_unlock = function(self, args)
                for k, v in pairs(G.CHALLENGES) do
                    if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed['c_jimb_homeless'] then
                        unlock_card(self)
                    end
                end
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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
            pos = {x = 2, y = 11},
            atlas = 'Jokers',
            cost = 8,
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
                if args.type == 'jimb_lock_all' then
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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

        --[[
        local everchanging = SMODS.Joker{
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
                --[[stats are:
                    handsize,
                    joker slots,
                    consumeable slots,    
                ]
            end,
            check_for_unlock = function(self, args)
                for k, v in pairs(G.CHALLENGES) do
                    if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed['c_jimb_rock_bottom'] then
                        unlock_card(self)
                    end
                end
            end
        }
        --]]
    --challenge unlocks

--challenges

--compatible mods
    --
    local rkeyargs = {}
    if Cryptid then
        --[
        local rkey = SMODS.Joker{
            key = 'rkey',
            loc_txt = {
                name = "{X:black,C:white}R Key",
                text = {
                    "When this card is {C:attention}sold",
                    "{C:attention}restart current run{} with",
                    'all your current {C:attention}Jokers',
        
                }
            },
            config = {extra = {}},
            rarity = 'cry_epic',
            pos = {x = 2, y = 9},
            atlas = 'Jokers',
            cost = 12,
            unlocked = true,
            discovered = false,
            blueprint_compat = false,
            eternal_compat = false,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {}}
            end,
            calculate = function(self,card,context)
                if context.selling_self then
                    local jokers = {}
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] ~= card then
                            jokers[#jokers+1] = {key = G.jokers.cards[i].config.center.key, ability = G.jokers.cards[i].ability}
                        end
                    end
                    rkeyargs.rkey = {
                        seed = G.run_setup_seed and G.setup_seed or G.forced_seed or 'RTGAME',
                        jokers = jokers
                    }

                    G.E_MANAGER:clear_queue()
                    G.FUNCS.wipe_on()
                    G.E_MANAGER:add_event(Event({
                        no_delete = true,
                        func = function()
                        G:delete_run()
                        return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        no_delete = true,
                        func = function()
                        G:start_run(rkeyargs)
                        return true
                        end
                    }))
                    G.FUNCS.wipe_off()
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
        --]]
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

        local demonic_M = SMODS.Joker{
            key = 'demonic_m',
            loc_txt = {
                name = "Demonic M",
                text = {
                    "Whenever a {C:dark_edition}Curse{}",
                    'is created, create a',
                    '{C:dark_edition}Negative{} {C:attention}Jolly Joker'
                }
            },
            cursed = true,
            config = {extra = {}},
            rarity = 1,
            pos = {x = 2, y = 5},
            atlas = 'Jokers',
            cost = 3,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {center.ability.extra.odds,G.GAME.probabilities.normal}}
            end,
            calculate = function(self,card2,context)
                if context.jimb_pre_create_card and context._type == 'jimb_curses' then
                    local newcard = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_jolly')
                    newcard:add_to_deck()
                    G.jokers:emplace(newcard)
                    newcard:set_edition({negative = true},true)
                end
            end,
            in_pool = function(self,wawa,wawa2)
                if jimbomod.config["Jokers"] == true then
                    if G and G.jokers then
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i].purified ~= nil then
                                return true
                            end
                        end
                    end
                    return false
                else
                    return false
                end
            end,
        }

        local N = SMODS.Joker{
            key = 'N',
            loc_txt = {
                name = "N",
                text = {
                    "When selecting blind,",
                    'the next generated card will',
                    'be a free {C:blue}Perishable{} and {C:dark_edition}Negative{}', 
                    '{C:attention}m{} or {C:attention}M',
                }
            },
            cursed = true,
            config = {extra = {}},
            rarity = 'cry_epic',
            pos = {x = 1, y = 12},
            atlas = 'Jokers',
            cost = 3,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                info_queue[#info_queue + 1] = {
                    set = "Joker",
                    key = "j_cry_M",
                    specific_vars = {},
                }
                info_queue[#info_queue + 1] = {
                    set = "Joker",
                    key = "j_cry_m",
                    specific_vars = {13, 1},
                }
                return {vars = {}}
            end,
            calculate = function(self,card,context)
                if context.setting_blind then
                    if pseudorandom('n') < 0.5 then 
                        G.GAME.next_Gen_Cards[#G.GAME.next_Gen_Cards+1] = {key = 'j_cry_m', stickers = {perishable = true}, edition = 'negative', cost = 0}
                    else
                        G.GAME.next_Gen_Cards[#G.GAME.next_Gen_Cards+1] = {key = 'j_cry_M', stickers = {perishable = true}, edition = 'negative', cost = 0}
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

        local n = SMODS.Joker{
            key = 'n',
            loc_txt = {
                name = "n",
                text = {
                    "When {C:attention}Jolly Joker{} is sold",
                    'the next card generated', 
                    'is {C:attention}Jolly Joker{}'
                }
            },
            cursed = true,
            config = {extra = { jolly = { t_mult = 8, type = "Pair" } }},
            rarity = 'cry_epic',
            pos = {x = 0, y = 12},
            atlas = 'Jokers',
            cost = 3,
            unlocked = true,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = true,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                info_queue[#info_queue + 1] = {
                    set = "Joker",
                    key = "j_jolly",
                    specific_vars = { 8, localize('Pair', "poker_hands") },
                }
                return {vars = {}}
            end,
            calculate = function(self,card,context)
                if context.selling_card and context.card:is_jolly() and not context.blueprint then
                    G.GAME.next_Gen_Cards[#G.GAME.next_Gen_Cards+1] = {key = 'j_jolly', }
                    if not context.retrigger_joker then
                        card_eval_status_text(
                            card,
                            "extra",
                            nil,
                            nil,
                            nil,
                            { message = "Jol" }
                        )
                    end
                    return nil, true
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


        local scoreStuff = 0
        local tax = SMODS.Consumable {
            key = "tax",
            purified = false,
            no_sell = true,
            set = 'jimb_curses',
            config = {extra = {req = 0.5, Xmult = 0.75,pureMult = 1.5}},
            atlas = 'Curse',
            pos = { x = 1, y = 0},
            cost = 0,
            blueprint_compat = false,
            eternal_compat = false,
            perishable_compat = true,
            keep_on_use = function(self,card)
                return true
            end,
            unlocked = true,
            discovered = false,
            loc_vars = function(self, info_queue, center)
                local key1 = 'tax_curse'
                if center.purified ~= nil and center.purified == true then
                    key1 = 'tax_pure'
                end
                return {key = key1,vars = {center.ability.extra.Xmult,center.ability.extra.req*100}}
            end,
            calculate = function(self,card,context)
                if context.joker_main then
                    if card.purified == true then
                        if to_big(hand_chips * mult)/G.GAME.blind.chips < to_big(card.ability.extra.req) then
                            return{
                                card = card,
                                Xmult_mod = card.ability.extra.Xmult,
                                message = 'X' .. card.ability.extra.Xmult
                            }
                        end
                        
                    else

                        if to_big(hand_chips * mult)/G.GAME.blind.chips > to_big(card.ability.extra.req) then
                            return{
                                card = card,
                                Xmult_mod = card.ability.extra.Xmult,
                                message = 'X' .. card.ability.extra.Xmult
                            }
                        end

                    end
                end
            

                if context.jimb_purify and context.other_card == card then
                    card.ability.extra.Xmult = card.ability.extra.pureMult
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


        --[[local gehenna = SMODS.Joker{
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
            pos = {x = 2, y = 0},
            soul_pos = {x = 2, y = 1},
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
                    context.other_card:start_dissolve()
                    local eligibleJokers = {}
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i].ability.name ~= card.ability.name and G.jokers.cards[i] ~= context.other_card then eligibleJokers[#eligibleJokers+1] = G.jokers.cards[i] end
                    end
                    jokerMult(pseudorandom_element(eligibleJokers,pseudoseed('gehenna')), card.ability.extra.cardMult)
                end
            end,
            update = function(self,card,dt,a,b,c)
                self.dissolve_colours = {G.C.BLACK, G.C.ORANGE, G.C.RED, G.C.GOLD, G.C.RED}
                card.dissolve = card.dissolve and card.dissolve + dissolveVal.val/100/100 or 0.15
                dissolveVal.val = dissolveVal.val*1.01
                if card.dissolve > 0.55 then
                    dissolveVal.val = -10
                end
                if card.dissolve < 0.25 then
                    dissolveVal.val = 10
                end
                
            end,
            add_to_deck = function(self,card,from_debuff)
                self.dissolve_colours = {G.C.BLACK, G.C.ORANGE, G.C.RED, G.C.GOLD, G.C.RED}
                card.dissolve = 0.5
            end,
            in_pool = function(self,wawa,wawa2)
                if jimbomod.config["Curses"] == true and jimbomod.config["Jokers"] == true then
                    return true
                else
                    return false
                end
                
            end,
        }]]
        

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
                    G.GAME.jimb_prism = G.GAME.jimb_prism * (card.ability.extra.values or 2)
                else
                    G.GAME.jimb_prism = card.ability.extra.values or 2
                end
                --print('hi')
                --print(G.GAME.jimb_prism or "whar")
                --print(card.ability.extra.values)
                calculate_reroll_cost(true)
            end
        }
        --prism.use = Reverie.use_cine

        local calculate_reroll_cost_ref = calculate_reroll_cost
        function calculate_reroll_cost(skip_increment)
            calculate_reroll_cost_ref(skip_increment)
            if G.GAME.jimb_prism then
                G.GAME.current_round.reroll_cost = G.GAME.current_round.reroll_cost + G.GAME.jimb_prism*5
            end
        end
    end

    if CardSleeves then
        SMODS.Atlas({key = 'Sleeves', path = 'sleeves.png', px = 71, py = 95})
        --[
        CardSleeves.Sleeve {
            key = "neon_sleeve",
            name = "Neon Sleeve",
            atlas = "Sleeves",
            pos = { x = 2, y = 3 },
            config = { jokers = {}, jokers2 = {}, mult = 1.5 },
            loc_txt = {
                name = "Neon Sleeve",
                text = {
                "Switch between two sets",
                "of Jokers at the end of round",
                "{X:dark_edition,C:white}X#1#{} to all card's values"
                }
            },
            unlocked = false,
            unlock_condition = { deck = "b_jimb_neondeck", stake = 1 },
            loc_vars = function(self)
                return { vars = {self.config.mult} }
            end,
            trigger_effect = function(self,args)
                if not args then return end
                
                if args.context == "card" then jokerMult(args.other_card,self.config.extra.mult) end
            
                if args.context == 'eval' then
                    G.GAME.neonJokers2 = {}
                    for i = 1, #G.jokers.cards do
                        G.GAME.neonJokers2[#G.GAME.neonJokers2+1] = {}
                        G.GAME.neonJokers2[#G.GAME.neonJokers2].key = G.jokers.cards[i].config.center.key
                        G.GAME.neonJokers2[#G.GAME.neonJokers2].saveables = {
                            ability = G.jokers.cards[i].ability,
                            pinned = G.jokers.cards[i].pinned,
                            edition = G.jokers.cards[i].edition,
                            base_cost = G.jokers.cards[i].base_cost,
                            extra_cost = G.jokers.cards[i].extra_cost,
                            cost = G.jokers.cards[i].cost,
                            sell_cost = G.jokers.cards[i].sell_cost,
                        }
                        G.jokers.cards[i]:remove_from_deck()
                    end
                    G.GAME.neonJokers = G.GAME.neonJokers or {}
            
            
                    G.jokers.cards = {}
                    for i = 1, #G.GAME.neonJokers do
                        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, G.GAME.neonJokers[i].key)
                        for k,v in pairs(G.GAME.neonJokers[i].saveables) do
                            card[k] = G.GAME.neonJokers[i].saveables[k]
                        end
                        --card.ability = G.GAME.neonJokers[i].ability
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
        }
        CardSleeves.Sleeve {
            key = "negated_sleeve",
            name = "Negated Sleeve",
            atlas = "Sleeves",
            pos = { x = 3, y = 3 },

            loc_txt = {
                name = "Negated Sleeve",
                text = {
                    "{C:dark_edition}Negative{} playing cards",
                    'may naturally appear',
                    'When defeating a {C:attention}Boss Blind,',
                    'add {C:dark_edition}Negative{} to 3 random cards in deck'
                },
            },
            unlocked = false,
            unlock_condition = { deck = "b_jimb_negated", stake = 1 },

            config = {
                extra = {
                }
            },
            apply = function(back) 
                G.GAME.allow_negative = true
            end,
            trigger_effect = function(self,args)
                if not args then return end
                if args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
                    local cards = {}
                    for i = 1, #G.playing_cards do
                        if not G.playing_cards[i].edition then
                            cards[#cards+1] = G.playing_cards[i]
                        end
                    end
                    for i = 1, 3 do
                        if cards[i] then
                            local card = pseudorandom_element(cards,pseudoseed('negateddeck'))
                            card:set_edition({negative = true},true)
                        end
                    end
                end
            end,
            loc_vars = function(self)
                return { vars = {self.config.extra.negativity} }
            end,
        }
    end

--compatible mods


--Cards Against Humanity (unfinished)

    --[[
    SMODS.ConsumableType {
        key = 'AgainstHumanity',
        collection_rows = {4, 5},
        primary_colour = G.C.BLACK,
        secondary_colour = G.C.DARK_EDITION,
        loc_txt = {
            collection = 'Cards Against Humanity',
            name = 'Cards Against Humanity'
        },
        shop_rate = 0
    }

    SMODS.UndiscoveredSprite({
        key = "AgainstHumanity",
        atlas = "Curse",
        path = "Curses.png",
        pos = { x = 0, y = 0 },
        px = 71,
        py = 95,
    })

    local handplay = SMODS.Consumable {
        key = "handplay",
        set = 'AgainstHumanity',
        config = {extra = {}},
        atlas = 'Curse',
        pos = { x = 1, y = 0},
        cost = 4,
        blueprint_compat = false,
        eternal_compat = false,
        perishable_compat = false,
        loc_txt = {
            name = "Handplayer",
            text = {
                "When {C:attention}hand is played,",
                '{C:attention}___________________',
                '{C:inactive,s:0.8}Place this to the left of',
                '{C:inactive,s:0.8}an answer Card Against Humanity'
            }
        },
        keep_on_use = function(self,card)
            return true
        end,
        unlocked = true,
        discovered = false,
        calculate = function(self,card,context)
            if context.joker_main then
                local other_joker = nil
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i+1] end
                end
                if other_joker then
                    other_joker:calculate_joker({jimb_cah_trigger = true, context = context})
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

    local xmulter = SMODS.Consumable {
        key = "xmulter",
        set = 'AgainstHumanity',
        config = {extra = {Xmult_mod = 2, Xmult = nil}},
        atlas = 'Curse',
        pos = { x = 1, y = 0},
        cost = 4,
        blueprint_compat = false,
        eternal_compat = false,
        perishable_compat = false,
        loc_txt = {
            name = "XMulter",
            text = {
                '{C:attention}__________________,',
                "{C:attention}next or current hand{} gains",
                '{X:mult,C:white}X#1#{} Mult',
                '{C:inactive,s:0.8}Place this to the right of',
                '{C:inactive,s:0.8}a question Card Against Humanity'
            }
        },
        keep_on_use = function(self,card)
            return true
        end,
        loc_vars = function(self, info_queue,center)
            return { vars = {center.ability.extra.Xmult_mod} }
        end,
        unlocked = true,
        discovered = false,
        calculate = function(self,card,context)
            if context.jimb_cah_trigger then
                card.ability.extra.Xmult = card.ability.extra.Xmult and card.ability.extra.Xmult * card.ability.extra.Xmult_mod or card.ability.extra.Xmult_mod
            end
            if context.joker_main then
                local Xmult = card.ability.extra.Xmult
                card.ability.extra.Xmult = nil
                return {
                        card = card,
                        Xmult_mod = Xmult or 1,
                        message = 'X' .. (Xmult or 1) .. ' Mult',
                        colour = G.C.MULT
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

    --When hand is played,
    --turn 3 selected cards to Negative

    --At end of round,
    --turn 3 random cards in your Deck Negative

--]]



--Summons



    --calculate functions

        function Blind:jimb_calc(context)
            if context.sprite then
                if self.name == 'The Plant' then
                    return {x = 0, y = 2}
                end
            end

            --when summoned
            if context.summon then
                if self.name == 'Small Blind' then
                    G.GAME.blind.chips = G.GAME.blind.chips + get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*0.25
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                elseif self.name == 'Big Blind' then
                    G.GAME.blind.chips = G.GAME.blind.chips + get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*0.5
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                elseif self.name == 'The Needle' then
                    G.GAME.blind.chips = G.GAME.blind.chips + get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*1
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                elseif self.name == 'The Wheel' then
                    self.disabled = true
                    G.jokers:unhighlight_all()
                    for k, v in ipairs(G.jokers.cards) do
                        if pseudorandom('wheelsummon') < G.GAME.probabilities.normal/2 then
                            v:flip()
                        end
                    end
                    if #G.jokers.cards > 1 then 
                        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
                            G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
                            delay(0.15)
                            G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
                            delay(0.15)
                            G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1);return true end })) 
                            delay(0.5)
                        return true end })) 
                    end
                end
            end


            --play hand
            if context.play_hand then
                if self.name == 'The Hook' then
                    self.disabled = true
                    G.E_MANAGER:add_event(Event({ func = function()
                        for i = 1, 2 do
                            local _cards = {}
                            for k, v in ipairs(G.hand.cards) do
                                if v.debuff ~= true then
                                    --print('skibidi toilet') 
                                    _cards[#_cards+1] = v
                                end
                            end
                            if G.hand.cards[i] then 
                                local selected_card, card_key = pseudorandom_element(_cards, pseudoseed('hook'))
                                --G.hand:add_to_highlighted(selected_card, true)
                                if selected_card then 
                                    selected_card:set_debuff(true)
                                    selected_card:juice_up()
                                    play_sound('card1', 1)
                                end
                            end
                        end
                    return true end })) 
                elseif self.name == 'The Wall' then
                    G.GAME.blind.chips = to_big(G.GAME.blind.chips + get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*0.25)
                    self:juice_up()
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        
                elseif self.name == 'The Arm' then
                    self.disabled = true
                    local mostplayedhand = nil
                    local playedtimes = -420/69
                    for k, v in ipairs(G.handlist) do
        
                        if G.GAME.hands[v].visible and G.GAME.hands[v].played > playedtimes then
                            playedtimes = G.GAME.hands[v].played
                            mostplayedhand = v
                        end
                    end
                    level_up_hand(self.children.animatedSprite, mostplayedhand, nil, -1)
                elseif self.name == 'The Manacle' then
                    self.disabled = true
                    G.hand:change_size(-1)
                    G.GAME.manacle_handsize = G.GAME.manacle_handsize and G.GAME.manacle_handsize+1 or 2
                elseif self.name == 'The Pillar' then
                    local list = {}
                    for i = 1, #G.hand.highlighted do
                        print('hi')
                        if G.GAME.pillar_debuffs then
                            if G.GAME.pillar_debuffs[G.hand.highlighted[i]:get_id() .. '_'] == true then
                                G.hand.highlighted[i]:set_debuff(true)
                            end
                        end
                        list[G.hand.highlighted[i]:get_id() .. '_'] = true
                    end
                    G.GAME.pillar_debuffs = nil
                    G.GAME.pillar_debuffs = list
                elseif G.GAME.blind.name == 'The Fish' then
                    G.GAME.blind.disabled = true
                    G.GAME.debuff_hand_draw = true
                end
            end
            
            --before drawing card
            if context.pre_draw_card then
                if self.name == 'The Water' and G.hand and context.to == G.hand then
                    if pseudorandom('water_summon') < 1/8 then
                        return oldfunc(context.from, G.discard, context.percent, context.dir, context.sort, context.card, context.delay, context.mute, context.stay_flipped, context.vol, context.discarded_only)
                    end
                end
                if self.name == 'The Tooth' and G.hand and context.to == G.hand then
                    self.disabled = true
                    ease_dollars(-1)
                end
                if G.GAME.round_resets.blind_choices and G.GAME.round_resets.blind_choices.Boss and G.GAME.round_resets.blind_choices.Boss == 'bl_club' and not next(find_joker('Chicot')) then
                    for i = 1, #G.playing_cards do
                        local card = G.playing_cards[i]
                        if card and card:is_suit('Clubs',true) then
                            card:set_debuff(true)
                        end
                    end
                end
            end

            --when drawing card
            if context.draw_card then
                if self.name == 'The Window' and context.area == G.hand then
                    if context.card and context.card:is_suit('Diamonds',true) and #G.hand.cards > 0 then
                        local chosencard = pseudorandom_element(G.hand.cards,pseudoseed('window_summon'))
                        chosencard:flip()
                    end
                end
                if self.name == 'The Pillar' and context.area == G.hand then
                    for i = 1, #G.hand.cards do
                        if G.GAME.pillar_debuffs then
                            if G.GAME.pillar_debuffs[G.hand.cards[i]:get_id() .. '_'] == true then
                                G.hand.cards[i]:set_debuff(true)
                            end
                        end
                    end
                end
                if self.name == 'The Mark' then
                    self.disabled = true
                    if context.card and context.card:get_id() > 6 and context.card:get_id() < 49 then
                        context.card:flip()
                    end
                end
                if G.GAME.debuff_hand_draw and G.hand and self == G.hand and context.card then
                    context.card:set_debuff(true)
                end
            end

            --before discarding
            if context.pre_discard then
                if self.name == 'The Plant' then
                    local num = 0
                    for i = 1, #G.hand.highlighted do
                        if G.hand.highlighted[i-num]:is_face(true) then
                            G.hand:remove_from_highlighted(G.hand.highlighted[i-num])
                            num = num + 1
                        end
                    end
                end
                if self.name == 'The Goad' then
                    local num = 0
                    for i = 1, #G.hand.highlighted do
                        if G.hand.highlighted[i-num]:is_suit("Spades",true) then
                            G.hand:remove_from_highlighted(G.hand.highlighted[i-num])
                            num = num + 1
                        end
                    end
                end
                G.GAME.debuff_hand_draw = nil
            end

            --debuffing hand
            if context.debuff_hand then
                local cards, hand, handname, check = context.cards, context.hand, context.handname, context.check
                if self.name == 'The Psychic' then
                    local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
                    --print(#scoring_hand)
                    --print(#cards)
                    if #scoring_hand ~= #cards then
                        return true
                    end
                end
                if self.name == 'The Ox' then
                    self.disabled = true
                    self.triggered = false
                    if handname == G.GAME.current_round.most_played_poker_hand then
                        self.triggered = true
                        if not check then
                            G.GAME.dollars = -math.abs(G.GAME.dollars)
                            ease_dollars(0,true)
                        end
                    end 
                end
            end
            --modifying hand
            if context.modify_hand then
                local cards, poker_hands, text, mult, hand_chips = context.cards, context.poker_hands, context.text, context.mult, context.hand_chips

                if self.name == 'The Head' then
                    local Xmult = 1
                    for i = 1, #G.hand.cards do
                        if G.hand.cards[i]:is_suit("Hearts",true) then
                            Xmult = Xmult*0.75
                        end
                    end
                    return math.max(math.floor(mult*Xmult + 0.5), 1), hand_chips, true
                elseif self.name == 'The House' and G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 then
                    for i = 1, #G.hand.cards do
                        G.hand.cards[i]:set_debuff(true)
                    end
                    for i = 1, #cards do
                        cards[i]:set_debuff(true)
                    end
                elseif self.name == 'The Flint' then
                    return math.max(math.floor(mult*0.25 + 0.5), 1), math.max(math.floor(hand_chips*0.25 + 0.5), 0), true
                end
            end

            --other
            if self.config.blind.summon_calc then
                return self.config.blind:summon_calc(context)
            end
        end


        --
        --when it calculates
                local oldfunc = Blind.debuff_card
                function Blind:debuff_card(card, from_blind)
                    self:jimb_calc({debuff_card = true, card = card, from_blind = from_blind})
                    local ret = oldfunc(self,card,from_blind)
                    return ret
                end
                local oldfunc = draw_card
                function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
                    local ret = oldfunc(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
                    if G.GAME.boss_summoned and G.GAME.blind then
                        local ret_ = G.GAME.blind:jimb_calc({pre_draw_card = true, from = from, to = to, percent = percent, dir = dir, sort = sort, card = card, delay = delay, mute = mute, stay_flipped = stay_flipped, vol = vol, discarded_only = discarded_only})
                        if ret_ ~= nil then return ret_ end
                    end
                    return ret
                end
                local oldfunc = CardArea.emplace
                function CardArea:emplace(card, location, stay_flipped)
                    local ret = oldfunc(self,card,location,stay_flipped)
                    if G.GAME.boss_summoned then
                        local ret_ = G.GAME.blind:jimb_calc({draw_card = true, area = self, card = card, old_area = location, stay_flipped = stay_flipped})
                        if ret_ then return ret_ end
                    end
                    return ret
                end
                local oldfunc = G.FUNCS.draw_from_deck_to_hand
                G.FUNCS.draw_from_deck_to_hand = function(e)
                    local ret = oldfunc(e)
                    return ret
                end
                local oldfunc = G.FUNCS.discard_cards_from_highlighted
                G.FUNCS.discard_cards_from_highlighted = function(e, hook)
                    if G.GAME.blind and G.GAME.blind.summoned == true or G.GAME.blind:get_type() == 'Boss' and G.GAME.boss_summoned then
                        local ret_ = G.GAME.blind:jimb_calc({pre_discard = true})
                        if ret_ then return ret_ end
                        G.GAME.debuff_hand_draw = nil
                    end
                    if #G.hand.highlighted == 0 then return end
                    local ret = oldfunc(e, hook)
                    return ret
                end
                local oldfunc = Blind.debuff_hand
                function Blind:debuff_hand(cards, hand, handname, check)
                    local ret = oldfunc(self,cards,hand,handname,check)
                    if self.summoned or G.GAME.boss_summoned then
                        local ret_ = self:jimb_calc({debuff_hand = true, cards = cards, hand = hand, handname = handname, check = check})
                        if ret_ then return ret_ end
                    end
                    return ret
                end
                local oldfunc = Blind.modify_hand
                function Blind:modify_hand(cards, poker_hands, text, mult, hand_chips)
                    if G.GAME.boss_summoned then
                        local ret_,ret2_,ret3_ = self:jimb_calc({modify_hand = true, cards = cards, poker_hands = poker_hands, text = text, mult = mult, hand_chips = hand_chips})
                        if ret_ and ret2_ and ret3_ then return ret_, ret2_, ret3_ end
                    end
                    local ret, ret2,ret3 = oldfunc(self,cards, poker_hands, text, mult, hand_chips)
                    return ret,ret2,ret3
                end
                local oldfunc = Blind.press_play
                function Blind:press_play()
                    if self.summoned == true then
                        local ret_ = self:jimb_calc({play_hand = true})
                        if ret_ then return ret_ end
                    end
                    if self.trueDebuffed == true then return end
                    local ret = oldfunc(self)
                    return ret
                end
        --
    --

    --stakes

        SMODS.Stake {
            key = 'silver',
            name = "Silver Stake",
            pos = {x = 0, y = 0},
            unlocked_stake = 'jimb_burning',
            applied_stakes = {'white'},
            above_stake = 'white',
            loc_txt = {
                name = "Silver Stake",
                text = {
                    "Low chance for {C:attention}Boss Blinds{}",
                    "spawn {C:legendary}Summoned",
                    '{C:inactive}Showdown Blinds excluded',
                    '{C:inactive}Thank you{} {C:attention}gudusername_53951{}', 
                    'for help with the sprite'
                },
                sticker = {
                    name = "Silver Sticker",
                    text = {
                        "Used this Joker",
                        "to win on {C:attention}Silver",
                        "{C:attention}Stake{} difficulty"
                    }
                }
            },
            atlas = 'Stakes',
            prefix_config = {above_stake = {mod = false}, applied_stakes = {mod = false}},
            prefix_config = {above_stake = {mod = false}, applied_stakes = {mod = true}},
            pos = {x = 0, y = 0},
            sticker_atlas = 'Stickers',
            sticker_pos = {x = 1, y = 0},
            modifiers = function()
                if not (G.GAME.chance_summon and G.GAME.chance_summon > 1/7) then G.GAME.chance_summon = 1/7 end
                --print(G.GAME.chance_summon .. '_Silver')
            end,
        }

        SMODS.Stake {
            key = 'burning',
            name = "Burning Stake",
            pos = {x = 0, y = 0},
            applied_stakes = {'jimb_silver', 'red'},
            above_stake = 'red',
            loc_txt = {
                name = "Burning Stake",
                text = {
                    "{C:attention}Small Blinds{} have a chance to be {C:legendary}Summoned",
                },
                sticker = {
                    name = "Burning Sticker",
                    text = {
                        "Used this Joker",
                        "to win on {C:attention}Burning",
                        "{C:attention}Stake{} difficulty"
                    }
                }
            },
            atlas = 'Stakes',
            prefix_config = {above_stake = {mod = false}, applied_stakes = {mod = false}},
            pos = {x = 1, y = 0},
            sticker_atlas = 'Stickers',
            sticker_pos = {x = 2, y = 0},
            modifiers = function()
                G.GAME.chance_small_summon = 1/4
            end,
        }

        SMODS.Stake {
            key = 'cracked',
            name = "Cracked Stake",
            pos = {x = 0, y = 0},
            applied_stakes = {'jimb_burning', 'green'},
            above_stake = 'green',
            loc_txt = {
                name = "Cracked Stake",
                text = {
                    "{C:attention}Boss Blinds{} have a higher chance",
                    'to be {C:legendary}Summoned{} on spawn',
                    '{C:inactive}Thank you{} {C:attention}gudusername_53951{}', 
                    'for help with the sprite'
                },
                sticker = {
                    name = "Cracked Sticker",
                    text = {
                        "Used this Joker",
                        "to win on {C:attention}Cracked",
                        "{C:attention}Stake{} difficulty"
                    }
                }
            },
            sticker_atlas = 'Stickers',
            sticker_pos = {x = 3, y = 0},
            atlas = 'Stakes',
            prefix_config = {above_stake = {mod = false}, applied_stakes = {mod = false}},
            pos = {x = 2, y = 0},
            modifiers = function()
                if not (G.GAME.chance_summon and G.GAME.chance_summon > 1/4) then G.GAME.chance_summon = 1/4 end
                print(G.GAME.chance_summon .. '_Cracked')
            end,
        }

        SMODS.Stake {
            key = 'sepia',
            name = "Sepia Stake",
            pos = {x = 0, y = 0},
            applied_stakes = {'jimb_cracked', 'black'},
            above_stake = 'black',
            loc_txt = {
                name = "Sepia Stake",
                text = {
                    "{C:legendary}Summoned {}{C:attention}Boss Blinds{} spawn {C:legendary}Curses",
                },
                sticker = {
                    name = "Sepia Sticker",
                    text = {
                        "Used this Joker",
                        "to win on {C:attention}Sepia",
                        "{C:attention}Stake{} difficulty"
                    }
                }
            },
            atlas = 'Stakes',
            prefix_config = {above_stake = {mod = false}, applied_stakes = {mod = false}},
            pos = {x = 4, y = 0},
            sticker_atlas = 'Stickers',
            sticker_pos = {x = 0, y = 1},
            modifiers = function()
                G.GAME.curse_summon = true
            end,
        }

        SMODS.Stake {
            key = 'hellbound',
            name = "Hellbound Stake",
            pos = {x = 0, y = 0},
            applied_stakes = {'jimb_sepia', 'blue'},
            above_stake = 'blue',
            loc_txt = {
                name = "Hellbound Stake",
                text = {
                    "{C:legendary}Curses{} can spawn with",
                    'an {X:dark_edition,C:white}Impure{} Sticker'
                },
                sticker = {
                    name = "Hellbound Sticker",
                    text = {
                        "Used this Joker",
                        "to win on {C:attention}Hellbound",
                        "{C:attention}Stake{} difficulty"
                    }
                }
            },
            sticker_atlas = 'Stickers',
            sticker_pos = {x = 4, y = 0},
            atlas = 'Stakes',
            prefix_config = {above_stake = {mod = false}, applied_stakes = {mod = false}},
            pos = {x = 3, y = 0},
            modifiers = function()
                G.GAME.enable_impure_sticker = true
            end,
        }

        SMODS.Sticker{
            key = 'impure', 
            loc_txt = {
                name = "Impure",
                label = 'Impure',
                text = {
                    "Prevents being {C:legendary}Purified",
                    'one time'
                },
            },

            apply = function(self, card, val)
                card.ability[self.key] = val
                card.ability.purify_preventing = true
            end,

            badge_colour = HEX('e97720'),

            order = 99,
            atlas = 'Stickers',
            pos = {x = 0, y = 2},
        }

        SMODS.Stake {
            key = 'rotting',
            name = "Rotting Stake",
            pos = {x = 0, y = 0},
            applied_stakes = {'jimb_hellbound', 'purple'},
            above_stake = 'purple',
            loc_txt = {
                name = "Rotting Stake",
                text = {
                    "{C:legendary}Cards{} can spawn with",
                    'an {C:dark_edition}Deteriorating{} Sticker',
                    '{C:inactive}Thank you{} {C:attention}gudusername_53951{}', 
                    'for help with the sprite'
                },
                sticker = {
                    name = "Rotting Sticker",
                    text = {
                        "Used this Joker",
                        "to win on {C:attention}Rotting",
                        "{C:attention}Stake{} difficulty"
                    }
                }
            },
            atlas = 'Stakes',
            prefix_config = {above_stake = {mod = false}, applied_stakes = {mod = false}},
            pos = {x = 0, y = 1},
            sticker_atlas = 'Stickers',
            sticker_pos = {x = 1, y = 1},
            modifiers = function()
                G.GAME.enable_deteriorating_sticker = true
            end,
        }
        

        SMODS.Sticker{
            key = 'deteriorating', 
            loc_txt = {
                name = "Deteriorating",
                label = 'Deteriorating',
                text = {
                    "Loses {C:attention}5%{} of values",
                    'when a hand is played'
                },
            },

            apply = function(self, card, val)
                card.ability[self.key] = val
                card.ability.deteriorating = true
            end,
            atlas = 'Stickers',
            pos = {x = 0, y = 0},
            badge_colour = HEX('e97720'),

            order = 99,
        }

        SMODS.Stake {
            key = 'bloody',
            name = "Bloody Stake",
            pos = {x = 0, y = 0},
            applied_stakes = {'jimb_rotting', 'orange'},
            above_stake = 'orange',
            loc_txt = {
                name = "Bloody Stake",
                text = {
                    "{C:attention}Boss Blinds{} are always {C:legendary}Summoned",
                    '{C:inactive}Showdown Blinds excluded'
                },
                sticker = {
                    name = "Bloody Sticker",
                    text = {
                        "Used this Joker",
                        "to win on {C:attention}Bloody",
                        "{C:attention}Stake{} difficulty"
                    }
                }
            },
            atlas = 'Stakes',
            prefix_config = {above_stake = {mod = false}, applied_stakes = {mod = false}},
            pos = {x = 1, y = 1},
            sticker_atlas = 'Stickers',
            sticker_pos = {x = 2, y = 1},
            modifiers = function()
                G.GAME.chance_summon = 1
                print(G.GAME.chance_summon .. '_Bloody')
            end,
        }
        --[[
            SMODS.Stake {
                key = 'deluxe',
                name = "Deluxe Stake",
                pos = {x = 0, y = 0},
                applied_stakes = {'jimb_bloody', 'orange'},
                above_stake = 'gold',
                loc_txt = {
                    name = "Gold Stake",
                    text = {
                        "{C:attention}Showdown Blinds{} are always {C:legendary}Summoned",
                    },
                    sticker = {
                        name = "Deluxe Sticker",
                        text = {
                            "Used this Joker",
                            "to win on {C:attention}Deluxe",
                            "{C:attention}Stake{} difficulty"
                        }
                    }
                },
                atlas = 'Stakes',
            prefix_config = {above_stake = {mod = false}, applied_stakes = {mod = false}},
                pos = {x = 2, y = 1},
                sticker_atlas = 'Stickers',
                sticker_pos = {x = 3, y = 1},
                modifiers = function()
                    G.GAME.showdown_summon = true
                end,
            }
        ]]
    --

    --stake Jokers

        local bloodmoon = SMODS.Joker{
            key = 'bloodmoon',
            loc_txt = {
                name = "Blood Moon",
                text = {
                    'When selecting blind, {C:green}#1# in #2#',
                    'chance to {C:legendary}summon the blind',
                    'If the {C:attention}current blind{} is {C:legendary}Summoned',
                    'hands played gain {X:mult,C:white}X#3#{} Mult and Chips',
                },
                unlock = {
                    'Win a run on',
                    'atleast {C:attention}Hellbound Stake{}',
                    'difficulty'
                }
            },
            config = {extra = {odds = 3, Xmod = 1.1}},
            rarity = 3,
            pos = {x = 2, y = 13},
            atlas = 'Jokers',
            cost = 9,
            unlocked = false,
            discovered = false,
            blueprint_compat = true,
            eternal_compat = false,
            perishable_compat = true,
            loc_vars = function(self, info_queue, center)
                return {vars = {G.GAME.probabilities.normal, center.ability.extra.odds, center.ability.extra.Xmod}}
            end,
            calculate = function(self,card,context)
                if context.setting_blind then
                    if pseudorandom('bloodmoon') < G.GAME.probabilities.normal/card.ability.extra.odds then
                        G.GAME.blind:jimb_summon()
                        card:juice_up()
                    end
                end
                if context.before and G.GAME.blind.summoned then
                    G.GAME.hands[context.scoring_name].mult = G.GAME.hands[context.scoring_name].mult * card.ability.extra.Xmod
                    G.GAME.hands[context.scoring_name].chips = G.GAME.hands[context.scoring_name].chips * card.ability.extra.Xmod
                    update_hand_text({delay = 0}, {mult = G.GAME.hands[context.scoring_name].mult, StatusText = true})
                    update_hand_text({delay = 0}, {chips = G.GAME.hands[context.scoring_name].chips, StatusText = true})
                end
            end,
            update = function(self,card,dt)
                if not (card.area and card.area.config.collection) then
                    card.children.center:set_sprite_pos({x = 2, y = G and G.GAME and G.GAME.blind and G.GAME.blind.summoned and 14 or 13})
                end
            end,
            check_for_unlock = function(self, args)
                if args.type == 'win_stake' and getStake(G.GAME.stake).key == 'stake_jimb_hellbound' then
                    unlock_card(self)
                end
                if args.type == 'jimb_lock_all' then
                    --print('hiiii')
                    lock_card(self)
                end
                if args.type == 'jimb_unlock_all' then
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
    --


    --Blind visuals
        function Blind:add_speech_bubble(text_key, align, loc_vars)
            if self.children.speech_bubble then self.children.speech_bubble:remove() end
            self.config.speech_bubble_align = {align=align or 'bm', offset = {x=0,y=0},parent = self}
            self.children.speech_bubble = 
            UIBox{
                definition = G.UIDEF.speech_bubble(text_key, loc_vars),
                config = self.config.speech_bubble_align
            }
            self.children.speech_bubble:set_role{
                role_type = 'Minor',
                xy_bond = 'Weak',
                r_bond = 'Strong',
                major = self,
            }
            self.children.speech_bubble.states.visible = false
        end

        function Blind:say_stuff(n, not_first, args)
            --args stuff
            --args.duration
            --args.pitch

            self.talking = true
            if not not_first then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        if self.children.speech_bubble then self.children.speech_bubble.states.visible = true end
                        self:say_stuff(n, true,args)
                    return true
                    end
                }))
            else
                if n <= 0 then 
                    self.talking = false
                    if self.children.speech_bubble then self.children.speech_bubble.states.visible = false end
                    
                    return 
                end
                local new_said = math.random(1, 11)
                while new_said == self.last_said do 
                    new_said = math.random(1, 11)
                end
                self.last_said = new_said
                if n % G.SETTINGS.GAMESPEED == 0 then
                    play_sound('voice'..math.random(1, 11), args and args.pitch or 1, 0.5)
                    self:juice_up()
                end
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false, blocking = false,
                    delay = 0.13 * G.SETTINGS.GAMESPEED,
                    func = function()
                        self:say_stuff(n-1, true,args)
                    return true
                    end
                }), 'tutorial')
            end
        end

        function Blind:start_materialize(dissolve_colours, silent, timefac)

            self:juice_up()

            if G.summon_sprite then
                G.summon_sprite.states.visible = true
                G.summon_sprite.dissolve = G.summon_sprite.dissolve or 1
                local dissolve_time = 3
                G.summon_sprite.states.visible = true
                G.summon_sprite.states.hover.can = false
                G.summon_sprite.dissolve = 1
                G.summon_sprite.dissolve_colours = dissolve_colours or {G.C.GREEN}
                self.children.particles = Particles(0, 0, 0,0, {
                    timer_type = 'TOTAL',
                    timer = 0.025*dissolve_time,
                    scale = 0.25,
                    speed = 3,
                    lifespan = 0.7*dissolve_time,
                    attach = self,
                    colours = self.dissolve_colours,
                    fill = true
                })
                if not silent then 
                    if not G.last_materialized or G.last_materialized +0.01 < G.TIMERS.REAL or G.last_materialized > G.TIMERS.REAL then
                        G.last_materialized = G.TIMERS.REAL
                        G.E_MANAGER:add_event(Event({
                            blockable = false,
                            func = (function()
                                    play_sound('whoosh1', math.random()*0.1 + 0.6,0.3)
                                    play_sound('crumple'..math.random(1,5), math.random()*0.2 + 1.2,0.8)
                                return true end)
                        }))
                    end
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay =  0.5*dissolve_time,
                    func = (function() if self.children.particles then self.children.particles.max = 0 end return true end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blockable = false,
                    ref_table = G.summon_sprite,
                    ref_value = 'dissolve',
                    ease_to = 0,
                    delay =  1*dissolve_time,
                    func = (function(t) return t end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay =  1.05*dissolve_time,
                    func = (function() G.summon_sprite.states.hover.can = true; if self.children.particles then self.children.particles:remove(); self.children.particles = nil end return true end)
                }))
            end

            if G.table_thing then
                G.table_thing.states.visible = true
                G.table_thing.dissolve = G.table_thing.dissolve or 1
                local dissolve_time = 3
                G.table_thing.states.visible = true
                G.table_thing.states.hover.can = false
                G.table_thing.dissolve = 1
                G.table_thing.dissolve_colours = dissolve_colours or {G.C.GREEN}
                self.children.particles = Particles(0, 0, 0,0, {
                    timer_type = 'TOTAL',
                    timer = 0.025*dissolve_time,
                    scale = 0.25,
                    speed = 3,
                    lifespan = 0.7*dissolve_time,
                    attach = self,
                    colours = self.dissolve_colours,
                    fill = true
                })
                if not silent then 
                    if not G.last_materialized or G.last_materialized +0.01 < G.TIMERS.REAL or G.last_materialized > G.TIMERS.REAL then
                        G.last_materialized = G.TIMERS.REAL
                        G.E_MANAGER:add_event(Event({
                            blockable = false,
                            func = (function()
                                    play_sound('whoosh1', math.random()*0.1 + 0.6,0.3)
                                    play_sound('crumple'..math.random(1,5), math.random()*0.2 + 1.2,0.8)
                                return true end)
                        }))
                    end
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay =  0.5*dissolve_time,
                    func = (function() if self.children.particles then self.children.particles.max = 0 end return true end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blockable = false,
                    ref_table = G.table_thing,
                    ref_value = 'dissolve',
                    ease_to = 0,
                    delay =  1*dissolve_time,
                    func = (function(t) return t end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay =  1.05*dissolve_time,
                    func = (function() G.table_thing.states.hover.can = true; if self.children.particles then self.children.particles:remove(); self.children.particles = nil end return true end)
                }))
            end
        end

        function Blind:start_dissolve(dissolve_colours, silent, timefac)

            self:juice_up()

            if G.summon_sprite then
                G.summon_sprite.states.visible = true
                G.summon_sprite.dissolve = G.summon_sprite.dissolve or 0
                local dissolve_time = 3
                G.summon_sprite.states.visible = true
                G.summon_sprite.states.hover.can = false
                G.summon_sprite.dissolve = 0
                G.summon_sprite.dissolve_colours = dissolve_colours or {G.C.GREEN}
                self.children.particles = Particles(0, 0, 0,0, {
                    timer_type = 'TOTAL',
                    timer = 0.025*dissolve_time,
                    scale = 0.25,
                    speed = 3,
                    lifespan = 0.7*dissolve_time,
                    attach = self,
                    colours = self.dissolve_colours,
                    fill = true
                })
                if not silent then 
                    if not G.last_materialized or G.last_materialized +0.01 < G.TIMERS.REAL or G.last_materialized > G.TIMERS.REAL then
                        G.last_materialized = G.TIMERS.REAL
                        G.E_MANAGER:add_event(Event({
                            blockable = false,
                            func = (function()
                                    play_sound('whoosh1', math.random()*0.1 + 0.6,0.3)
                                    play_sound('crumple'..math.random(1,5), math.random()*0.2 + 1.2,0.8)
                                return true end)
                        }))
                    end
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay =  0.5*dissolve_time,
                    func = (function() if self.children.particles then self.children.particles.max = 0 end return true end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blockable = false,
                    ref_table = G.summon_sprite,
                    ref_value = 'dissolve',
                    ease_to = 1,
                    delay =  1*dissolve_time,
                    func = (function(t) return t end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay =  1.05*dissolve_time,
                    func = (function() G.summon_sprite.states.hover.can = true; if self.children.particles then self.children.particles:remove(); self.children.particles = nil end return true end)
                }))
            end

            if G.table_thing then
                G.table_thing.states.visible = true
                G.table_thing.dissolve = G.table_thing.dissolve or 0
                local dissolve_time = 3
                G.table_thing.states.visible = true
                G.table_thing.states.hover.can = false
                G.table_thing.dissolve = 0
                G.table_thing.dissolve_colours = dissolve_colours or {G.C.GREEN}
                self.children.particles = Particles(0, 0, 0,0, {
                    timer_type = 'TOTAL',
                    timer = 0.025*dissolve_time,
                    scale = 0.25,
                    speed = 3,
                    lifespan = 0.7*dissolve_time,
                    attach = self,
                    colours = self.dissolve_colours,
                    fill = true
                })
                if not silent then 
                    if not G.last_materialized or G.last_materialized +0.01 < G.TIMERS.REAL or G.last_materialized > G.TIMERS.REAL then
                        G.last_materialized = G.TIMERS.REAL
                        G.E_MANAGER:add_event(Event({
                            blockable = false,
                            func = (function()
                                    play_sound('whoosh1', math.random()*0.1 + 0.6,0.3)
                                    play_sound('crumple'..math.random(1,5), math.random()*0.2 + 1.2,0.8)
                                return true end)
                        }))
                    end
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay =  0.5*dissolve_time,
                    func = (function() if self.children.particles then self.children.particles.max = 0 end return true end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blockable = false,
                    ref_table = G.table_thing,
                    ref_value = 'dissolve',
                    ease_to = 1,
                    delay =  1*dissolve_time,
                    func = (function(t) return t end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay =  1.05*dissolve_time,
                    func = (function() G.table_thing.states.hover.can = true; if self.children.particles then self.children.particles:remove(); self.children.particles = nil end return true end)
                }))
            end
        end
        local SC_scale = 0.9*(G.debug_splash_size_toggle and 0.8 or 1)
        local oldfunc = Blind.init
        --local default_atlas = SMODS.Atlas({key = 'default', path = 'default.png', px = 177, py = 100, atlas_table = "ASSET_ATLAS",})
        function Blind:init(X, Y, W, H)
            local ret = oldfunc(self,X,Y,W,H)
            

            if not G.table_thing then
                
                G.table_thing = Sprite(0,2, 
                25*SC_scale, 
                25*SC_scale*littleguy_atlas.py/littleguy_atlas.px,
                littleguy_atlas, {x=0,y=0}) --line 7524

                G.table_thing.states.visible = false
                G.table_thing:define_draw_steps({{
                    shader = 'dissolve',
                }})
                G.table_thing:set_alignment({
                    major = G.mid_screen,
                    type = 'cm',
                    bond = 'Strong',
                    offset = {x=0,y=0}
                })


                G.table_thing.states.hover.can = false
                G.table_thing.dissolve = 0
                G.table_thing.dissolve_colours = {G.C.DARK_EDITION}
            end
            --[[
            if not G.summon_sprite then
                
                G.summon_sprite = Sprite(0,2, 
                25*SC_scale, 
                25*SC_scale*default_atlas.py/default_atlas.px,
                default_atlas, {x=0,y=0}) --line 7524

                G.summon_sprite.states.visible = false
                G.summon_sprite:define_draw_steps({{
                    shader = 'dissolve',
                }})
                G.summon_sprite:set_alignment({
                    major = G.mid_screen,
                    type = 'cm',
                    bond = 'Strong',
                    offset = {x=0,y=0}
                })


                G.summon_sprite.states.hover.can = false
                G.summon_sprite.dissolve = 0
                G.summon_sprite.dissolve_colours = {G.C.DARK_EDITION}
            end
            --]]

            return ret
        end

        
        local oldfunc = create_UIBox_blind_popup
        function create_UIBox_blind_popup(blind, discovered, vars)
            local blind_text = {}
            
            local _dollars = blind.dollars
            local loc_vars = nil
            if blind.collection_loc_vars and type(blind.collection_loc_vars) == 'function' then
                local res = blind:collection_loc_vars() or {}
                loc_vars = res.vars
            end
            local loc_target = localize{type = 'raw_descriptions', key = blind.key, set = 'summon_blind', vars = loc_vars or vars or blind.vars}
            local loc_name = localize{type = 'name_text', key = blind.key, set = 'summon_blind'}
        
            if jimbomod.config['Summoned Blinds'][blind.key] then 
            local ability_text = {}
            if loc_target then 
                for k, v in ipairs(loc_target) do
                ability_text[#ability_text + 1] = {n=G.UIT.R, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = (k ==1 and blind.name == 'The Wheel' and '1' or '')..v, scale = 0.35, shadow = true, colour = G.C.WHITE}}}}
                end
            end
            local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.4)
            blind_text[#blind_text + 1] =
                {n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, minw = 2.5, padding = 0.07, colour = G.C.WHITE}, nodes={
                ability_text[1] and {n=G.UIT.R, config={align = "cm", padding = 0.08, colour = mix_colours(blind.boss_colour, G.C.GREY, 0.4), r = 0.1, emboss = 0.05, minw = 2.5, minh = 0.9}, nodes=ability_text} or nil
                }}
            elseif G.localization.descriptions.summon_blind[blind.key] then
            blind_text[#blind_text + 1] =
                {n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, minw = 2.5, padding = 0.1, colour = G.C.WHITE}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.T, config={text = "Defeat this blind", scale = 0.4, colour = G.C.UI.TEXT_DARK}},
                }},
                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.T, config={text = 'while it is Summoned', scale = 0.4, colour = G.C.UI.TEXT_DARK}},
                }},
                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.T, config={text = 'to discover it', scale = 0.4, colour = G.C.UI.TEXT_DARK}},
                }},
                }}
            else
                
                blind_text[#blind_text + 1] =
                {n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, minw = 2.5, padding = 0.1, colour = G.C.WHITE}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.T, config={text = "This blind is", scale = 0.4, colour = G.C.UI.TEXT_DARK}},
                }},
                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.T, config={text = 'unsummonable', scale = 0.4, colour = G.C.UI.TEXT_DARK}},
                }},
                }}
            end
            local ret = oldfunc(blind,discovered,vars)
            if not ret then return end
            if G.localization.descriptions.summon_blind[blind.key] then
            --[
                ret.nodes[#ret.nodes+1] = {
                    n=G.UIT.R, 
                            config={
                                align = "cm", 
                                emboss = 0.05, 
                                r = 0.1, 
                                minw = 2.5, 
                                padding = 0.1, 
                                colour = not jimbomod.config['Summoned Blinds'][blind.key] and G.C.JOKER_GREY or blind.boss_colour or G.C.GREY
                            }, 
                            nodes={
                                {
                                    n=G.UIT.R, 
                                    config={
                                        align = "cm", 
                                        emboss = 0.05, 
                                        r = 0.1, 
                                        minw = 2.5, 
                                        padding = 0.1, 
                                        colour = not jimbomod.config['Summoned Blinds'][blind.key] and G.C.JOKER_GREY or blind.boss_colour or G.C.GREY
                                    }, 
                                    nodes={
                                        {
                                            n=G.UIT.O, 
                                            config={
                                                object = DynaText({
                                                    string = jimbomod.config['Summoned Blinds'][blind.key] and loc_name or 'Not Discovered', 
                                                    colours = {G.C.UI.TEXT_LIGHT}, 
                                                    shadow = true, 
                                                    rotate = not jimbomod.config['Summoned Blinds'][blind.key], 
                                                    spacing = jimbomod.config['Summoned Blinds'][blind.key] and 2 or 0, 
                                                    bump = true, 
                                                    scale = 0.3
                                                })
                                            }
                                        },
                                    }
                                },
                                {
                                    n=G.UIT.R, 
                                    config={align = "cm"}, 
                                    nodes=blind_text
                                },
                            }
                }
                --]]
                --[[ret.nodes[#ret.nodes+1] = {
                    n=G.UIT.ROOT, 
                    config={
                        align = "cm", 
                        padding = 0.05, 
                        colour = lighten(G.C.JOKER_GREY, 0.5),
                        r = 0.1, 
                        emboss = 0.05,
                        offset = {x=0.5,y=0}
                    }, 
                    nodes={
                        {
                            n=G.UIT.R, 
                            config={
                                align = "cm", 
                                emboss = 0.05, 
                                r = 0.1, 
                                minw = 2.5, 
                                padding = 0.1, 
                                colour = not jimbomod.config['Summoned Blinds'][blind.key] and G.C.JOKER_GREY or blind.boss_colour or G.C.GREY
                            }, 
                            nodes={
                                {
                                    n=G.UIT.O, 
                                    config={
                                        object = DynaText({
                                            string = jimbomod.config['Summoned Blinds'][blind.key] and loc_name or 'Not Discovered', 
                                            colours = {G.C.UI.TEXT_LIGHT}, 
                                            shadow = true, 
                                            rotate = not jimbomod.config['Summoned Blinds'][blind.key], 
                                            spacing = jimbomod.config['Summoned Blinds'][blind.key] and 2 or 0, 
                                            bump = true, 
                                            scale = 0.4
                                        })
                                    }
                                },
                            }
                        },
                        {
                            n=G.UIT.R, 
                            config={align = "cm"}, 
                            nodes=blind_text
                        },
                    }
                }]]
            end
            return ret
            --[[
            return {
                n=G.UIT.ROOT, 
                config={
                    align = "cm", 
                    padding = 0.05, 
                    colour = lighten(G.C.JOKER_GREY, 0.5), 
                    r = 0.1, 
                    emboss = 0.05
                }, 
                nodes={
                    {
                        n=G.UIT.R, 
                        config={
                            align = "cm", 
                            emboss = 0.05, 
                            r = 0.1, 
                            minw = 2.5, 
                            padding = 0.1, 
                            colour = not discovered and G.C.JOKER_GREY or blind.boss_colour or G.C.GREY
                        }, 
                        nodes={
                            {
                                n=G.UIT.O, 
                                config={
                                    object = DynaText({
                                        string = discovered and loc_name or localize('k_not_discovered'), 
                                        colours = {G.C.UI.TEXT_LIGHT}, 
                                        shadow = true, 
                                        rotate = not discovered, 
                                        spacing = discovered and 2 or 0, 
                                        bump = true, 
                                        scale = 0.4
                                    })
                                }
                            },
                        }
                    },
                    {
                        n=G.UIT.R, 
                        config={align = "cm"}, 
                        nodes=blind_text
                    },
                }}
            --]]
        end


        local oldfunc = create_UIBox_blind_choice
        function create_UIBox_blind_choice(type, run_info)
            local ret = oldfunc(type,run_info)
            if type == 'Boss' and G.GAME.boss_summoned then
                if not G.GAME.blind_on_deck then
                    G.GAME.blind_on_deck = 'Small'
                end
                if not run_info then G.GAME.round_resets.blind_states[G.GAME.blind_on_deck] = 'Select' end
                
                local disabled = false
                type = type or 'Small'
                
                local blind_choice = {
                    config = G.P_BLINDS[G.GAME.round_resets.blind_choices[type]],
                }
                
                blind_choice.animation = AnimatedSprite(0,0, 1.4, 1.4, G.ANIMATION_ATLAS['blind_chips'],  blind_choice.config.pos)
                blind_choice.animation:define_draw_steps({
                    {shader = 'dissolve', shadow_height = 0.05},
                    {shader = 'dissolve'}
                })
                local extras = nil
                local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)
                
                G.GAME.orbital_choices = G.GAME.orbital_choices or {}
                G.GAME.orbital_choices[G.GAME.round_resets.ante] = G.GAME.orbital_choices[G.GAME.round_resets.ante] or {}
                
                if not G.GAME.orbital_choices[G.GAME.round_resets.ante][type] then 
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible then _poker_hands[#_poker_hands+1] = k end
                    end
                
                    G.GAME.orbital_choices[G.GAME.round_resets.ante][type] = pseudorandom_element(_poker_hands, pseudoseed('orbital'))
                end
                
                
                
                if type == 'Small' then
                    extras = create_UIBox_blind_tag(type, run_info)
                elseif type == 'Big' then
                    extras = create_UIBox_blind_tag(type, run_info)
                elseif not run_info then
                    local dt1 = DynaText({string = {{string = localize('ph_up_ante_1'), colour = G.C.FILTER}}, colours = {G.C.BLACK}, scale = 0.55, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 3})
                    local dt2 = DynaText({string = {{string = localize('ph_up_ante_2'), colour = G.C.WHITE}},colours = {G.C.CHANCE}, scale = 0.35, silent = true, pop_delay = 4.5, shadow = true, maxw = 3})
                    local dt3 = DynaText({string = {{string = localize('ph_up_ante_3'), colour = G.C.WHITE}},colours = {G.C.CHANCE}, scale = 0.35, silent = true, pop_delay = 4.5, shadow = true, maxw = 3})
                    extras = 
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.R, config={align = "cm", padding = 0.07, r = 0.1, colour = {0,0,0,0.12}, minw = 2.9}, nodes={
                        {n=G.UIT.R, config={align = "cm"}, nodes={
                            {n=G.UIT.O, config={object = dt1}},
                        }},
                        {n=G.UIT.R, config={align = "cm"}, nodes={
                            {n=G.UIT.O, config={object = dt2}},
                        }},
                        {n=G.UIT.R, config={align = "cm"}, nodes={
                            {n=G.UIT.O, config={object = dt3}},
                        }},
                        }},
                    }}
                end
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                
                local loc_target = localize{type = 'raw_descriptions', key = blind_choice.config.key, set = 'summon_blind', vars = {localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands')}}
                local loc_name = localize{type = 'name_text', key = blind_choice.config.key, set = 'summon_blind'}
                if next(find_joker('Chicot')) then
                    loc_target = localize{type = 'raw_descriptions', key = blind_choice.config.key, set = 'Blind', vars = {localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands')}}
                    loc_name = localize{type = 'name_text', key = blind_choice.config.key, set = 'Blind'}
                end
                if not G.localization.descriptions.summon_blind[blind_choice.config.key] then
                    return ret
                end
                local text_table = loc_target
                local blind_col = get_blind_main_colour(type)
                local blind_amt = get_blind_amount(G.GAME.round_resets.blind_ante)*blind_choice.config.mult*G.GAME.starting_params.ante_scaling
                
                local blind_state = G.GAME.round_resets.blind_states[type]
                local _reward = true
                if G.GAME.modifiers.no_blind_reward and G.GAME.modifiers.no_blind_reward[type] then _reward = nil end
                if blind_state == 'Select' then blind_state = 'Current' end
                local run_info_colour = run_info and (blind_state == 'Defeated' and G.C.GREY or blind_state == 'Skipped' and G.C.BLUE or blind_state == 'Upcoming' and G.C.ORANGE or blind_state == 'Current' and G.C.RED or G.C.GOLD)
                local t = 
                {n=G.UIT.R, config={id = type, align = "tm", func = 'blind_choice_handler', minh = not run_info and 10 or nil, ref_table = {deck = nil, run_info = run_info}, r = 0.1, padding = 0.05}, nodes={
                    {n=G.UIT.R, config={align = "cm", colour = mix_colours(G.C.BLACK, G.C.L_BLACK, 0.5), r = 0.1, outline = 1, outline_colour = G.C.L_BLACK}, nodes={  
                    {n=G.UIT.R, config={align = "cm", padding = 0.2}, nodes={
                        not run_info and {n=G.UIT.R, config={id = 'select_blind_button', align = "cm", ref_table = blind_choice.config, colour = disabled and G.C.UI.BACKGROUND_INACTIVE or G.C.ORANGE, minh = 0.6, minw = 2.7, padding = 0.07, r = 0.1, shadow = true, hover = true, one_press = true, button = 'select_blind'}, nodes={
                            {n=G.UIT.T, config={ref_table = G.GAME.round_resets.loc_blind_states, ref_value = type, scale = 0.45, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.UI.TEXT_LIGHT, shadow = not disabled}}
                        }} or 
                        {n=G.UIT.R, config={id = 'select_blind_button', align = "cm", ref_table = blind_choice.config, colour = run_info_colour, minh = 0.6, minw = 2.7, padding = 0.07, r = 0.1, emboss = 0.08}, nodes={
                            {n=G.UIT.T, config={text = localize(blind_state, 'blind_states'), scale = 0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
                        }}
                        }},
                        {n=G.UIT.R, config={id = 'blind_name',align = "cm", padding = 0.07}, nodes={
                        {n=G.UIT.R, config={align = "cm", r = 0.1, outline = 1, outline_colour = blind_col, colour = darken(blind_col, 0.3), minw = 2.9, emboss = 0.1, padding = 0.07, line_emboss = 1}, nodes={
                            {n=G.UIT.O, config={object = DynaText({string = loc_name, colours = {disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE}, shadow = not disabled, float = not disabled, y_offset = -4, scale = 0.45, maxw =2.8})}},
                        }},
                        }},
                        {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                        {n=G.UIT.R, config={id = 'blind_desc', align = "cm", padding = 0.05}, nodes={
                            {n=G.UIT.R, config={align = "cm"}, nodes={
                            {n=G.UIT.R, config={align = "cm", minh = 1.5}, nodes={
                                {n=G.UIT.O, config={object = blind_choice.animation}},
                            }},
                            text_table[1] and {n=G.UIT.R, config={align = "cm", minh = 0.7, padding = 0.05, minw = 2.9}, nodes={
                                text_table[1] and {n=G.UIT.R, config={align = "cm", maxw = 2.8}, nodes={
                                {n=G.UIT.T, config={id = blind_choice.config.key, ref_table = {val = ''}, ref_value = 'val', scale = 0.32, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled, func = 'HUD_blind_debuff_prefix'}},
                                {n=G.UIT.T, config={text = text_table[1] or '-', scale = 0.32, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}}
                                }} or nil,
                                text_table[2] and {n=G.UIT.R, config={align = "cm", maxw = 2.8}, nodes={
                                {n=G.UIT.T, config={text = text_table[2] or '-', scale = 0.32, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}}
                                }} or nil,
                                text_table[3] and {n=G.UIT.R, config={align = "cm", maxw = 2.8}, nodes={
                                    {n=G.UIT.T, config={text = text_table[3] or '-', scale = 0.32, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}}
                                }} or nil,
                                text_table[4] and {n=G.UIT.R, config={align = "cm", maxw = 2.8}, nodes={
                                    {n=G.UIT.T, config={text = text_table[4] or '-', scale = 0.32, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}}
                                }} or nil,
                            }} or nil,
                            }},
                            {n=G.UIT.R, config={align = "cm",r = 0.1, padding = 0.05, minw = 3.1, colour = G.C.BLACK, emboss = 0.05}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 3}, nodes={
                                {n=G.UIT.T, config={text = localize('ph_blind_score_at_least'), scale = 0.3, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}}
                            }},
                            {n=G.UIT.R, config={align = "cm", minh = 0.6}, nodes={
                                {n=G.UIT.O, config={w=0.5,h=0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false}},
                                {n=G.UIT.B, config={h=0.1,w=0.1}},
                                {n=G.UIT.T, config={text = number_format(blind_amt), scale = score_number_scale(0.9, blind_amt), colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.RED, shadow =  not disabled}}
                            }},
                            _reward and {n=G.UIT.R, config={align = "cm"}, nodes={
                                {n=G.UIT.T, config={text = localize('ph_blind_reward'), scale = 0.35, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}},
                                {n=G.UIT.T, config={text = string.rep(localize("$"), blind_choice.config.dollars)..'+', scale = 0.35, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.MONEY, shadow = not disabled}}
                            }} or nil,
                            }},
                        }},
                        }},
                    }},
                        {n=G.UIT.R, config={id = 'blind_extras', align = "cm"}, nodes={
                        extras,
                        }}
                
                    }}
                return t
            end
            return ret
        end
    --



    --Blind summoning
        function Blind:jimb_summon()
            if self.disabled == true then
                self.disabled = false
                return
            end
            if not G.localization.descriptions.summon_blind[self.config.blind.key] then
                G.GAME.blind.chips = G.GAME.blind.chips + get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*0.5
                return 
            end
            self.summoned = true
            if G.table_thing then
                self:start_materialize()
            end

            local selected_back = (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
            selected_back = get_deck_from_name(selected_back)
            local nameKey = 'default'
            if G.localization.misc.quips[self.name .. ' Red Deck1'] then
                if G.localization.misc.quips[self.name .. ' ' .. selected_back.name .. '1'] then
                    nameKey = self.name .. ' ' .. selected_back.name .. math.random(1,3)
                else
                    nameKey = self.name .. ' Red Deck1'
                end
            end
            self:add_speech_bubble(nameKey,nil,{quip = true})
            self:say_stuff(10,nil,{pitch = math.random(3,5)*0.15})


            --local SC_scale = 1.1*(G.debug_splash_size_toggle and 0.8 or 1)

            --local loc_target = localize{type = 'raw_descriptions', key = self.config.blind.key, set = 'Blind', vars = loc_vars or self.config.blind.vars}
            self:set_text()


            self:jimb_calc({summon = true})
            local spritepos = self:jimb_calc({sprite = true})
            if G.summon_sprite then G.summon_sprite:set_sprite_pos({x = 0, y = 0}) end
            if G.summon_sprite and spritepos then G.summon_sprite:set_sprite_pos(spritepos) end
        end



        local oldfunc = Blind.defeat
        function Blind:defeat(silent)
            local ret = oldfunc(self,silent)
            self.summoned = nil
            if self.summoned == true then
                if self:get_type() == 'Boss' then
                    if (G.GAME.curse_summon or G.GAME.temp_pure_summon) and G.GAME.boss_summoned then
                        local newcard = create_card('jimb_curses', G.jokers, nil, nil, nil, nil, nil)
                        newcard:add_to_deck()
                        G.consumeables:emplace(newcard)
                        if G.GAME.temp_pure_summon then
                            newcard:purify()
                        end
                    end
                    if G.localization.descriptions.summon_blind[self.config.blind.key] then
                        jimbomod.config["Summoned Blinds"][self.config.blind.key] = true
                        SMODS.save_mod_config(jimbomod)
                    end
                end


                local selected_back = (G.GAME.viewed_back and G.GAME.viewed_back.name) or G.GAME.selected_back and G.GAME.selected_back.name or 'Red Deck'
                selected_back = get_deck_from_name(selected_back)
                local nameKey = 'default'
                if G.localization.misc.quips[self.name .. ' Red Deck_defeat1'] then
                    if G.localization.misc.quips[self.name .. ' ' .. selected_back.name .. '_defeat1'] then
                        nameKey = self.name .. ' ' .. selected_back.name .. '_defeat' .. math.random(1,2)
                    else
                        nameKey = self.name .. ' Red Deck_defeat' .. math.random(1,2)
                    end
                end
                self:add_speech_bubble(nameKey,nil,{quip = true})
                self:say_stuff(3,nil,{pitch = 1.5})
                self:start_dissolve()
            end
            if G.GAME.manacle_handsize then
                G.hand:change_size(G.GAME.manacle_handsize)
                G.GAME.manacle_handsize = nil
            end

            return ret
        end

        local oldfunc = new_round
        function new_round()
            local ret = oldfunc()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    if G.GAME.boss_summoned == true and G.GAME.blind:get_type() == 'Boss' or G.GAME.small_summoned and G.GAME.blind:get_type() == 'Small' then
                        --self.summoned = true
                        G.GAME.blind:jimb_summon()
                    end
                    return true
                    end
                }))
            return ret
        end
        local oldfunc = reset_blinds
        function reset_blinds()
            if G.GAME.chance_summon then
                if pseudorandom('chance_summon') < G.GAME.chance_summon then
                    G.GAME.boss_summoned = true
                end
            end
            
            if G.GAME.chance_small_summon then
                if pseudorandom('chance_small_summon') < G.GAME.chance_small_summon then
                    G.GAME.small_summoned = true 
                end
            end
            local ret = oldfunc()
            
            return ret
        end

        local oldfunc = Blind.set_text
        function Blind:set_text()
            local ret = oldfunc(self)
            if G.GAME.boss_summoned and self:get_type() == 'Boss' and self.summoned ~= true then 
                self.summoned = true
                self:set_text()
            end
            if self.summoned == true or self:get_type() == 'Boss' and G.GAME.boss_summoned == true or self:get_type() == 'Small' and G.GAME.small_summoned then
                if self.disabled == true then
                    self.disabled = false
                    self.trueDisabled = true
                    local loc_target = localize{type = 'raw_descriptions', key = self.config.blind.key, set = 'Blind', vars = self.config.blind.vars} or self.config.blind.loc_txt
                    if loc_target then 
                        self.loc_name = self.name == '' and self.name or localize{type ='name_text', key = self.config.blind.key, set = 'Blind'}
                        self.loc_debuff_text = ''
                        for k, v in ipairs(loc_target) do
                            self.loc_debuff_text = self.loc_debuff_text..v..(k <= #loc_target and ' ' or '')
                        end
                        --self.loc_debuff_lines[1] = loc_target[1] or ''
                        --self.loc_debuff_lines[2] = loc_target[2] or ''
                        for i = 1, #loc_target do
                            self.loc_debuff_lines[i] = loc_target[i] or ''
                        end
                    end
                else
                    local loc_target = localize{type = 'raw_descriptions', key = self.config.blind.key, set = 'summon_blind', vars = self.config.blind.vars}
                    if G.localization.descriptions['summon_blind'][self.config.blind.key] and loc_target then 
                        self.loc_name = self.name == '' and self.name or localize{type ='name_text', key = self.config.blind.key, set = 'Blind'}
                        self.loc_debuff_text = ''
                        for k, v in ipairs(loc_target) do
                            self.loc_debuff_text = self.loc_debuff_text..v..(k <= #loc_target and ' ' or '')
                        end
                        --self.loc_debuff_lines[1] = loc_target[1] or ''
                        --self.loc_debuff_lines[2] = loc_target[2] or ''
                        for i = 1, #loc_target do
                            self.loc_debuff_lines[i] = loc_target[i] or ''
                        end
                    end
            
                end
            end
            return ret
        end

        local oldfunc = get_new_boss
        function get_new_boss()
            local ret = oldfunc()
            if G.GAME.boss_summoned then
                if (not G.localization.descriptions.summon_blind[ret]) and (G.GAME.round_resets.ante % 8 ~= 0) then
                    --print(ret)
                    return get_new_boss()
                end
            end
            return ret
        end
    --


--Summons

--Other
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
            G.title_top.cards[1]:add_speech_bubble('jimbo_menu' .. math.random(1,8),nil,{quip = true})
            G.title_top.cards[1]:say_stuff(10,nil,{pitch = 1})
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
--Other

---Curses
    --
    function jimbomod.process_loc_text()
        --G.localization.descriptions.jimb_curses = G.localization.descriptions.jimb_curses or {}
        G.localization.descriptions.summon_blind = G.localization.descriptions.summon_blind or {}
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

    SMODS.UndiscoveredSprite({
        key = "jimb_curses",
        atlas = "Curse",
        path = "Curses.png",
        pos = { x = 0, y = 0 },
        px = 71,
        py = 95,
    })

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
    --[[
    SMODS.UndiscoveredSprite{
        key = 'jimb_curses',
        atlas = 'Curse',
        pos = {y = 0, x = 0}
    }
    ]]

    function Card:purify()
        if self.ability.purify_preventing then
            self.ability.purify_preventing = nil
            return
        end
        self.purified = true
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({jimb_purify = true, other_card = self,})
        end
    end

    local sanctuary = SMODS.Consumable {
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
                G.jokers.highlighted[1]:purify()
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
    --
    local sin = SMODS.Consumable {
        key = 'sin',
        set = 'Spectral',
        loc_txt = {
            name = 'Sin',
            text = {
                "Summon this {C:attention}Ante's",
                '{C:attention}Boss Blind{}',
                'When it is defeated,',
                'create a {C:legendary}Purified Curse'
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
            G.GAME.boss_summoned = true
            G.GAME.temp_pure_summon = true
        end,
        in_pool = function(self,card,wawa)
            if jimbomod.config.Curses == false then
                return false
            end
            return true
        end,
    }
    --]]


    ---curses list
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
                else
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'hook_pure',
                        specific_vars = {math.abs(center.ability.extra.h_size)},
                    }
                end
                return {key = key1,vars = {center.ability.extra.h_size}}
            end,
            calculate = function(self,card,context)
                if context.jimb_purify and context.other_card == card then
                    card.ability.extra.h_size = math.abs(card.ability.extra.h_size)
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
                else
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'wall_pure',
                        specific_vars = {math.abs(center.ability.extra.pure)},
                    }
                end
                return {key = key1,vars = {center.ability.extra.b_size}}
            end,
            calculate = function(self,card,context)
                if context.jimb_purify and context.other_card == card then
                    card.ability.extra.b_size = card.ability.extra.pure
                end
                if context.setting_blind and G.GAME.blind:get_type() == "Boss" then
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
                else
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'arm_pure',
                        specific_vars = {},
                    }
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
                else
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'water_pure',
                        specific_vars = {math.abs(center.ability.extra.discards)},
                    }
                end
                
                return {key = key1,vars = {center.ability.extra.discards}}
            end,
            calculate = function(self,card,context)
                if context.jimb_purify and context.other_card == card then
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
                else
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'needle_pure',
                        specific_vars = {math.abs(center.ability.extra.hands)},
                    }
                end
                return {key = key1,vars = {center.ability.extra.hands}}
            end,
            calculate = function(self,card,context)
                if context.jimb_purify and context.other_card == card then
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
                else
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'oxen_pure',
                        specific_vars = {math.abs(center.ability.extra.dollars)},
                    }
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
                if context.jimb_purify and context.other_card == card then
                    card.ability.extra.dollars = math.abs(card.ability.extra.dollars)
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
                else
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'manacle_pure',
                        specific_vars = {math.abs(center.ability.extra.pure)},
                    }
                end
                return {key = key1,vars = {center.ability.extra.h_size}}
            end,
            calculate = function(self,card,context)
                if context.jimb_purify and context.other_card == card then
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
                else
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'tooth_pure',
                        specific_vars = {math.abs(center.ability.extra.dollars)},
                    }
                end
                return {key = key1,vars = {center.ability.extra.dollars}}
            end,
            calculate = function(self,card,context)
                if context.jimb_purify and context.other_card == card then
                    card.ability.extra.dollars = math.abs(card.ability.extra.dollars)
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
            config = {extra = {cardMult = 0.9,pure = 1.1,odds = 5}},
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
                else
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'zone_pure',
                        specific_vars = {math.abs(center.ability.extra.pure)},
                    }
                end
                return {key = key1,vars = {center.ability.extra.cardMult, G.GAME.probabilities.normal, center.ability.extra.odds}}
            end,
            calculate = function(self,card,context)
                if context.jimb_purify and context.other_card == card then
                    card.ability.extra.cardMult = card.ability.extra.pure
                end
                if context.jimb_creating_card and pseudorandom('totem') < G.GAME.probabilities.normal/card.ability.extra.odds  then
                    jokerMult(context.other_card, card.ability.extra.cardMult)
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
                if context.jimb_draw_card and context.other_card then
                    if context.other_card:is_suit("Spades") then
                        if card.purified == true then
                            G.hand:change_size(1)
                        else
                                --context.other_card:flip()
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
        --[
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
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'goad_pure',
                        specific_vars = {},
                    }
                end
                return {key = key1,vars = {center.ability.extra.dollars}}
            end,
            calculate = function(self,card,context)
                if context.jimb_purify and context.other_card == card then
                    card.purified = true
                    for i = 1, #G.playing_cards do
                        local cards = G.playing_cards[i]
                        if cards:is_suit('Spades') then
                            cards.edition = cards.edition or {}
                            cards.edition.card_limit = (cards.edition.card_limit and cards.edition.card_limit+1) or 1
                        end
                    end
                end
                if card.purified == true then
                    if context.jimb_post_create_card and context.other_card:is_suit('Spades') then
                        cards.edition = cards.edition or {}
                        cards.edition.card_limit = (cards.edition.card_limit and cards.edition.card_limit+1) or 1
                    end
                else
                    if context.check_suit and isSuit(context.other_card, 'Spades') then
                        return false
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
        --]]
        local head = SMODS.Consumable {
            key = "head",
            purified = false,
            set = 'jimb_curses',
            config = {extra = {Xmult = 0.8,pure = 1.3}},
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
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'head_pure',
                        specific_vars = {center.ability.extra.pure},
                    }
                end
                return {key = key1,vars = {center.ability.extra.Xmult}}
            end,
            calculate = function(self,card,context)
                if context.jimb_purify and context.other_card == card then
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
            config = {extra = {chip_mod = 5, chips = 0}},
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
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'club_pure',
                        specific_vars = {center.ability.extra.chip_mod, 0},
                    }
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
                if context.jimb_purify and context.other_card == card then
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

        local window = SMODS.Consumable {
            key = "window",
            purified = false,
            set = 'jimb_curses',
            config = {extra = {dollars = -2,pure = 2}},
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
                    info_queue[#info_queue + 1] = {
                        set = "Other",
                        key = 'window_pure',
                        specific_vars = {center.ability.extra.pure},
                    }
                end
                return {key = key1,vars = {center.ability.extra.dollars}}
            end,
            calculate = function(self,card,context)
                if context.jimb_purify and context.other_card == card then
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
    ---curses list


    local oldfunc = CardArea.remove_card
    function CardArea:remove_card(card, discarded_only)
        local ret = oldfunc(self,card,discarded_only)
        if (G.jokers) then
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({jimb_removing_card_area = true, other_card = ret,area = self})
            end
        end
        return ret
    end
---Curses

---Special Spectrals
    --

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
    for i = 1, 30 do
        G.localization.misc.quips['nil_' .. i] = {nilll[math.random(1,#nilll)], nilll[math.random(1,#nilll)]}
    end

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
                jokerMult(context.other_card,card.ability.extra.num1, operationfuncs[math.random(1,#operationfuncs)])
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
            local card_example = nil
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
                if pseudorandom('amalgam') < G.GAME.probabilities.normal/card.ability.extra.odds and not context.other_card.restart then
                    context.other_card:start_dissolve()
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

    --[[function Card:jimb_talk(text)
        self:juice_up()
        if type(text) == 'string' then text = {text} end



        local row = {}
        for k, v in ipairs(text) do
            row[#row+1] =  {
                n=G.UIT.R, config={align = "cl"}, 
                nodes= {n=G.UIT.O, config={
                    object = DynaText({
                        string = text,
                        colours = {G.C.UI.TEXT_LIGHT},
                        bump = true,
                        silent = true,
                        pop_in = 0,
                        pop_in_rate = 4,
                        maxw = 5,
                        shadow = true,
                        y_offset = -0.6,
                        spacing = math.max(0, 0.32*(17 - #text)),
                        scale =  (0.55 - 0.004*#text)*(1)
                    })
                }}
            }
        end

        local t = {n=G.UIT.ROOT, config = {align = "cm", minh = 1,r = 0.3, padding = 0.07, minw = 1, colour = G.C.JOKER_GREY, shadow = true}, nodes={
            {n=G.UIT.C, config={align = "cm", minh = 1,r = 0.2, padding = 0.1, minw = 1, colour = G.C.WHITE}, nodes={
            {n=G.UIT.C, config={align = "cm", minh = 1,r = 0.2, padding = 0.03, minw = 1, colour = G.C.WHITE}, nodes=row}}
            }
        }}

        self.config.speech_bubble_align = {align='bm', offset = {x=0,y=0},parent = self}
        self.children.speech_bubble = 
        UIBox{
            definition = t,
            config = self.config.speech_bubble_align
        }
        self.children.speech_bubble:set_role{
            role_type = 'Minor',
            xy_bond = 'Weak',
            r_bond = 'Strong',
            major = self,
        }
    end]]

    --quips
        G.localization.misc.quips['hunger_amalgam1'] = {"{C:red,E:1.5,S:2.5,s:2}FEED ME!{}"}
        G.localization.misc.quips['hunger_amalgam2'] = {"{C:red,E:1.5,S:2.5,s:2}NEED...", "{C:red,E:1.5,S:2.5,s:2}FLESH...{}"}
        G.localization.misc.quips['hunger_amalgam3'] = {"{C:red,E:1.5,S:2.5,s:2}I REQUIRE SUSTENANCE.{}"}
        G.localization.misc.quips['hunger_amalgam4'] = {"{C:red,E:1.5,S:2.5,s:2}GIVE ME" ,"{C:red,E:1.5,S:2.5,s:2}THEIR FLESH.{}"}
        G.localization.misc.quips['hunger_amalgam5'] = {"{C:red,E:1.5,S:2.5,s:2}I DEMAND FOR", "{C:red,E:1.5,S:2.5,s:2}THEIR BLOOD.{}"}

        G.localization.misc.quips['feed_amalgam1'] = {"{C:red,E:1.5,S:2.5,s:2}THIS WILL", "{C:red,E:1.5,S:2.5,s:2}BE PLENTY.{}"}
        G.localization.misc.quips['feed_amalgam2'] = {"{C:red,E:1.5,S:2.5,s:2}GREAT."}
        G.localization.misc.quips['feed_amalgam3'] = {"{C:red,E:1.5,S:2.5,s:2}DELICIOUS."}
        G.localization.misc.quips['feed_amalgam4'] = {"{C:red,E:1.5,S:2.5,s:2}THIS IS", "{C:red,E:1.5,S:2.5,s:2}ENOUGH.{}"}
        G.localization.misc.quips['feed_amalgam5'] = {"{C:red,E:1.5,S:2,s:2}I'LL TAKE", "{C:red,E:1.5,S:2,s:2}IT, I GUESS.{}"}

        G.localization.misc.quips['feed2_amalgam1'] = {"{C:red,E:1.5,S:2.5,s:2}TAKE THIS", "{C:red,E:1.5,S:2.5,s:2}BACK."}
        G.localization.misc.quips['feed2_amalgam2'] = {"{C:red,E:1.5,S:2.5,s:2}THIS IS", "{C:red,E:1.5,S:2.5,s:2}STALE."}
        G.localization.misc.quips['feed2_amalgam3'] = {"{C:red,E:1.5,S:2.5,s:2}YOU DISGUST", "{C:red,E:1.5,S:2.5,s:2}ME."}
        G.localization.misc.quips['feed2_amalgam4'] = {"{C:red,E:1.5,S:2.5,s:2}YOU DARE", "{C:red,E:1.5,S:2.5,s:2}GIVE ME THIS?"}
        G.localization.misc.quips['feed2_amalgam5'] = {"{C:red,E:1.5,S:2.5,s:2}YOU ARE", "{C:red,E:1.5,S:2.5,s:2}UNLOVED."}

        G.localization.misc.quips['hi_derek1'] = {"{C:red,E:1.5,S:2.5,s:2}WHO ARE", "{C:red,E:1.5,S:2.5,s:2}YOU?"}
        G.localization.misc.quips['derek_say_hi'] = {"Hi! I'm derek"}
        G.localization.misc.quips['hi_derek2'] = {"{C:red,E:1.5,S:2.5,s:2}HELLO, DEREK.",}
        G.localization.misc.quips['hi_derek3'] = {"{C:red,E:1.5,S:2.5,s:2}SUBSCRIBE TO", "{C:red,E:1.5,S:2.5,s:2}THE CHANNEL."}
        G.localization.misc.quips['hi_derek4'] = {"{C:red,E:1.5,S:2.5,s:2}DOWNLOAD THE", "{C:red,E:1.5,S:2.5,s:2}JIMBO'S PACK MOD."}
        G.localization.misc.quips['hi_derek5'] = {"{C:red,E:1.5,S:2.5,s:2}LOVE YOU,", "{C:red,E:1.5,S:2.5,s:2}DAREK."}


        G.localization.misc.quips['tredecim1'] = {"{C:legendary,E:1.5,S:2,s:2}Such deep emotions{}", '{C:legendary,E:1.5,S:2,s:2}of joy and whimsy...'}
        G.localization.misc.quips['tredecim2'] = {"{C:legendary,E:1.5,S:2,s:2}...can only be expressed{}", '{C:legendary,E:1.5,S:2,s:2}through the call of', '{C:legendary,E:1.5,S:2,s:2}one single letter.'}
    --quips

    local talkNum = 0

    --[[SMODS.Atlas{
        key = 'Derek',
        path = 'Derek.png',
        px = 71,
        py = 95
    }]]
    --[[
    SMODS.Joker{
        key = 'derek',
        loc_txt = {
            name = 'Derek',
            text = {
            'When Blind is selected,',
            'create a {C:attention}Joker{}',
            '{X:mult,C:white}X#1#{} Mult'
            }
        },
        atlas = 'Derek',

        pos = {x = 0, y = 0},
        config = { 
        extra = {
            Xmult = 2
        }
        },
        loc_vars = function(self,info_queue,center)
            return {vars = {center.ability.extra.Xmult}}
        end,
        calculate = function(self,card,context)
            if context.joker_main then
                return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
                }
            end

            if context.setting_blind then
                local new_card = create_card('Joker', G.jokers, nil,nil,nil,nil,'j_joker')
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
            end
        end,
        update = function(self,card,dt,a,b,c)

            if talkNum == 60*8.5 then
                card:add_speech_bubble('derek_say_hi',nil,{quip = true})
                card:say_stuff(1,nil,{duration = 5})
            end
        end,
    }
    ]]

    local amalgam = SMODS.Joker{
        key = 'amalgam',
        loc_txt = {
            name = "{C:edition}Amalgam{}",
            text = {
                'When leaving shop,',
                ' destroy a random joker and', 
                '{C:attention}copy its abilities',
                "{C:legendary}It's hungry..."
            },
        },
        rarity = 4,
        config = {extra = {odds = 30,jokers = {}}},
        pos = { x = 4, y = 6 },
        soul_pos = { x = 5, y = 6 },
        atlas = 'Tarot',
        cost = 12,
        unlocked = true,
        discovered = false,
        blueprint_compat = false,
        eternal_compat = false,
        perishable_compat = false,
        update = function(self,card,dt,a,b,c)
            if G and G.jokers then
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].config.center.key == 'j_jimb_derek' then
                        talkNum = talkNum + 1
                    end
                end
            end

            --[[if talkNum == 60*3.5 then
                card:add_speech_bubble('hi_derek1',nil,{quip = true})
                card:say_stuff(3,nil,{pitch = math.random(1,3)*0.2})
            end

            if talkNum == 60*13.5 then
                card:add_speech_bubble('hi_derek2',nil,{quip = true})
                card:say_stuff(3,nil,{pitch = math.random(1,3)*0.2})
            end

            if talkNum == 60*19.5 then
                card:add_speech_bubble('hi_derek3',nil,{quip = true})
                card:say_stuff(3,nil,{pitch = math.random(1,3)*0.2})
            end

            if talkNum == 60*23.5 then
                card:add_speech_bubble('hi_derek4',nil,{quip = true})
                card:say_stuff(3,nil,{pitch = math.random(1,3)*0.2})
            end

            if talkNum == 60*28.5 then
                card:add_speech_bubble('hi_derek5',nil,{quip = true})
                card:say_stuff(3,nil,{pitch = math.random(1,3)*0.2})
            end]]
        end,
        loc_vars = function(self, info_queue, center)
            local card_example = nil
            if center.jimb_jokers then
                local cardkeys = {}
                for i = 1, #center.jimb_jokers do
                    cardkeys[#cardkeys+1]=center.jimb_jokers[i].config.center.key
                end

                card_example, cards = center and center.jimb_jokers and center.jimb_jokers[1] and create_card_example(cardkeys) or ((not (G and G.jokers)) and create_card_example({'j_joker'})) or nil


                for i = 1, #center.jimb_jokers do
                    info_queue[#info_queue + 1] = {
                        set = "Joker",
                        key = center.jimb_jokers[i].config.center.key,
                        specific_vars = false and center.jimb_jokers[i].config.center.loc_vars and center.jimb_jokers[i].config.center:loc_vars(info_queue, center.jimb_jokers[i]) or {'???','???','???','???'},
                    }
                end
            end
            return {
                vars = {center.ability.extra.rounds,center.ability.extra.currentrounds},
                main_end = center and center.jimb_jokers and {card_example}
            }
        end,
        calculate = function(self,card,context)
            if context.jimb_pre_create_card then
                if to_big(pseudorandom('amalgam')) < to_big(G.GAME.probabilities.normal)/to_big(card.ability.extra.odds) and card.jimb_jokers and #card.jimb_jokers ~= 0 then
                    G.GAME.next_Gen_Cards[#G.GAME.next_Gen_Cards+1] = {key = card.config.center.key}
                    local quip = 'hunger_amalgam' .. math.random(1,5)
                    card:add_speech_bubble(quip,nil,{quip = true})
                    card:say_stuff(5,nil,{
                        monologue = {quip},
                        pitch = math.random(2,4)*0.2
                    })
                    --card:jimb_talk({'FEED ME!'})
                end
            end

            if context.jimb_card_gain and context.area == G.jokers and context.other_card and context.other_card.ability.name == card.ability.name and context.other_card ~= card then
                context.other_card:start_dissolve()
                card.ability.extra.odds = math.min(card.ability.extra.odds * 2,to_big(30))
                if card.jimb_jokers and #card.jimb_jokers > 0 then
                    local num = math.random(1,#card.jimb_jokers)
                    local removeCard = card.jimb_jokers[num]
                    local newcard = copy_card(removeCard,nil)
                    newcard.jimb_roundDebuff = 69420
                    G.jokers:emplace(newcard)
                    removeCard.jimb_roundDebuff = 69420
                    table.remove(card.jimb_jokers,num)

                    local quip = 'feed2_amalgam' .. math.random(1,5)
                    card:add_speech_bubble(quip,nil,{quip = true})
                    card:say_stuff(7,nil,{
                        monologue = {quip},
                        pitch = math.random(2,4)*0.2
                    })
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
                    if G.jokers.cards[i].ability.name ~= card.ability.name and G.jokers.cards[i].config.center.key ~= 'j_jimb_derek' then eligibleJokers[#eligibleJokers+1] = G.jokers.cards[i] end
                end
                if #eligibleJokers == 0 then return end
                local newcard = pseudorandom_element(eligibleJokers,pseudoseed('amalgam'))
                card.jimb_jokers = card.jimb_jokers or {}
                card.jimb_jokers[#card.jimb_jokers+1] = newcard
                newcard:start_dissolve()
                card.ability.extra.odds = math.max(to_big(card.ability.extra.odds/2),to_big(1))

                local quip = 'feed_amalgam' .. math.random(1,5)
                card:add_speech_bubble(quip,nil,{quip = true})
                card:say_stuff(7,nil,{
                    monologue = {quip},
                    pitch = math.random(2,4)*0.2
                })
            end
        end,
        in_pool = function(self,wawa,wawa2)
            return false
        end
    }

    --[[
    local release = SMODS.Voucher{
        key = 'release',
        loc_txt = {
            name = "{C:edition}Release{}",
            text = {
                'All {C:attention}Boss Blinds{} are summoned',
                'and give {C:legendary}Purified Curses'
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
    }]]

    local contextList = {
        --end_of_round = 
        {
            func = function(self,card,context)
                if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
                    return card:calculate_joker({jimb_nil_activate = true})
                end
            end,
            text = 'At end of round,'
        },
        --joker_main = 
        {
            func = function(self,card,context)
                if context.joker_main then
                    return card:calculate_joker({jimb_nil_activate = true})
                end
            end,
            text = 'When hand is played,'
        },
        --setting_blind = 
        {
            func = function(self,card,context)
                if context.setting_blind then
                    return card:calculate_joker({jimb_nil_activate = true})
                end
            end,
            text = 'When setting blind,'
        },
        --individual_playing_card = 
        {
            func = function(self,card,context)
                if context.individual and context.cardarea == G.play then
                    return card:calculate_joker({jimb_nil_activate = true})
                end
            end,
            text = 'When a card is scored,'
        },
        --individual_card_hand = 
        {
            func = function(self,card,context)
                if context.individual and context.cardarea == G.hand then
                    return card:calculate_joker({jimb_nil_activate = true})
                end
            end,
            text = 'For every card in hand,'
        },
        --jimb_creating_card = 
        {
            func = function(self,card,context)
                if context.jimb_creating_card then
                    return card:calculate_joker({jimb_nil_activate = true})
                end
            end,
            text = 'When a card is created,'
        },
        --randomize = 
        {
            func = function(self,card,context)
                if context.jimb_creating_card then
                    jokerMult(card,math.random(-125,325)/100, operationfuncs[math.random(1,#operationfuncs)])
                end
            end,
            text = 'When a card is created,'
        },
    }
    local rewardList = {
        {
            func = function(self,card,context)
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local front = pseudorandom_element(G.P_CARDS, pseudoseed('marb_fr'))
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local newcard = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_stone, {playing_card = G.playing_card})
                        newcard:start_materialize({G.C.SECONDARY_SET.Enhanced})
                        G.deck:emplace(newcard)
                        table.insert(G.playing_cards, newcard)
                        return true
                    end}))
            end,
            text = 'add a Stone card in your deck',
        },
        {
            func = function(self,card,context)
                if card.ability.joker_forced_key then 
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, card.ability.joker_forced_key)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                else
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card.ability.joker_forced_key = card.config.center.key
                end
            end,
            text = 'gain a random Joker',
        },
        {
            func = function(self,card,context)
                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_jimb_doomsday')
                    card:add_to_deck()
                    G.jokers:emplace(card)
            end,
            text = 'create a Doomsday Clock',
        },
        {
            func = function(self,card,context)
                card.ability.mult = card.ability.mult + 1
            end,
            text = 'gain +1 Mult',
        },
        {
            func = function(self,card,context)
                card.ability.Xmult = card.ability.Xmult + 0.01
            end,
            text = 'gain X0.01 Mult',
        },
        {
            func = function(self,card,context)
                if G.GAME.blind then G.GAME.blind.chips = G.GAME.blind.chips*0.985 end
            end,
            text = 'X0.985 blind size'
        },
        {
            func = function(self,card,context)
                ease_hands_played(1)
            end,
            text = 'gain +1 Hands this round',
        },
        {
            func = function(self,card,context)
                ease_discard(1)
            end,
            text = 'gain +1 Discards this round',
        },
        {
            func = function(self,card,context)
                local os1 = love._o
                if os1 == "OS X" then
                    os.execute("open https://www.youtube.com/watch?v=tQpbn-RnQ1Q")
                elseif os1 == "Windows" then
                    os.execute("start https://www.youtube.com/watch?v=tQpbn-RnQ1Q")
                elseif os1 == "Linux" then
                    os.execute("xdg-open https://www.youtube.com/watch?v=tQpbn-RnQ1Q")
                end
            end,
            text = 'open one of my videos',
        },
    }

    --[[
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
        extra_cost = 2,
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
        in_pool = function(self,wawa,wawa2)
            return false
        end
    })
    --]]
    local oldfunc = ease_ante
    ease_ante = function(num)
        local ret = oldfunc(num)
            --print('hiii')
            if G.GAME.used_vouchers['v_jimb_release'] then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                    local newcard = create_card('jimb_curses', G.jokers, nil, nil, nil, nil, nil)
                    newcard:add_to_deck()
                    G.consumeables:emplace(newcard)
            end

            if G and G.jokers then
                for i = 1, #G.jokers.cards do
                    G.jokers.cards[i]:calculate_joker({jimb_new_ante = true,})
                end
            end
        return ret
    end

    --[[
    local storm = SMODS.Blind{
        key = "storm",
        loc_txt = {
            name = 'Storm.',
            text = { '...' },
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
            print('skibid')
        end,
        in_pool = function(self,wawa,wawa2)
            if jimbomod.config["Boss Blinds"] == true then
                return true
            else
                return false
            end
        end,
    }
    ]]
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

---Special Spectrals



----------------------------------------------
------------MOD CODE END----------------------
