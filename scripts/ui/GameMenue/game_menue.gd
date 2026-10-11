extends Control

signal towerSelected(index: int)

var towerScene = preload("res://scenes/menus/Game/tower_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(6):
		var towerButton: Button = towerScene.instantiate()
		towerButton.setType(i)
		towerButton.pressed.connect(onTowerUIPressed.bind(i))
		$SideBar/Margin/VBoxContainer/ScrollContainer/GridContainer.add_child(towerButton)	

func setMoney(value: int) -> void:
	$LowerLeft/MarginContainer/VBoxContainer/HBoxContainer2/Label.text = str(value)

@onready var bar: TextureProgressBar = $UpperLeft/MarginContainer/VBoxContainer/HBoxContainer/Base_hp_bar

func setMaxHP(value: float) -> void:
	bar.max_value = value
	updateText()

func setHP(value: float) -> void:
	bar.value = value
	updateText()

func updateText():
	$UpperLeft/MarginContainer/VBoxContainer/Label.text = str(bar.value) + "/" + str(bar.max_value) + " HP"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func onTowerUIPressed(index: int) -> void:
	towerSelected.emit(index)
