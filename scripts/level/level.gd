class_name Level
extends Node2D

const TOWER_SCENE := preload("res://scenes/towers/tower01.tscn")
const ENEMY_TYPES = [
	preload("res://scenes/enemy/enemy.tscn"),
	preload("res://scenes/enemy/enemy_fast.tscn"),
	preload("res://scenes/enemy/enemy_tank.tscn")
]

# Gegner pro Welle: [normale, schnelle, Tanks]
# Spawnreihenfolge: normale → Tanks → schnelle
const WAVES = [
	[1, 1, 1],
	[8, 3, 0],
	[8, 2, 1],
	[10, 5, 2],
	[12, 8, 2],
	[10, 10, 4],
	[15, 8, 5],
	[12, 15, 6],
	[18, 12, 8],
	[20, 18, 8],
	[22, 20, 10],
	[25, 25, 12],
]


@export var level_number: int = 1
@onready var path: Path2D = $enemy1_spawn/Path2D

var tower_container: Node2D
var enemy_container: Node2D
var projectile_container: Node2D

func _ready() -> void:
	create_runtime_containers()

	$enemy1_spawn/EnemySpawner.stop()
	$enemy1_spawn/SpawnTimer.stop()

	start_waves()
	
	Globals.game_state = Globals.GameState.PLAYING
	Globals.money = 20000
	Globals.maxHP = 20
	Globals.hp = Globals.maxHP
	
	add_child(towerGhost)
	
	$GoalArea.area_entered.connect(
		_on_goal_area_entered
	)

func create_runtime_containers() -> void:
	tower_container = create_container("TowerContainer")
	enemy_container = create_container("EnemyContainer")
	projectile_container = create_container("ProjectileContainer")
	tower_container.y_sort_enabled = true


func create_container(container_name: String) -> Node2D:
	var container := Node2D.new()
	container.name = container_name
	add_child(container)
	return container


func spawn_tower(position: Vector2, type: int) -> Tower:	
	var tower: Tower = TOWER_SCENE.instantiate()
	
	tower.position = position
	
	tower_container.add_child(tower)
	
	tower.tower_clicked.connect(onRealTowerSelected)
	
	tower.setType(type)
	
	return tower

func onRealTowerSelected(tower: Tower):
	print("test")
	gameUI.loadTowerManager(tower)

func spawn_enemy(type: int = 0) -> void:
	if Globals.game_state != Globals.GameState.PLAYING: # Keine genger wenn game verloren
		return
	var enemy: Enemy = ENEMY_TYPES[type].instantiate()
	path.add_child(enemy)


func spawn_group(number: int,interval: float,type: int = 0) -> void:
	for i in range(number):
		spawn_enemy(type)
		await wait(interval)

func wait(seconds: float) -> void:
	var timer := Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start(seconds)
	await timer.timeout
	timer.queue_free()

func start_waves() -> void:
	# Acht Sekunden Vorbereitung vor der ersten Welle.
	await wait(8) #Das habe ich gelassen, würde ich aber entfernen
	for wave_index in range(WAVES.size()):
		if Globals.game_state != Globals.GameState.PLAYING:
			return

		print("Welle ", wave_index + 1, " / ", WAVES.size())

		var counts: Array = WAVES[wave_index]
		var spawn_order: Array[int] = []

		#  normale = 0,  Tanks = 2, schnelle = 1.
		for type in [0, 2, 1]:
			for i in range(counts[type]):
				spawn_order.append(type)

		# Spätere Wellen = kürzere Spawnabstände.
		var interval: float = maxf(0.3,1.0 - wave_index * 0.06)

		# Gegner in der festgelegten Reihenfolge erzeugen.
		for type in spawn_order:
			if Globals.game_state != Globals.GameState.PLAYING:
				return

			spawn_enemy(type)
			await wait(interval)

		# Warten, bis alle Gegner dieser Welle weg sind.
		while path.get_child_count() > 0:
			if Globals.game_state != Globals.GameState.PLAYING:
				return

			await wait(0.25)

		if Globals.game_state != Globals.GameState.PLAYING:
			return

		# Baupause vor der nächsten Welle.
		if wave_index < WAVES.size() - 1:
			print("Welle geschafft! Acht Sekunden Baupause.")
			await wait(8)

	Globals.game_state = Globals.GameState.WON
	print("SIEG! Alle Wellen geschafft!")

@onready var gameUI: GameUI = $CanvasLayer/GameUI

var towers: Array = []

func start_playing() -> void:
	Globals.game_state = Globals.GameState.PLAYING
	
#HP Bar_player
func _on_goal_area_entered(area: Area2D) -> void:
	if !area.get_parent() is Enemy:
		return
	var enemy: Enemy = area.get_parent()
	if enemy.is_queued_for_deletion():
		return
	Globals.hp = maxi(Globals.hp - enemy.hp/5, 0)
	# Angekommenen Enemy entfernen
	enemy.queue_free()

# -1: nichts gewählt; positive oder nullwerte: towertyp gewählt
var selected: int = -1

var towerGhost: TowerGhost = load("res://scenes/towers/TowerGhost.tscn").instantiate()

func onTowerButtonSelected(index: int) -> void:
	if selected!=index :
		selected = index
	else:
		selected = -1
	towerGhost.setType(selected)

func _process(delta: float) -> void:
	var show := (selected != -1 and get_viewport().gui_get_hovered_control() == null)
	towerGhost.visible = show
	if show:
		towerGhost.global_position = get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if !towerGhost.visible or !Globals.game_state==Globals.GameState.PLAYING:
		return
	if not (event is InputEventMouseButton and event.pressed):
		return
	if event.button_index == MOUSE_BUTTON_LEFT and towerGhost.isValid:
		spawn_tower(to_local(towerGhost.global_position), selected)
		selected = -1
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		selected = -1
	get_viewport().set_input_as_handled()
