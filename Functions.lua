Functions = {}

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

Functions.printZone = function( zone )
    local i = 1
    print("#","Name           ","Points") --name tem 15 caracteres
    while i <= #zone do
        print(i,zone[i].name,zone[i].points)
        i = i+1
    end
end

Functions.printCard = function( card )
    print('Name: '..card.name)
    print('Points: '..card.points)
    print('Cost: '..card.costText)
    print('Effect: '..card.effectText)
end

Functions.pick = function( where ) -- escolhe um elemento de uma tabela
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
        erased = {}
    }
    return player
end

Functions.erase_n_from_bin = function( player , n )
    if #player.bin >= n then
        while n > 0 do
            print('Erase '..n..' card(s) from your bin:')
            Functions.move( Functions.pick( player.bin ) , player.bin , player.erased )
            n = n - 1
            return true
        end
    end
end

Functions.updatePoints = function( player ) -- calcula os pontos do player
    player.points = 0 -- reseta pra não acumular a cada update
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

Functions.abstractToConcrete = function(card,b) -- cria uma instância concreta da carta abstrata
    for k,v in pairs(card) do
        b[k] = v
    end
    return b
end

return Functions
