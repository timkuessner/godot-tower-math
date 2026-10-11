extends Node2D

var isValid := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if !visible:
		return
	isValid = !$Area2D.has_overlapping_areas()
	if isValid:
		$".".modulate = Color(0.5, 1, 0.5)
	else:
		$".".modulate = Color(1, 0.5, 0.5)
		
