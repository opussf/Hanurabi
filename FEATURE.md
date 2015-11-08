# Feature

This file tracks features per branch.

## State based design

The original prompt based BASIC games can be seen as state machines.
The user cycles through pre-defined states of being prompted for data.

To convert this design to be a sub game in something like Wow, the idea of states will be exagerated.
Using the command "/hab <input>" will let the user interact or change states.
The command alone will restate the current state, and prompt the user for the current state's input.
Providing valid input will progress the game to the next state.

A special state will be created that will exist between the start and end of a game.
This state will progress to the next state with an empty "/hab" command.

In the original, a negative (<0) input value resulted in termination of the game.
If this is desired to be kept, it would reset the game to the special state between end and start.

## Saved variables
I'm not sure I want to save variables between sessions or not.
