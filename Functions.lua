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
    local j = Functions.find( origin , what )
    if j then
        while j <= #origin do
            origin[j] = origin[j+1]
            j = j+1
        end
    else print('J is NIL') -- debugger
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

function printField(player)
    local s = 'Field: '
    if #player.field > 0 then
        for i = 1 , #player.field do 
            s = s..player.field[i].name..'/'..player.field[i].points..' '
        end 
    end
    print(s)
end

Functions.printBoard = function( player , opponent )
    print('Opponent: '..opponent.name,'Score: '..opponent.score,'Cards in hand: '..#opponent.hand,'Cards in bin: '..#opponent.bin)
    printField(opponent)
    print('-------------------------------------------------------------------------------------')
    printField(player)
    print('Player: '..player.name,'Score: '..player.score,'Cards in hand: '..#player.hand,'Cards in bin: '..#player.bin)
end

--[[
    Shows a table (where) and returns the selected element
]]
Functions.pick = function( where )
    while true do
        Functions.printZone( where)
        print('Pick one:')
        local opt = tonumber(io.read())
        if opt and opt > 0 and opt <= #where then
            return where[opt]
        end
    end
end

Functions.newPlayer = function()
    Player = {
    name = '',
    score = 0,
    deck = {},
    hand = {},
    field = {},
    bin = {},
    erased = {},
    tokenBin = {},
    drawCards = function( player , n )
        if #player.deck > 0 then
            if n > #player.deck then
                n = #player.deck
            end
            for i = 1 , n do
                local card = player.deck[#player.deck]
                card:move( player.deck , player.hand )
            end
            print(player.name..' drew '..n..' cards.')
        else
            print('THE DECK IS EMPTY')
        end
    end,
    updatePoints = function( player )
        player.score = 0
        for i = 1 , #player.field do
            player.score = player.score + player.field[i].points
        end
    end    
    }
    return Player
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


--[[
    Some effects require the player to move many cards from a zone to another
    moveMany shows all cards from the origin zone for the player to pick, one by one,
    and moves them all to the destiny zone
]]
Functions.moveMany = function( n , origin , destiny )
    if #origin >= n then
        while n > 0 do
            print('Select '..n..' card(s):')
            local card = Functions.pick( origin )
            card:move( origin , destiny )
            n = n - 1
        end
        return true
    end
end

Functions.playCard = function( player , card )
    card:printCard()
    print('PLAY CARD?')
    print('0 - RETURN')
    print('1 - PLAY')
    local opt = tonumber(io.read())
    if not (opt == 1) then 
        return 
    else
        if card.cost( player ) == true then
            card:move( player.hand , player.field )
            player:updatePoints()
            print(player.name..' PLAYED '..card.name)
            return
        else
            print('YOU CANNOT PAY THE COST')
        end
    end
end

return Functions
