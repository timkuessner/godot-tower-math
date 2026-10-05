class_name Level
extends Node2D

@export var level_number: int = 1


func _ready() -> void:
	print("Level ", level_number, " loaded")
