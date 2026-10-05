extends Node

enum GameState {
	CREATE_FUNCTIONS,
	PLAYING,
	WON,
	LOST
}

@onready var level_container: Node = $LevelContainer
@onready var tower_editor: Control = $UI/TowerEditor

var current_level: Level
var current_level_number := 1
var game_state := GameState.CREATE_FUNCTIONS

func _ready() -> void:
	start_game()

func start_game() -> void:
	load_level(current_level_number)


func load_level(level_number: int) -> void:
	if current_level:
		current_level.queue_free()
	
	var level_scene := load(
		"res://scenes/levels/level%02d.tscn" % level_number
	)
	
	current_level = level_scene.instantiate()
	level_container.add_child(current_level)
	
	current_level.tower_selected.connect(on_tower_selected)

func on_tower_selected(tower: Tower) -> void:
	tower_editor.edit_tower(tower)

func start_function_creation() -> void:
	game_state = GameState.CREATE_FUNCTIONS


func start_playing() -> void:
	game_state = GameState.PLAYING


func win_level() -> void:
	game_state = GameState.WON


func lose_level() -> void:
	game_state = GameState.LOST


func restart_level() -> void:
	load_level(current_level_number)


func next_level() -> void:
	current_level_number += 1
	load_level(current_level_number)
