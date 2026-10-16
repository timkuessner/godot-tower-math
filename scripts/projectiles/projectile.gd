class_name Projectile
extends Node2D

@export var speed: float = 300.0
@export var damage: float = 3
@export var maxEnemies: int = 1
@export var slowness: bool = false

var path: PackedVector2Array

func setup(p: PackedVector2Array) -> void:
	path = p
	if path.size() < 2:
		queue_free()
	_process(0)
	Globals.gameStateChanged.connect(onGameStateChanged)

# Beide Variablen zusammen geben die bisherige Bewegung auf dem Pfad eindeutig an
var currentElement: int = 0
var deltaDistance: float= 25 # Das Projektil verlässt das Geschütz versetzt

func _process(delta: float) -> void:
	var distance = speed * delta + deltaDistance
	
	for i in range(currentElement, path.size()-1):
		var segment_length := path[i+1].distance_to(path[i])
		if distance <= segment_length and segment_length > 0:
			position = path[i].lerp(path[i+1], distance / segment_length)
			rotation = (path[i+1]-path[i]).angle()
			deltaDistance = distance
			return
		currentElement += 1
		distance -= segment_length
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_queued_for_deletion():
		return
	var enemy: Enemy = area.get_parent()
	maxEnemies -= int(enemy.handleDamage(damage))
	if slowness: enemy.slowed = true
	if maxEnemies <= 0:
		queue_free()
	
func onGameStateChanged() -> void:
	if Globals.game_state==Globals.GameState.LOST:
		queue_free()
