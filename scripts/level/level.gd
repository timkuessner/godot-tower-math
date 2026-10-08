class_name Level
extends Node2D

signal tower_selected(tower: Tower)

const TOWER_SCENE := preload("res://scenes/towers/tower01.tscn")
const ENEMY_SCENE = preload("res://scenes/enemy/enemy.tscn")


@export var level_number: int = 1
@onready var path: Path2D = $enemy1_spawn/Path2D

var tower_container: Node2D
var enemy_container: Node2D
var projectile_container: Node2D

func _ready() -> void:
	create_runtime_containers()
	spawn_tower(Vector2(-100, 50))
	$enemy1_spawn/SpawnTimer.timeout.connect(spawn_enemy)

func create_runtime_containers() -> void:
	tower_container = create_container("TowerContainer")
	enemy_container = create_container("EnemyContainer")
	projectile_container = create_container("ProjectileContainer")


func create_container(container_name: String) -> Node2D:
	var container := Node2D.new()
	container.name = container_name
	add_child(container)
	return container


func spawn_tower(position: Vector2) -> Tower:
	var tower: Tower = TOWER_SCENE.instantiate()
	
	tower.position = position
	
	tower_container.add_child(tower)
	
	tower.tower_clicked.connect(on_tower_selected)
	
	return tower

func on_tower_selected(tower: Tower):
	tower_selected.emit(tower)


func spawn_enemy():
	var enemy = ENEMY_SCENE.instantiate()
	path.add_child(enemy)
