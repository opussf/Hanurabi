#!/usr/bin/env lua

require "wowTest"

addonData = { ["Version"] = "1.0",
}

test.outFileName = "testOut.xml"

-- Figure out how to parse the XML here, until then....

-- require the file to test
package.path = "../src/?.lua;'" .. package.path
require "Hanurabi"

function test.before()
	HANURABI.currentState = 0
end

function test.after()
end

function test.test_hasVersion()
	assertEquals( "1.0", HANURABI_MSG_VERSION )
end
function test.test_slashCommand()
	-- Has slash command
	assertEquals( SLASH_HANURABI1, "/HAN" )
end

function test.test_started()
	assertEquals( 0, HANURABI.currentState )
end
function test.test_started_hasPopulation()
	HANURABI.currentState = 0
	HANURABI.command()
	assertEquals( 100, HANURABI.population )
end
function test.test_started_hasYear()
	HANURABI.currentState = 0
	HANURABI.command()
	assertEquals( 1, HANURABI.year )
end

function test.test_state0_command()
	-- command is called when '/han' is called
	-- This should print the start, and progress to state 2 (Buy land)
	HANURABI.currentState = 0
	HANURABI.command()
	assertEquals( 2, HANURABI.currentState )
end
function test.test_state1_command()
	-- state 1 is not a stand alone state.  Should probably never be in this state.
	HANURABI.currentState = 1
	HANURABI.command()
	assertEquals( 2, HANURABI.currentState )
end
function test.test_state2_command()
	-- state 2 - Buy land
	HANURABI.currentState = 2
	HANURABI.command()
	assertEquals( 2, HANURABI.currentState )
end
function test.test_state2_negValue()
	-- state 2 - Buy land.  Negative value ends game.
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( -5 )
	assertEquals( 0, HANURABI.currentState )
end
function test.test_state2_zeroValue()
	-- state 2 - Buy land.  Zero value
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 )
	assertEquals( 1000, HANURABI.acres )
	assertEquals( 2800, HANURABI.bushelsStored )
	assertEquals( 3, HANURABI.currentState )
end
function test.test_state2_positiveValue_Valid()
	-- state 2 - Buy land. Valid value
	-- Buying land means that you don't want to sell.
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 100 )
	assertEquals( 1100, HANURABI.acres )
	assertEquals( 2800 - (HANURABI.bushelsPerAcre * 100), HANURABI.bushelsStored )
	assertEquals( 4, HANURABI.currentState )
end
function test.test_state2_positiveValue_Invalid()
	-- state 2 - Buy land. invalid value
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 1000 )
	assertEquals( 1000, HANURABI.acres )
	assertEquals( 2, HANURABI.currentState )
end
function test.test_state3_command()
	-- state 3 - Sell land
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command()
	assertEquals( 3, HANURABI.currentState )
end
function test.test_state3_negValue()
	-- state 3 - Sell land. Neg value ends game
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( -1 )
	assertEquals( 0, HANURABI.currentState )
end
function test.test_state3_zeroValue()
	-- state 3 - Sell land
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 1000, HANURABI.acres )
	assertEquals( 4, HANURABI.currentState )
end
function test.test_state3_positiveValue_Valid()
	-- state 3 - Sell land
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 999 )
	assertEquals( 1, HANURABI.acres )
	assertEquals( 4, HANURABI.currentState )
end
function test.test_state3_positiveValue_Invalid()
	-- state 3 - Sell land
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 1100 )
	assertEquals( 1000, HANURABI.acres )
	assertEquals( 3, HANURABI.currentState )
end
function test.test_state4_command()
	-- state 4 - Feed the people
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command()
	assertIsNil( HANURABI.bushelsToFeed )
	assertEquals( 4, HANURABI.currentState )
end
function test.test_state4_negValue()
	-- state 4 - Feed the people
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( -1 )
	assertEquals( 0, HANURABI.currentState )
end
function test.test_state4_zeroValue()
	-- state 4 - Feed the people
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 0 )
	assertEquals( 0, HANURABI.bushelsToFeed ) -- set the 0 value to be used later
	assertEquals( 2800, HANURABI.bushelsStored ) -- update the bushels currently stored.
	assertEquals( 5, HANURABI.currentState ) -- next state (Plant seeds)
end
function test.test_state4_positiveValue_Valid()
	-- state 4 - Feed the people
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 2000 )
	assertEquals( 2000, HANURABI.bushelsToFeed ) -- set the 0 value to be used later
	assertEquals( 800, HANURABI.bushelsStored ) -- update the bushels currently stored.
	assertEquals( 5, HANURABI.currentState ) -- next state (Plant seeds)
end
function test.test_state4_positiveValue_Invalid()
	-- state 4 - Feed the people
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 3000 )
	assertIsNil( HANURABI.bushelsToFeed ) -- invalid value should keep this as nil
	assertEquals( 2800, HANURABI.bushelsStored ) -- update the bushels currently stored.
	assertEquals( 4, HANURABI.currentState ) -- return to current state
end
function test.test_state5_positiveValue_Command()
	-- state 5 - Plant acres
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 2000 ) -- feed 2000 bushels
	assertEquals( 5, HANURABI.currentState )
	HANURABI.command()
	assertIsNil( HANURABI.acresToPlant )
	assertEquals( 800, HANURABI.bushelsStored )
	assertEquals( 5, HANURABI.currentState )
end
function test.test_state5_positiveValue_negValue()
	-- state 5 - Plant acres
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 2000 ) -- feed 2000 bushels
	assertEquals( 5, HANURABI.currentState )
	HANURABI.command( -1 )
	assertIsNil( HANURABI.acresToPlant )
	assertEquals( 0, HANURABI.currentState )
end
function test.test_state5_positiveValue_zeroValue()
	-- state 5 - Plant acres
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 2000 ) -- feed 2000 bushels
	assertEquals( 5, HANURABI.currentState )
	HANURABI.command( 0 )
	assertEquals( 0, HANURABI.acresToPlant )
	--assertEquals( 800, HANURABI.bushelsStored )
	assertEquals( 2, HANURABI.currentState )
end
function test.test_state5_positiveValue_positiveValue_Valid()
	-- state 5 - Plant acres
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 2000 ) -- feed 2000 bushels
	assertEquals( 5, HANURABI.currentState )
	HANURABI.command( 101 ) -- plant 101 acres
	assertEquals( 101, HANURABI.acresToPlant )
	--assertEquals( 750, HANURABI.bushelsStored )
	--assertEquals( 6, HANURABI.currentState )
end
function test.test_state5_positiveValue_positiveValue_InvalidAcres()
	-- state 5 - Plant acres
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 2000 ) -- feed 2000 bushels
	assertEquals( 5, HANURABI.currentState )
	HANURABI.command( 1100 ) -- plant 1100 acres
	assertIsNil( HANURABI.acresToPlant )
	assertEquals( 800, HANURABI.bushelsStored )
	assertEquals( 5, HANURABI.currentState )
end
function test.test_state5_positiveValue_positiveValue_InvalidBushels()
	-- state 5 - Plant acres
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 2500 ) -- feed 2500 bushels
	assertEquals( 5, HANURABI.currentState )
	HANURABI.command( 1000 ) -- plant 1000 acres
	assertIsNil( HANURABI.acresToPlant )
	assertEquals( 300, HANURABI.bushelsStored )
	assertEquals( 5, HANURABI.currentState )
end
function test.test_state5_positiveValue_positiveValue_NotEnoughPopulation()
	-- state 5 - Plant acres
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 2000 ) -- feed 2000 bushels
	assertEquals( 5, HANURABI.currentState )
	HANURABI.population = 50  -- should only be able to plant 500 acres
	HANURABI.command( 1000 ) -- plant 1000 acres
	assertIsNil( HANURABI.acresToPlant )
	assertEquals( 800, HANURABI.bushelsStored )
	assertEquals( 5, HANURABI.currentState )
end
function test.test_state6_starveSomePeople()
	-- state 6 - calculate
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 1500 ) -- feed 1500 bushels
	assertEquals( 5, HANURABI.currentState )
	HANURABI.command( 100 ) -- plant 100 acres
	assertEquals( 25, HANURABI.P1 )
	assertEquals( 25, HANURABI.deadTotal )
	assertTrue( HANURABI.population > 75 )
	assertEquals( 2, HANURABI.currentState )

end
function test.test_state6_starveTooManyPeople()
	-- state 6 - calculate
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.command( 0 ) -- don't buy land
	assertEquals( 3, HANURABI.currentState )
	HANURABI.command( 0 ) -- don't sell land
	assertEquals( 4, HANURABI.currentState )
	HANURABI.command( 1000 ) -- feed 1000 bushels
	assertEquals( 5, HANURABI.currentState )
	HANURABI.command( 100 ) -- plant 100 acres
	assertEquals( 0, HANURABI.currentState )
end
function test.test_year11_endsGame_fink_percentDead()
	HANURABI.currentState = 0
	HANURABI.command()
	HANURABI.year = 10
	HANURABI.P1 = 34
	HANURABI.deadTotal = 34
	HANURABI.population = 66
	HANURABI.currentState = 1
	HANURABI.command()
	assertEquals( 0, HANURABI.currentState )
end




test.run()