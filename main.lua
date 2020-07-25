math.randomseed(os.time())
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
        Cards.Wuruku,Cards.Wuruku,
        Cards.Bonky,Cards.Bonky,
        Cards.Duo,Cards.Duo,
        Cards.Raskus,Cards.Raskus,
        Cards.Sarka,Cards.Sarka,
        Cards.Sobmos,
        Cards.Tzitunk,
        Cards.Tu,
        Cards.Ru,
        Cards.Zu
    }

function setDeck( player )
    for i = 1 , #Deck do
        local card = Deck[i]
        setmetatable( card , Cards.cardIdeal )
        local newCard = card:new()
        newCard.owner = player
        player.deck[#player.deck+1] = newCard
    end
    Functions.shuffle( player.deck )
end

function setGame( player , opponent )
    setmetatable( Cards.Token , Cards.cardIdeal )
    setDeck( player )
    setDeck( opponent )
    player:drawCards( 4 )
    opponent:drawCards( 4 )
end

function upkeep( player )
    function clean(zone)
        for i = 1 , #zone do
            zone[i].activated = false
        end
    end
    clean(player.field)
    clean(player.hand)
    clean(player.bin)
    clean(player.deck)
    clean(player.erased)
end

function winCheck( player )
    if player.score >= 12 and player.score > opponent.points then
        print(player.name..' WON!')
        return true
    end
end

function selectionStep( player )
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
        Functions.printBoard( player , opponent )
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
        Functions.printBoard( player , opponent )
        print('0 - END TURN')
        print('1 - ACTIVATE UNITS')
        local opt = tonumber(io.read())
        if not (opt == 1) or #player.field == 0 then 
            return 
        else
            print('YOUR FIELD')
            local card = Functions.pick( player.field )
            if card.activated == false then
                if card.effect( card , player , opponent ) == true then
                    card.activated = true
                else
                    print('UNIT FAILED TO ACTIVATE')
                end
            else
                print('THIS UNIT HAS ALREADY BEEN ACTIVATED THIS TURN')
            end
        end
    end
end

function turn(player , opponent)
    upkeep( player )
    if winCheck( player ) == true then return true end
    selectionStep( player )
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
