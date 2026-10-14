class_name GameUI
extends Control

signal towerSelected(index: int)

var towerScene = preload("res://scenes/menus/Game/TowerButton.tscn")

func _ready() -> void:
	towerManager.visible = false
	# hab leider keine besseren weg gefunden, die farben anzupassen
	$TowerManager/MarginContainer/VBoxContainer/HBoxContainer2/apply.modulate = Color(0.5, 1, 0.5)
	$TowerManager/MarginContainer/VBoxContainer/HBoxContainer2/apply/Label.modulate = Color(2,1,2)
	$TowerManager/MarginContainer/VBoxContainer/HBoxContainer2/cancel.modulate = Color(1, 0.5, 0.5)
	$TowerManager/MarginContainer/VBoxContainer/HBoxContainer2/cancel/Label.modulate = Color(1,2,2)
	
	$TowerManager/MarginContainer/VBoxContainer/sell.modulate = Color(1, 0.5, 0.5)
	$TowerManager/MarginContainer/VBoxContainer/sell/HBoxContainer/Label.modulate = Color(1,2,2)
	$TowerManager/MarginContainer/VBoxContainer/sell/HBoxContainer/TextureRect.modulate = Color(1,2,2)

	
	Globals.money_changed.connect(onMoneyChanged)
	Globals.maxHPChanged.connect(onMaxHPchanged)
	Globals.hpChanged.connect(onHPchanged)
	for i in range(6):
		var towerButton: Button = towerScene.instantiate()
		towerButton.setType(i)
		towerButton.pressed.connect(onTowerUIPressed.bind(i))
		$SideBar/Margin/VBoxContainer/ScrollContainer/GridContainer.add_child(towerButton)	

func onMoneyChanged(value: int) -> void:
	$LowerLeft/MarginContainer/VBoxContainer/HBoxContainer2/Label.text = str(value)

@onready var bar: TextureProgressBar = $UpperLeft/MarginContainer/VBoxContainer/HBoxContainer/Base_hp_bar

func onMaxHPchanged(value: float) -> void:
	bar.max_value = value
	updateText()

func onHPchanged(value: float) -> void:
	bar.value = value
	updateText()

func updateText():
	$UpperLeft/MarginContainer/VBoxContainer/Label.text = str(bar.value) + "/" + str(bar.max_value) + " HP"

func onTowerUIPressed(index: int) -> void:
	towerSelected.emit(index)

@onready var towerManager: Panel = $TowerManager
@onready var directionButton: Button = $TowerManager/MarginContainer/VBoxContainer/Direction
@onready var functionContainer: TextEdit = $TowerManager/MarginContainer/VBoxContainer/HBoxContainer/Function
@onready var sellLabel: Label = $TowerManager/MarginContainer/VBoxContainer/sell/HBoxContainer/Label

var tower: Tower

var direction := false:
	set(value):
		if value: directionButton.text = "fire: right"
		else: directionButton.text = "fire: left"
		direction = value

func loadTowerManager(t: Tower) -> void:
	towerManager.visible = true
	direction = t.direction
	functionContainer.text = t.text
	tower = t
	sellLabel.text = "sell for " + str(tower.sellPrice)
	tower.showPreview = true

func _on_direction_pressed() -> void:
	direction = !direction
	tower.previewDirection = direction

func _on_apply_pressed() -> void:
	tower.direction = direction
	tower.text = functionContainer.text
	tower.showPreview = false
	towerManager.visible = false

func _on_cancel_pressed() -> void:
	tower.text = tower.text
	tower.showPreview = false
	towerManager.visible = false

func _on_sell_pressed() -> void:
	Globals.money += tower.sellPrice
	tower.queue_free()
	towerManager.visible = false


func _on_function_text_changed() -> void:
	tower.previewText = functionContainer.text

@onready var playButton: Button = $HBoxContainer/Running
@onready var speedButton: Button = $HBoxContainer/Speed

var playTextures := [
	preload("res://assets/UI/pause.png"),
	preload("res://assets/UI/play.png")
]
var speedTextures := [
	preload("res://assets/UI/speed_x1.png"),
	preload("res://assets/UI/speed_x2.png"),
	preload("res://assets/UI/speed_x4.png")
]

var running := true:
	set(value):
		running = value
		playButton.icon = playTextures[int(value)]
		updateEngineSpeed()

var speed_state := 0:
	set(value):
		speed_state = value
		speedButton.icon = speedTextures[value]
		updateEngineSpeed()

func updateEngineSpeed() -> void:
	Engine.time_scale = (2**speed_state)
	print(Engine.time_scale)
	if (!running):
		Engine.time_scale = 0

func _on_running_pressed() -> void:
	running = !running

func _on_speed_pressed() -> void:
	speed_state = (speed_state + 1) % 3

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/MainMenue.tscn")
