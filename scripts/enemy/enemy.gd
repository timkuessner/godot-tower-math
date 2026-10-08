extends PathFollow2D

@export var speed: float = 100.0
@export var hp: int = 10

@onready var hp_bar: ProgressBar = $Hp_bar
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar


func _ready() -> void:
	loop = false

	hp_bar.max_value = hp
	hp_bar.value = hp

	texture_progress_bar.max_value = hp
	texture_progress_bar.value = hp

	$Area2D.area_entered.connect(_on_projectile_entered)


func _process(delta: float) -> void:
	progress += delta * speed

	# HP-Leiste waagerecht über dem Enemy halten
	hp_bar.rotation = -global_rotation
	hp_bar.global_position = global_position + Vector2(-20, -30)

	if progress_ratio >= 1.0:
		queue_free()


func _on_projectile_entered(area: Area2D) -> void:
	# Dein Aufbau: Projektil → Sprite2D → Area2D
	var projectile = area.get_parent().get_parent()

	if projectile is Projectile:
		if projectile.is_queued_for_deletion():
			return

		decrease_life_points(3)
		projectile.queue_free()	


func decrease_life_points(amount: int) -> void:
	hp = maxi(hp - amount, 0)	

	hp_bar.value = hp
	texture_progress_bar.value = hp

	if hp <= 0:
		queue_free()
