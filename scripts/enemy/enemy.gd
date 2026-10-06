extends PathFollow2D

@export var speed: float = 100.0
@export var hp: int = 10

@onready var hp_bar: ProgressBar = $Hp_bar

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	connect_signal()
	
	
	hp_bar.max_value = hp
	hp_bar.value = hp_bar.max_value
	
func connect_signal() -> void:
	$Area2D.connect("body_entered", decrease_life_points)
	texture_progress_bar.connect("value_changed", healhthbar_change)
	
func _process(delta: float) -> void:
	progress += delta * speed
	
	# Hp Bar
	hp_bar.rotation = -global_rotation
	hp_bar.global_position = global_position + Vector2(-20, -30)
	
	if progress_ratio >= 1: #End of the path
		queue_free() #Kill
		
func healhthbar_change(value: float) -> void:
	if value == 0:
		queue_free()

func decrease_life_points(amount: int) -> void:
	hp -= amount
	texture_progress_bar.value -= amount
	if hp <= 0:
		queue_free()
