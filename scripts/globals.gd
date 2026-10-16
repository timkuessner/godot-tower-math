extends Node

var towers: Array = []

func _ready() -> void:
	var file := FileAccess.open("res://assets/towerSettings.json", FileAccess.READ)
	towers = JSON.parse_string(file.get_as_text())
