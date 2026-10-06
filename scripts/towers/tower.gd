class_name Tower
extends Node2D

signal tower_clicked(tower: Tower)

@export var function_size: float = 100.0
@export var function_speed: float = 10.0
@export var enemies_per_function: int = 1

@export var projectile_scene: PackedScene

#var projectile: Projectile

var function: Function = Function.new()

var projectile_path: PackedVector2Array

var function_text: String = "":
	set(value):
		function_text = value
		function.set_text(value)
		queue_redraw()

func _draw() -> void:
	if Globals.game_state != Globals.GameState.CREATE_FUNCTIONS:
		return
	
	if function == null:
		return
	
	var projectile_path = function.create_path(function_size)
	
	if projectile_path.size() >= 2:
		draw_polyline(projectile_path, Color.WHITE, 2, true)


func shoot() -> void:
	pass


func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tower_clicked.emit(self)
