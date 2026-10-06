extends Node2D

const ENEMY_SCENE = preload("res://scenes/enemy/enemy.tscn")

@onready var path: Path2D = $Path2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.timeout.connect(spawn_enemy)
	

func spawn_enemy():
	var enemy = ENEMY_SCENE.instantiate()
	path.add_child(enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
