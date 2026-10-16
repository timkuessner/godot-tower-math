class_name TowerButton
extends Button

var type := 0

var price := 0

func setDisabled(value: bool) -> void:
	disabled = value
	if !Globals.game_state==Globals.GameState.PLAYING:
		disabled=true
	material.set_shader_parameter("strength", 1.0 if value else 0.0)

func onMoneyChanged(value: int) -> void:
	setDisabled(price>value)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material = material.duplicate()
	Globals.money_changed.connect(onMoneyChanged)
	Globals.gameStateChanged.connect(onGameStateChanged)
	pass

func setType(index: int) -> void:
	var data: Dictionary = Globals.towers[index]
	var texture: Texture2D = load(data["texture"])
	var p: int = int(data["price"])
	var tooltip: String = data["tooltip"]
	$VBoxContainer/Type.texture = texture
	price = p
	$VBoxContainer/MarginContainer/HBoxContainer/Label.text = str(price)
	tooltip_text = tooltip
	type = index
	if (index == 3 or 5):
		setDisabled(true)

func onGameStateChanged():
	if !Globals.game_state==Globals.GameState.PLAYING:
		setDisabled(true)
