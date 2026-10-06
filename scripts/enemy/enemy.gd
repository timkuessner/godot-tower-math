extends PathFollow2D

@export var speed: float = 100.0

func _process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio >= 1: #End of the path
		queue_free() #Kill
	
