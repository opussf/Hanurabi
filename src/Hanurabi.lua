HANURABI_MSG_VERSION = GetAddOnMetadata("Hanurabi" ,"Version");

HANURABI = {}
HANURABI.currentState = 0


function HANURABI.print( msg )
	-- print to the chat frame
	DEFAULT_CHAT_FRAME:AddMessage( msg )
end

function HANURABI.state0()
	-- Init and start the game
	HANURABI.population = 95
	HANURABI.imigrated = 5
	HANURABI.starved = 0
	HANURABI.acres = 1000
	HANURABI.harvestRate = 3
	HANURABI.bushelsHarvested = 3000
	HANURABI.bushelsStored = 2800
	HANURABI.year = 0
	HANURABI.P1 = 0
	HANURABI.deadTotal = 0
	HANURABI.eatenByRats = HANURABI.bushelsHarvested - HANURABI.bushelsStored
	HANURABI.plagueChance = 1

	HANURABI.print( "HANURABI v"..HANURABI_MSG_VERSION )
	HANURABI.print( "Original from Creative Computing   Morristown, New Jersey" )
	HANURABI.print( "Try your hand at governing ancient Sumeria" )
	HANURABI.print( "for a ten-year term of office." )
	return 1
end
function HANURABI.state1()
	-- Initial info
	HANURABI.print( "Hanurabi, I beg to report to you," )
	HANURABI.year = HANURABI.year + 1
	HANURABI.print( "In year "..HANURABI.year..", "..HANURABI.starved.." people starved, "..HANURABI.imigrated.." came to the city," )
	HANURABI.population = HANURABI.population + HANURABI.imigrated
	if HANURABI.plagueChance <= 0 then
		HANURABI.population = math.floor(HANURABI.population / 2)
		HANURABI.print( "A horrible plague struck! Half the people died." )
	end
	HANURABI.print( "Population is now "..HANURABI.population )
	HANURABI.print( "The city now owns "..HANURABI.acres.." acres." )
	HANURABI.print( "You harvested "..HANURABI.harvestRate.." bushels per acre." )
	HANURABI.print( "Rats ate "..HANURABI.eatenByRats.." bushels." )
	HANURABI.print( "You now have "..HANURABI.bushelsStored.." bushels in store." )
	if HANURABI.year == 11 then
		return 7
	end
	HANURABI.bushelsPerAcre = random(0,10) + 17
	return 2
end
function HANURABI.notEnoughBushels()
	HANURABI.print( "Hanurabi, think again.  You have only" )
	HANURABI.print( HANURABI.bushelsStored.." bushels of gain.  Now then," )
end
function HANURABI.state2( acresToBuy )
	-- Buy Land
	if acresToBuy then
		-- print( "You want to buy "..acresToBuy.." acres" )
		if acresToBuy < 0 then
			return 85
		elseif acresToBuy == 0 then
			return 3
		else
			local bushelsToSpend = acresToBuy * HANURABI.bushelsPerAcre
			if bushelsToSpend < HANURABI.bushelsStored then  -- Spend bushels to buy land
				HANURABI.acres = HANURABI.acres + acresToBuy
				HANURABI.bushelsStored = HANURABI.bushelsStored - bushelsToSpend
				return 4
			else
				HANURABI.notEnoughBushels()
			end
		end
	end
	HANURABI.print( "Land is trading at "..HANURABI.bushelsPerAcre.." bushels per acre." )
	HANURABI.print( "How many acres do you wish to buy" )
end
function HANURABI.notEnoughAcres()
	HANURABI.print( "Hanurabi, think again.  You own only "..HANURABI.acres.." acres. Now then" )
end
function HANURABI.state3( acresToSell )
	-- Sell land
	if acresToSell then
		-- print( "You want to sell "..acresToSell.." acres" )
		if acresToSell < 0 then
			return 85
		else
			if acresToSell < HANURABI.acres then -- Can never sell the last acre?
				HANURABI.acres = HANURABI.acres - acresToSell
				HANURABI.bushelsStored = HANURABI.bushelsStored + acresToSell * HANURABI.bushelsPerAcre
				return 4
			else
				HANURABI.notEnoughAcres()
			end
		end
	end
	HANURABI.print( "Land is trading at "..HANURABI.bushelsPerAcre.." bushels per acre." )
	HANURABI.print( "How many acres do you wish to sell" )
end
function HANURABI.state4( bushelsToFeed )
	-- Feed the people
	HANURABI.bushelsToFeed = nil  -- clear this variable
	if bushelsToFeed then
		-- print( "You want to feed "..bushelsToFeed.." bushels" )
		if bushelsToFeed < 0 then
			return  85
		else
			if bushelsToFeed <= HANURABI.bushelsStored then
				HANURABI.bushelsToFeed = bushelsToFeed
				HANURABI.bushelsStored = HANURABI.bushelsStored - HANURABI.bushelsToFeed
				return 5
			else
				HANURABI.notEnoughBushels()
			end
		end
	end
	HANURABI.print( "Population is "..HANURABI.population.." and "..HANURABI.bushelsStored.." bushels are in store." )
	HANURABI.print( "How many bushels do you wish to feed your people" )
end
function HANURABI.notEnoughPopulation()
	HANURABI.print( "But you have only "..HANURABI.population.." people to tend the fields! Now then," )
end
function HANURABI.state5( acresToPlant )
	-- Plant the crops
	HANURABI.acresToPlant = nil -- clear this variable
	if acresToPlant then
		--print( "You want to plant "..acresToPlant.." acres" )
		if acresToPlant < 0 then
			return 85
		else
			if acresToPlant <= HANURABI.acres then
				local bushelsNeededToPlant = math.floor( acresToPlant/2 )
				--print( "You will need "..bushelsNeededToPlant.." bushels.")
				if bushelsNeededToPlant <= HANURABI.bushelsStored then
					if acresToPlant<(10*HANURABI.population) then
						HANURABI.acresToPlant = acresToPlant
						HANURABI.bushelsStored = HANURABI.bushelsStored - bushelsNeededToPlant
						return 6
					else
						HANURABI.notEnoughPopulation()
					end
				else
					HANURABI.notEnoughBushels()
				end
			else
				HANURABI.notEnoughAcres()
			end
		end
	end
	HANURABI.print( "You own "..HANURABI.acres.." acres and "..HANURABI.bushelsStored.." bushels are in store." )
	HANURABI.print( "How many acres do you wish to plant with seed" )
end
function HANURABI.state6()
	-- compute
	-- change the bushels harvested per acre
	HANURABI.harvestRate = random(6) -- 1-6
	HANURABI.bushelsHarvested = HANURABI.acresToPlant * HANURABI.harvestRate
	HANURABI.eatenByRats = 0

	-- Rats? (aprox 50% chance?)
	local c = random(6)
	if math.floor( c/2 ) == c/2 then -- rats are running wild
		HANURABI.eatenByRats = math.floor( HANURABI.bushelsStored/c )
	end

	-- Harvest bushels and remove those eaten by rats
	HANURABI.bushelsStored = HANURABI.bushelsStored - HANURABI.eatenByRats + HANURABI.bushelsHarvested

	-- Have babies
	c = random(6)
	HANURABI.imigrated = math.floor(c * (20 * HANURABI.acres + HANURABI.bushelsStored) / HANURABI.population / 100 + 1 )

	-- How many people had full tummies
	local fullTummies = math.floor(HANURABI.bushelsToFeed / 20)

	-- 15% change of plague
	-- 0 or lower means plague
	HANURABI.plagueChance = math.floor( 10*(random(0,2)-0.3) )

	if HANURABI.population < fullTummies then -- no one starved
		HANURABI.starved = 0
		return 1
	end

	-- starve enough for impeachment?
	HANURABI.starved = HANURABI.population - fullTummies
	if HANURABI.starved > 0.45 * HANURABI.population then
		HANURABI.print( "You starved "..HANURABI.starved.." people in one year!!!" )
		return 56
	end

	-- Calculate percent starved per year
	HANURABI.P1 = ((HANURABI.year-1)*HANURABI.P1 + HANURABI.starved*100/HANURABI.population)/HANURABI.year

	-- Update population to those who were fed
	HANURABI.population = fullTummies
	HANURABI.deadTotal = HANURABI.deadTotal + HANURABI.starved

	return 1 -- go back to state 1
end
function HANURABI.state7()
	-- end of game
	HANURABI.print( "In your 10 year term of office, "..HANURABI.P1.." percent of the" )
	HANURABI.print( "population starved per year on the average, I.E. a total of" )
	HANURABI.print( HANURABI.deadTotal.." people died!!" )
	HANURABI.APP = HANURABI.acres / HANURABI.population
	HANURABI.print( "You started with 10 acres per person and ended with" )
	HANURABI.print( string.format( "%0.2f acres per person.", HANURABI.APP ) )
	if HANURABI.P1 > 33 or HANURABI.APP < 7 then
		return 56  -- FINK!
	elseif HANURABI.P1 > 10 or HANURABI.APP < 9 then
		return 94
	elseif HANURABI.P1 > 3 or HANURABI.APP < 10 then
		return 96
	else
		return 90
	end
	return 99
end
function HANURABI.state56()
	-- starved too many people
	HANURABI.print( "Due to this extreme mismangement you have not only" )
	HANURABI.print( "been impeached and thrown out of office but you have" )
	HANURABI.print( "also been declared national fink!!!!" )
	return 99
end
function HANURABI.state85()
	-- end current game.
	-- returning nil keeps the next state from being called.
	HANURABI.print( "Hanurabi, I cannot do what you wish." )
	HANURABI.print( "Get yourself another steward!!!!!" )
	return 99
end
function HANURABI.state90()
	HANURABI.print( "A fantastic performace!!! Charlemagne, Disraeli, and" )
	HANURABI.print( "Jefferson combined could not have done better." )
	return 99
end
function HANURABI.state94()
	-- Heavy Handed
	HANURABI.print( "Your heavy-handed performace smacks of Nero and Ivan IV." )
	HANURABI.print( "The people (remaining) find you an unpleasent ruler, and," )
	HANURABI.print( "frankly, hate your guts!!" )
	return 99
end
function HANURABI.state96()
	HANURABI.print( "Your performace could have been somewhat better, but" )
	HANURABI.print( string.format("really wasn't too bad at all. %i people", HANURABI.population * 0.8 * random(1) ) )
	HANURABI.print( "dearly like to see you assassinated but we all have our" )
	HANURABI.print( "trivial problems." )
	return 99
end
function HANURABI.state99()
	-- Ended
	HANURABI.print( "So long for now." )
	HANURABI.print( "Use /han to start again" )
	HANURABI.currentState = 0
end

HANURABI.states = {
	[0] = HANURABI.state0,
	[1] = HANURABI.state1,
	[2] = HANURABI.state2,
	[3] = HANURABI.state3,
	[4] = HANURABI.state4,
	[5] = HANURABI.state5,
	[6] = HANURABI.state6,
	[7] = HANURABI.state7,
	[56] = HANURABI.state56,
	[85] = HANURABI.state85,
	[90] = HANURABI.state90,
	[94] = HANURABI.state94,
	[96] = HANURABI.state96,
	[99] = HANURABI.state99,
}

function HANURABI.command( msg )
	val = tonumber( msg )
	if HANURABI.states[HANURABI.currentState] then
		local newState = HANURABI.states[HANURABI.currentState](val)
		if newState and newState ~= HANURABI.currentState then
			HANURABI.currentState = newState
			HANURABI.command()
		end
	else
		print("Nothing defined for state: "..HANURABI.currentState)
	end
end

SLASH_HANURABI1 = "/HAN"
SlashCmdList["HANURABI"] = HANURABI.command

