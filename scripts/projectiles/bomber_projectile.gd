class_name BomberProjectile
extends Projectile

@onready var zone1: Area2D = $Zone1
@onready var zone2: Area2D = $Zone2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)


func _on_area_2d_area_entered(area: Area2D) -> void:
	super(area) # >> gesamt Schaden: 7/4
	for a in zone1.get_overlapping_areas():
		var enemy: Enemy = a.get_parent()
		enemy.handleDamage(damage/2) # >> gesamt Schaden: 3/4
	for a in zone2.get_overlapping_areas():
		var enemy: Enemy = a.get_parent()
		enemy.handleDamage(damage/4) # >> gesamt Schaden: 1/4
	queue_free()
