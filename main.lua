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

Deck = {Cards.Clotz.new(),Cards.Clotz.new(),Cards.Clotz.new(),
        Cards.Wuru.new(),Cards.Wuru.new(),Cards.Wuru.new(),
        Cards.Pretu.new(),Cards.Pretu.new(),Cards.Pretu.new(),
        Cards.Preru.new(),Cards.Preru.new(),Cards.Preru.new(),
        Cards.Prezu.new(),Cards.Prezu.new(),Cards.Prezu.new(),
        Cards.Wuruku.new(),Cards.Wuruku.new(),
        Cards.Bonky.new(),Cards.Bonky.new(),
        Cards.Duo.new(),Cards.Duo.new(),
        Cards.Raskus.new(),Cards.Raskus.new(),
        Cards.Sarka.new(),Cards.Sarka.new(),
        Cards.Sobmos.new(),
        Cards.Tzitunk.new(),
        Cards.Tu.new(),
        Cards.Ru.new(),
        Cards.Zu.new()
    }

function setDeck( player )
    for i = 1 , #Deck do
        player.deck[#player.deck+1] = Deck[i]
    end
    Functions.shuffle( player.deck )
end

function setGame( player , opponent )
    setDeck( player )
    setDeck( opponent )
    player:drawCards( 4 )
    opponent:drawCards( 4 )
end

function upkeep( player )
    for i = 1 , #player.field do
        player.field[i].activated = false
    end
end

function winCheck( player )
    if player.points >= 12 and player.points > opponent.points then
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
