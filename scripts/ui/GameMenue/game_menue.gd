extends Control

signal towerSelected(index: int)

var towerScene = preload("res://scenes/menus/Game/tower_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(6):
		var towerButton: Button = towerScene.instantiate()
		towerButton.setType(i)
		towerButton.pressed.connect(onTowerUIPressed.bind(i))
		$SideBar/Margin/GridContainer.add_child(towerButton)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func onTowerUIPressed(index: int) -> void:
	towerSelected.emit(index)
