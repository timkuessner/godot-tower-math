extends Control

signal towerSelected(index: int)

var tower = preload("res://scenes/towers/tower01.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func onTowerUIPressed(index: int) -> void:
	towerSelected.emit(index)
