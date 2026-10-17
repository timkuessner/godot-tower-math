class_name MainMenue
extends Control

var levels := [
	"res://scenes/levels/LevelTutorial.tscn",
	"res://scenes/levels/Level01.tscn",
	"res://scenes/levels/Level02.tscn",
	"res://scenes/levels/Level03.tscn",
	"res://scenes/levels/Level04.tscn",
	"res://scenes/levels/Level05.tscn",
	"res://scenes/levels/LevelDev.tscn",
]

func onPlayLevelPressed(index: int) -> void:
	if index == -1: index = levels.size() - 1
	get_tree().change_scene_to_file(levels[index])

func onOptionsPressed() -> void:
	print("onOptionsPressed")

func onQuitPressed() -> void:
	get_tree().quit()
