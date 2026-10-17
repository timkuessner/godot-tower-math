class_name Enemy
extends PathFollow2D

@export var speed: float = 60.0
@export var hp: float = 20
@export var value: int = 10

@onready var hp_bar: ProgressBar = $Hp_bar
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var slowTimner: Timer = $SlowTimer
var slowed: bool = false:
	set(value):
		slowed = value
		if slowed: slowTimner.start()

func _ready() -> void:
	loop = false
	add_to_group("enemies")
	

	hp_bar.max_value = hp
	hp_bar.value = hp

	texture_progress_bar.max_value = hp
	texture_progress_bar.value = hp

	# $Area2D.area_entered.connect(_on_projectile_entered)


func _process(delta: float) -> void:
	if (Level.c.game_state==Level.c.GameState.WON):
		return
	progress += delta * speed * 0.4 if slowed else delta * speed		

	# HP-Leiste waagerecht über dem Enemy halten
	hp_bar.rotation = -global_rotation
	hp_bar.global_position = global_position + Vector2(-20, -30)

	if progress_ratio >= 1.0:
		queue_free()

func handleDamage(amount: float) -> bool:
	if is_queued_for_deletion():
		return false
	hp = hp - amount if hp > 0. else 0.
	hp_bar.value = hp
	texture_progress_bar.value = hp

	if hp <= 0:
		queue_free()
		Level.c.money += value
	return true

func _on_slow_timer_timeout() -> void:
	slowed = false
