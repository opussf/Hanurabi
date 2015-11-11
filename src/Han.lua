#!/usr/bin/env lua

-- over-ride or define stubs for functions

-- Define those from the WoW API
function GetAddOnMetadata( )
	return "@VERSION@"
end
SlashCmdList = {}

-- import the addon file
require "Hanurabi"

-- over-ride some functions.
function HANURABI.print( msg )
	print( msg )
end
random = math.random

function newState99()
	HANURABI.state99()
	running = false
end

HANURABI.states[99] = newState99

-- Start the game
HANURABI.command()
running = true
while running do
	io.write("> ")
	val = io.read("*n")
	HANURABI.command( val )
end
