extends Node

@onready var level_container: Node = $LevelContainer
@onready var gameUI: GameUI = $UI/GameUI

var current_level: Level
var current_level_number := 1

var towers: Array = []

func _ready() -> void:
	Globals.money = 2000
	Globals.maxHP = 10
	start_game()
	ghostTower.visible = false
	current_level.add_child(ghostTower)

	
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

	Globals.hp = Globals.maxHP

func on_tower_selected(tower: Tower) -> void:
	gameUI.loadTowerManager(tower)

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

	Globals.hp = maxi(Globals.hp - enemy.hp/5, 0)

	# Angekommenen Enemy entfernen
	enemy.queue_free()

	if Globals.hp == 0:
		lose_level()

# -1: nichts gewählt; -2 tower gewählt; positive oder nullwerte: towertyp gewählt
var selected: int = -1

var ghostTower: Node2D = load("res://scenes/towers/TowerGhost.tscn").instantiate()

func onTowerSelected(index: int) -> void:
	if selected!=index :
		selected = index
	else:
		selected = -1
	ghostTower.setType(selected)

func _process(delta: float) -> void:
	var show := (selected != -1 and get_viewport().gui_get_hovered_control() == null)
	ghostTower.visible = show
	if show:
		ghostTower.global_position = current_level.get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if not ghostTower.visible:
		return
	if not (event is InputEventMouseButton and event.pressed):
		return
	if event.button_index == MOUSE_BUTTON_LEFT and ghostTower.isValid:
		current_level.spawn_tower(current_level.to_local(ghostTower.global_position), selected)
		selected = -1
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		selected = -1
	get_viewport().set_input_as_handled()
