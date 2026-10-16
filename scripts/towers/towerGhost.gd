class_name TowerGhost
extends Node2D

var isValid := true

var type: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible=false
	Globals.gameStateChanged.connect(onGameStateChanged)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setType(index: int) -> void:
	var data: Dictionary = Globals.towers[index]
	var texture: Texture2D = load(data["texture"])
	if (index==-1):
		return
	$Sprite2D.texture = texture
	type = index

func _physics_process(delta: float) -> void:
	if !visible:
		return
	isValid = !$Area2D.has_overlapping_areas()
	if isValid:
		$".".modulate = Color(0.5, 1, 0.5)
	else:
		$".".modulate = Color(1, 0.5, 0.5)
		
func onGameStateChanged():
	if !Globals.game_state==Globals.GameState.PLAYING:
		visible=false
