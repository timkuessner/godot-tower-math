class_name Projectile
extends Node2D

@export var speed: float = 300.0

var path: PackedVector2Array
var distance: float = 0.0
var length: float = 0.0


func setup(p: PackedVector2Array, l: float) -> void:
	path = p
	length = l
	distance = 0.0


func _process(delta: float) -> void:
	print(path.size())
	if path.size() < 2:
		return
	
	distance += speed * delta
	
	if distance >= length:
		queue_free()
		return
	
	var remaining_distance := distance
	
	for i in range(1, path.size()):
		var segment_length := path[i - 1].distance_to(path[i])
		
		if remaining_distance <= segment_length:
			var t := remaining_distance / segment_length
			position = path[i - 1].lerp(path[i], t)
			return
		
		remaining_distance -= segment_length
