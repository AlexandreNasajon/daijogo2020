Functions = require('Functions')
Cards = {}

Cards.blank = {
    name = '',
    originalPoints = 0,
    points = 0,
    activated = false,
    costText = '',
    effectText = '',
    cost = function( player )
    end,
    effect = function( card , player , opponent )
    end
}

Cards.Clotz = {
    name = 'Clotz',
    originalPoints = 1,
    points = 1,
    activated = false,
    costText = '',
    effectText = 'Move 1 card from the top of your deck to your bin.',
    cost = function( player )
        return true
    end,
    effect = function( card , player , opponent)
        Functions.move( player.deck[#player.deck] , player.deck , player.bin )
        print('1 card was sent from the top of your deck to your bin.')
    end
}

Cards.Wuru = {
    name = 'Wuru',
    originalPoints = 1,
    points = 1,
    activated = false,
    costText = '',
    effectText = 'Destroy this unit to give -1 point to an enemy unit.',
    cost = function( player )
        return true
    end,
    effect = function( card , player , opponent )
        Functions.move( card , player.field , player.bin )
        if #opponent.field > 0 then
            local target = Functions.pick( opponent.field )
            target.points = target.points - 1
            print('This unit was destroyed and '..target.name..' lost 1 point.')
            Functions.checkDeath( target , opponent )
        end
    end
}

Cards.Prezu = {
    name = 'Prezu',
    originalPoints = 1,
    points = 1,
    activated = false, 
    costText = '',
    effectText = 'Discard a card to draw a card.',
    cost = function( player )
        return true
    end,
    effect = function( card , player , opponent )
        print('Discard a card from your hand:')
        local card = Functions.pick( player.hand )
        Functions.move( card , player.hand , player.bin )
        Functions.move( player.deck[#player.deck] , player.deck , player.hand )
        print('You discarded a card and drew another card.')
    end
}

Cards.Preru = {
    name = 'Preru',
    originalPoints = 1,
    points = 1,
    activated = false,
    costText = '',
    effectText = 'Erase 1 card from your bin to create a 1 point unit token.',
    cost = function( player )
        return true
    end,
    effect = function( card , player , opponent )
        Functions.newToken( player )
    end
}

Cards.Pretu = {
    name = 'Pretu',
    originalPoints = 1,
    points = 1,
    activated = false,
    costText = '',
    effectText = 'Give +1 point to another unit you control.',
    cost = function( player )
        return true
    end,
    effect = function( card , player , opponent )
        if #player.field > 1 then
            while true do
                local target = Functions.pick( player.field )
                if target ~= card then
                    target.points = target.points + 1
                    print(target.name..' gained 1 point.')
                    return
                end
            end
        end
    end
}

Cards.Duo = {
    name = 'Duo',
    originalPoints = 2, 
    points = 2,
    activated = false,
    costText = 'Erase 2 cards from your bin',
    effectText = 'Erase 2 cards from your bin to draw cards until you have 2 in your hand.',
    cost = function( player )
        return Functions.erase_n_from_bin ( player , 2 )
    end,
    effect = function( card , player , opponent )
        if Functions.erase_n_from_bin ( player , 2 ) == true then
            while #player.hand < 2 do -- compra até ter 2 na mão
                Functions.move( player.deck[#player.deck] , player.deck , player.hand )
            end
        end
    end
}

Cards.Zu = {
    name = 'Zu',
    originalPoints = 4,
    points = 4,
    activated = false,
    costText = 'Erase 4 cards from your bin.',
    effectText = 'Erase 4 cards from your bin to draw cards until you have 4 in your hand.',
    cost = function( player )
    end,
    effect = function( card , player , opponent )
        if Functions.erase_n_from_bin ( player , 4 ) == true then
            while #player.hand < 4 do 
                Functions.move( player.deck[#player.deck] , player.deck , player.hand )
            end
        end
    end
}

Cards.Tu = {
    name = 'Tu',
    originalPoints = 4,
    points = 4,
    activated = false,
    costText = 'Erase 4 cards from your bin.',
    effectText = 'Erase 4 cards from your bin to distribute +4 points among units you control.',
    cost = function( player )
    end,
    effect = function( card , player , opponent )
        if Functions.erase_n_from_bin ( player , 4 ) == true then
            local p = 4
            while p > 0 do
                local target = Functions.pick( player.field )
                target.points = target.points + 1
            end
        end
    end
}

Cards.Ru = {
    name = 'Ru',
    originalPoints = 4,
    points = 4,
    activated = false,
    costText = 'Erase 4 cards from your bin.',
    effectText = 'Erase 4 cards from your bin to create four 1 point unit tokens.',
    cost = function( player )
    end,
    effect = function( card , player , opponent )
        if Functions.erase_n_from_bin ( player , 4 ) == true then
            for i = 1 , 4 do
                Functions.newToken( player )
            end
        end
    end
}

return Cards
