extends Node2D

var isValid := true

var type: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var imagePaths := [
	"res://assets/Tower/shooter.png",
	"res://assets/Tower/slime.png",
	"res://assets/Tower/bomber.png",
	"res://assets/Tower/booster.png",
	"res://assets/Tower/sniper.png",
	"res://assets/Tower/mage.png",
	]


func setType(index: int) -> void:
	if (index==-1):
		return
	$".".texture = load(imagePaths[index])
	type = index

func _physics_process(delta: float) -> void:
	if !visible:
		return
	isValid = !$Area2D.has_overlapping_areas()
	if isValid:
		$".".modulate = Color(0.5, 1, 0.5)
	else:
		$".".modulate = Color(1, 0.5, 0.5)
		
