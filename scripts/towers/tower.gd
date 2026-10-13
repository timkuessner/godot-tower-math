class_name Tower
extends Node2D

signal tower_clicked(tower: Tower)

@export var function_length: float = 1000.0
@export var function_speed: float = 10.0
@export var enemies_per_function: int = 1

var rotateTexture

var type: int = 0

@export var projectile_scene: PackedScene

var projectile: Projectile

var previewText: String = "0":
	set(value):
		previewText = value
		previewFunction.set_text(previewText)
		previewPath = drawPath(previewFunction, previewDirection)
		queue_redraw()
var text: String = "0":
	set(value):
		text = value
		previewText = value
		function.set_text(text)
		path = drawPath(function, direction)
		rotateToShoot()
		queue_redraw()

var previewFunction: Function = Function.new()
var function: Function = Function.new()

var previewPath: PackedVector2Array
var path: PackedVector2Array

var direction := true:
	set(value):
		direction = value
		previewDirection = value
		path = drawPath(function, direction)

var previewDirection:= true:
	set(value):
		previewDirection = value
		previewPath = drawPath(previewFunction, previewDirection)
		queue_redraw()

var showPreview: bool = false:
	set(value):
		showPreview = value
		previewText = previewText

var sellPrice: int

func _ready() -> void:
	pass

func _draw() -> void:
	if Globals.game_state != Globals.GameState.CREATE_FUNCTIONS:
		return
	
	if !function.is_valid:
		return
	
	if path.size() >= 2:
		draw_polyline(path, Color.from_rgba8(255,255,255,127), 2, true)
	if !showPreview: return
	if previewPath.size() >= 2:
		draw_polyline(previewPath, Color.WHITE, 2, true)
	


func drawPath(f: Function, d: bool) -> PackedVector2Array:
	var step = 0.001 if d else -0.001
	return function.rescrale(f.create_path(function_length, step), 720./10.)

func shoot() -> void:
	projectile = projectile_scene.instantiate()
	
	add_child(projectile)
	
	projectile.setup(path)

func rotateToShoot() -> void:
	if path.size() >= 2 and rotateTexture:
		$Sprite2D.rotation = (path[1] - path[0]).angle()
	
func setType(index: int) -> void:
	type = index
	if (index==-1):
		return
	var data: Dictionary = Globals.towers[index]
	var texture: Texture2D = load(data["texture"])
	$Sprite2D.texture = texture
	function_length = data["range"]
	function_speed = data["projectile_speed"]
	enemies_per_function = data["max_targets"]
	sellPrice = data["sell_price"]
	Globals.money -= data["price"]
	rotateTexture = data["rotate_texture"]
	text = text

func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tower_clicked.emit(self)


func _on_timer_timeout() -> void:
	shoot()
