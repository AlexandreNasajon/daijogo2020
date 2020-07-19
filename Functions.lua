Functions = {}

-- These functions are needed for Cards.lua

Functions.find = function( where ,what )
    for k,v in pairs(where) do
        if v == what then
        return k
        end
    end
end

Functions.shuffle = function(a)
	local c = #a
	for i = 1, c do
		local ndx0 = math.random( 1, c )
		a[ ndx0 ], a[ i ] = a[ i ], a[ ndx0 ]
	end
	return a
end

--[[
    The most important function
]]
Functions.move = function( what , origin , destiny )
    destiny[#destiny+1] = what
    local j = Functions.find( origin , what)
    if j then
        while j <= #origin do
            origin[j] = origin[j+1]
            j = j+1
        end
    else print('J É NIL') -- debugger
    end
end

Functions.drawCards = function( player , n )
    if #player.deck > 0 then
        if n > #player.deck then
            n = #player.deck
        end
        for i = 1 , n do
            Functions.move( player.deck[#player.deck] , player.deck , player.hand )
        end
        print(player.name..' drew '..n..' cards.')
    else
        print('THE DECK IS EMPTY')
    end
end

Functions.printZone = function( zone )
    local i = 1
    print("#","Name","Points","Has been activated")
    while i <= #zone do
        print(i,zone[i].name,zone[i].points,zone[i].activated)
        i = i+1
    end
end

Functions.printCard = function( card )
    print('Name: '..card.name)
    print('Points: '..card.points)
    print('Cost: '..card.costText)
    print('Effect: '..card.effectText)
end

--[[
    Shows a table (where) and returns the selected element
]]
Functions.pick = function( where )
    while true do
        Functions.printZone( where)
        print('Pick one:')
        local opt = tonumber(io.read())
        if opt ~= nil then
            if opt > 0 and opt <= #where then
                return where[opt]
            end
        end
    end
end

Functions.newPlayer = function()
    player = {
        name = '',
        points = 0,
        deck = {},
        hand = {},
        field = {},
        bin = {},
        erased = {},
        tokenBin = {}
    }
    return player
end

--[[ Creates a unit token on the player's field,
    since they dont have effects, they cant be activated
]]
Functions.newToken = function( player )
    local token = {
        name = 'Token',
        originalPoints = 1,
        points = 1,
        activated = false,
        costText = '',
        effectText = '',
        cost = function( player )
            return true
        end,
        effect = function( card , player , opponent )
            return false
        end
    }
    player.field[#player.field + 1] = token
    print(player.name..' created a 1 point unit token.')
end

--[[ Certain effects will ask the player to destroy tokens in order to activate
    They will count the number of tokens and then ask the player how many they wish to destroy
]]
Functions.countTokens = function( player )
    n = 0
    for i = 1 , #player.field do
        if player.field[i].name == 'Token' then
            n = n + 1
        end
    end
    return n
end

--[[ When cards move from the field to any other zone, they must be reset,
    unless the card moves from one field to another, that is.
    It's important to reset the card in this situation so as
    to mimic the physical card game, where counters cant be moved outside of the field.
]]
Functions.resetCard = function( card )
    card.points = card.originalPoints
    card.activated = false
end

--[[
    When a unit's points become 0, it is destroyed (sent to the bin)
    Since tokens dont go to the regular bin and should be completely eliminated,
    the player.tokenBin serves as an easy way to get rid of them
]]
Functions.checkDeath = function( card , player )
    if card.points < 1 then
        if card.name == 'Token' then
            Functions.move( card , player.field , player.tokenBin)
        else
            Functions.resetCard( card )
            Functions.move( card , player.field , player.bin )
        end
        print(card.name..' was destroyed.')
    end
end

--[[
    Some effects require the player to move many cards from a zone to another
    moveMany shows all cards from the origin zone for the player to pick, one by one,
    and moves them all to the destiny zone
]]
Functions.moveMany = function( n , origin , destiny )
    if #origin >= n then
        while n > 0 do
            print('Select '..n..' card(s):')
            Functions.move( Functions.pick( origin ) , origin , destiny )
            n = n - 1
        end
        return true
    end
end

--[[
    Updates the player's score,
    they must become 0 before the counting so as to not accumulate from earlier turns
]]
Functions.updatePoints = function( player )
    player.points = 0
    for i = 1 , #player.field do
        player.points = player.points + player.field[i].points
    end
end

Functions.playCard = function( player , card )
    Functions.printCard( card )
    print('PLAY CARD?')
    print('0 - RETURN')
    print('1 - PLAY')
    local opt = tonumber(io.read())
    if not (opt == 1) then 
        return 
    else
        if card.cost( player ) == true then
            Functions.move( card , player.hand , player.field )
            Functions.updatePoints( player )
            print(player.name..' PLAYED '..card.name)
            return
        else
            print('YOU CANNOT PAY THE COST')
        end
    end
end

--[[
    Very important
    Cards exist as abstract objects and must be copied into a table (b) before being put into a deck
    Without this step, all instances of a card in the game would be considered the same entity,
    that is, a change in one of them would change all others as well
]]
Functions.abstractToConcrete = function(card,b)
    for k,v in pairs(card) do
        b[k] = v
    end
    return b
end

return Functions
