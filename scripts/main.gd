extends Node

@onready var level_container: Node = $LevelContainer
@onready var tower_editor: Control = $UI/TowerEditor

var current_level: Level
var current_level_number := 1

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
	
	start_function_creation()


func on_tower_selected(tower: Tower) -> void:
	tower_editor.edit_tower(tower)

func start_function_creation() -> void:
	Globals.game_state = Globals.GameState.CREATE_FUNCTIONS


func start_playing() -> void:
	Globals.game_state = Globals.GameState.PLAYING


func win_level() -> void:
	Globals.game_state = Globals.GameState.WON


func lose_level() -> void:
	Globals.game_state = Globals.GameState.LOST


func restart_level() -> void:
	load_level(current_level_number)


func next_level() -> void:
	current_level_number += 1
	load_level(current_level_number)
