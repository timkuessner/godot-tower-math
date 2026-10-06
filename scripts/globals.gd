extends Node

enum GameState {
	CREATE_FUNCTIONS,
	PLAYING,
	WON,
	LOST
}

var game_state := GameState.CREATE_FUNCTIONS
