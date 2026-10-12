class_name Tower
extends Node2D

signal tower_clicked(tower: Tower)

@export var function_length: float = 1000.0
@export var function_speed: float = 10.0
@export var enemies_per_function: int = 1

var type: int = 0


@export var projectile_scene: PackedScene

var projectile: Projectile

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
	
	if !function.is_valid:
		return
	
	projectile_path = function.create_path(function_length, -0.1) # l ist immer positiv, schrittweite kann bei Richtungswechsel negativ sein
	
	if projectile_path.size() >= 2:
		draw_polyline(projectile_path, Color.WHITE, 2, true)


func shoot() -> void:
	projectile = projectile_scene.instantiate()
	
	add_child(projectile)
	
	projectile.setup(projectile_path)
	
func setType(index: int) -> void:
	type = index
	if (index==-1):
		return
	var data: Dictionary = Globals.towers[index]
	var texture: Texture2D = load(data["texture"])
	$ClickArea/Shooter.texture = texture
	function_length = data["range"]
	function_speed = data["projectile_speed"]
	enemies_per_function = data["max_targets"]

func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tower_clicked.emit(self)


func _on_timer_timeout() -> void:
	shoot()
