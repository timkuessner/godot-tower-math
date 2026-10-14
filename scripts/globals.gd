extends Node

enum GameState {
	PLAYING,
	WON,
	LOST
}

var game_state := GameState.PLAYING

var towers: Array = []
func _ready() -> void:
	var file := FileAccess.open("res://assets/towerSettings.json", FileAccess.READ)
	towers = JSON.parse_string(file.get_as_text())


signal money_changed(value: int)
signal hpChanged(value: int)
signal maxHPChanged(value: int)

var money := 100:
	set(value):
		money = value
		money_changed.emit(money)

var maxHP := 100:
	set(value):
		maxHP = value
		maxHPChanged.emit(maxHP)

var hp := 100:
	set(value):
		hp = max(value, 0)
		hpChanged.emit(hp)
		if hp == 0:
			game_state = GameState.LOST
