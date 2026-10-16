class_name GameUI
extends Control

signal towerSelected(index: int)

var towerScene = preload("res://scenes/menus/Game/TowerButton.tscn")

var playTextures := [
	preload("res://assets/UI/pause.png"),
	preload("res://assets/UI/play.png")
]
var speedTextures := [
	preload("res://assets/UI/speed_x1.png"),
	preload("res://assets/UI/speed_x2.png"),
	preload("res://assets/UI/speed_x4.png")
]

@onready var resultScreen: CenterContainer = $ResultScreen
@onready var resultLabel: Label = $ResultScreen/Panel/CenterContainer/Label
@onready var bar: TextureProgressBar = $UpperLeft/MarginContainer/VBoxContainer/HBoxContainer/Base_hp_bar

@onready var towerManager: Panel = $TowerManager
@onready var directionButton: Button = $TowerManager/MarginContainer/VBoxContainer/Direction
@onready var functionContainer: TextEdit = $TowerManager/MarginContainer/VBoxContainer/HBoxContainer/Function
@onready var sellLabel: Label = $TowerManager/MarginContainer/VBoxContainer/sell/HBoxContainer/Label

@onready var playButton: Button = $HBoxContainer/Running
@onready var speedButton: Button = $HBoxContainer/Speed

func _ready() -> void:
	towerManager.visible = false
	
	Level.c.money_changed.connect(onMoneyChanged)
	Level.c.maxHPChanged.connect(onMaxHPchanged)
	Level.c.hpChanged.connect(onHPchanged)
	
	Level.c.gameStateChanged.connect(onGameStateChanged)
	
	for i in range(6):
		var towerButton: Button = towerScene.instantiate()
		towerButton.setType(i)
		towerButton.pressed.connect(onTowerUIPressed.bind(i))
		$SideBar/Margin/VBoxContainer/ScrollContainer/GridContainer.add_child(towerButton)	

func onMoneyChanged(value: int) -> void:
	$LowerLeft/MarginContainer/VBoxContainer/HBoxContainer2/Label.text = str(value)

func onMaxHPchanged(value: float) -> void:
	bar.max_value = value
	updateText()

func onHPchanged(value: float) -> void:
	bar.value = value
	updateText()

func updateText():
	$UpperLeft/MarginContainer/VBoxContainer/Label.text = str(bar.value) + "/" + str(bar.max_value) + " HP"

func onTowerUIPressed(index: int) -> void:
	if Level.c.game_state==Level.c.GameState.PLAYING:
		towerSelected.emit(index)

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
	if tower!=null:
		tower.showPreview = false
		towerManager.visible = false

func _on_sell_pressed() -> void:
	Level.c.money += tower.sellPrice
	tower.queue_free()
	towerManager.visible = false

func _on_function_text_changed() -> void:
	tower.previewText = functionContainer.text

var running := true:
	set(value):
		running = value
		playButton.icon = playTextures[int(!value)]
		updateEngineSpeed()

var speed_state := 0:
	set(value):
		speed_state = value
		speedButton.icon = speedTextures[value]
		updateEngineSpeed()

func updateEngineSpeed() -> void:
	Engine.time_scale = (2**speed_state)
	if (!running):
		Engine.time_scale = 0

func _on_running_pressed() -> void:
	if !Level.c.game_state==Level.c.GameState.PLAYING: return
	running = !running

func _on_speed_pressed() -> void:
	if !Level.c.game_state==Level.c.GameState.PLAYING: return
	speed_state = (speed_state + 1) % 3

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/MainMenue.tscn")

func onGameStateChanged():
	if !Level.c.game_state==Level.c.GameState.PLAYING:
		_on_cancel_pressed()
		speed_state=0
	if Level.c.game_state==Level.c.GameState.PLAYING:
		resultScreen.visible=false
	elif Level.c.game_state==Level.c.GameState.WON:
		showResult("You won!")
	elif Level.c.game_state==Level.c.GameState.LOST:
		showResult("You lost!")

var result_tween: Tween

func showResult(text: String) -> void:
	resultLabel.text = text
	resultScreen.modulate.a = 0.0
	resultScreen.visible=true

	result_tween = create_tween()
	result_tween.tween_interval(1.0)
	result_tween.tween_callback(resultScreen.show)
	result_tween.tween_property(resultScreen, "modulate:a", 1.0, 0.8) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
