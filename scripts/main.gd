extends Node

@onready var level_container: Node = $LevelContainer
@onready var tower_editor: Control = $UI/TowerEditor

var current_level: Level
var current_level_number := 1

var base_hp: int
@export var base_max_hp: int = 10
@export var enemy_base_damage: int = 1
@onready var base_hp_bar: Range = $Base_hp_bar





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
	
	current_level.get_node("GoalArea").area_entered.connect(
		_on_goal_area_entered
	)

	base_hp = base_max_hp
	base_hp_bar.min_value = 0
	base_hp_bar.max_value = base_max_hp
	base_hp_bar.value = base_hp
	
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
	# Spawner stoppen
	current_level.get_node("enemy1_spawn/SpawnTimer").stop()

	# Alle vorhandenen Gegner entfernen
	get_tree().call_group("enemies", "queue_free")


func restart_level() -> void:
	load_level(current_level_number)


func next_level() -> void:
	current_level_number += 1
	load_level(current_level_number)
	
	
	
	
#HP Bar_player
func _on_goal_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()

	if not enemy.is_in_group("enemies"):
		return

	if enemy.is_queued_for_deletion():
		return

	base_hp = maxi(base_hp - enemy.hp, 0)
	base_hp_bar.value = base_hp

	# Angekommenen Enemy entfernen
	enemy.queue_free()

	if base_hp == 0:
		lose_level()
  
