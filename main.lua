local Functions = require('Functions')
local Cards = require('Cards')

player1 = Functions.newPlayer()
print('player 1 name: ')
player1.name = io.read()
print('player 1 name is '..player1.name)
player2 = Functions.newPlayer()
print('player 2 name: ')
player2.name = io.read()
print('player 2 name is '..player2.name)

Deck = {Cards.Clotz,Cards.Clotz,Cards.Clotz,
        Cards.Wuru,Cards.Wuru,Cards.Wuru,
        Cards.Pretu,Cards.Pretu,Cards.Pretu,
        Cards.Preru,Cards.Preru,Cards.Preru,
        Cards.Prezu,Cards.Prezu,Cards.Prezu,
        Cards.Duo,Cards.Duo,
        Cards.Tu,
        Cards.Ru,
        Cards.Zu
    
    }

function setDeck( player )
    tempcard = {}
    for k,v in pairs( Deck ) do
        tempcard = Functions.abstractToConcrete(v,tempcard)
        player.deck[#player.deck+1] = tempcard
        tempcard = {}
    end
    Functions.shuffle( player.deck )
end

function setGame( player , opponent )
    setDeck( player )
    setDeck( opponent )
    i = 0
    while i < 5 do
        Functions.move( player.deck[#player.deck] , player.deck , player.hand ) -- player compra 5
        Functions.move( opponent.deck[#opponent.deck] , opponent.deck , opponent.hand ) -- oponente compra 5
        i = i + 1
    end
    print('GAME IS SET')
end

function upkeep( player , opponent )
    for i = 1 , #player.field do
        player.field[i].activated = false
    end
end

function winCheck( player , opponent )
    if player.points >= 12 and player.points > opponent.points then
        print(player.name..' WON!')
        return true
    end
end

function selectionStep( player , opponent )
    print('PLAYER '..player.name..' TURN')
    print('SELECTION STEP')
    local selectionZone = {} -- separa zona pra colocar 2 cartas do topo do deck
    Functions.move( player.deck[#player.deck] , player.deck , selectionZone )
    Functions.move( player.deck[#player.deck] , player.deck , selectionZone )
    print('ADD 1 TO YOUR HAND. THE OTHER GOES TO YOUR BIN.')
    picked = Functions.pick( selectionZone )
    Functions.move( picked , selectionZone , player.hand )
    Functions.move( selectionZone[1] , selectionZone , player.bin )
end

function deploymentStep( player , opponent )
    while true do
        print('DEPLOYMENT STEP')
        print('YOUR POINTS: '..player.points)
        print('CARDS IN BIN: '..#player.bin)
        print('0 - GO TO ACTIVATION STEP')
        print('1 - PLAY CARD FROM HAND')
        local opt = tonumber(io.read())
        if not (opt == 1) or #player.hand == 0 then 
            return 
        else
            print('YOUR HAND')
            Functions.playCard( player , Functions.pick( player.hand ) )
        end
    end
end

function activationStep( player , opponent )
    while true do
        print('ACTIVATION STEP')
        print('YOUR POINTS: '..player.points)
        print('CARDS IN BIN: '..#player.bin)
        print('0 - END TURN')
        print('1 - ACTIVATE UNITS')
        local opt = tonumber(io.read())
        if not (opt == 1) or #player.field == 0 then 
            return 
        else
            print('YOUR FIELD')
            local card = Functions.pick( player.field )
            if card.activated == false then
                card.effect( card , player , opponent )
                card.activated = true
            else
                print('THIS UNIT HAS ALREADY BEEN ACTIVATED THIS TURN')
            end
        end
    end
end

function turn(player , opponent)
    upkeep( player , opponent )
    if winCheck( player , opponent ) == true then return true end
    selectionStep( player , opponent )
    deploymentStep( player , opponent )
    activationStep( player , opponent ) 
end

function startGame( player , opponent )
    setGame( player , opponent )
    while true do
        if turn( player , opponent ) == true then 
            return  
        elseif turn( opponent , player ) == true then
            return
        end
    end
end

startGame(player1,player2)
