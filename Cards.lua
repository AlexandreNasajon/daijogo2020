Functions = require('Functions')
Cards = {}

Cards.blank = {
    name = '',
    originalPoints = 0, -- pra resetar os pontos quando a carta mudar de zona
    points = 0,
    activated = false, -- só pode ativar uma vez por turno
    cost = function()
    end,
    effect = function()
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

Cards.Duo = {
    name = 'Duo',
    originalPoints = 2, 
    points = 2,
    activated = false,
    costText = 'Cost: erase 2 cards from your bin',
    effectText = 'Effect: erase 2 cards from your bin to draw cards until you have 2 in your hand.',
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


return Cards
