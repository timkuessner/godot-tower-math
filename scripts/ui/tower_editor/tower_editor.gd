class_name TowerEditor
extends Control

var selected_tower: Tower

func edit_tower(tower: Tower) -> void:
	selected_tower = tower
	
	$Panel/Container/FunctionInput.text = tower.function_text
	$Panel/Container/FunctionSize.text = "Function Size: " + str(tower.function_size)
	$Panel/Container/FunctionSpeed.text = "Function Speed: " + str(tower.function_speed)
	$Panel/Container/EnemiesPerFunction.text = "Enemies Per Function: " + str(tower.enemies_per_function)
	
	show()


func _on_function_input_text_changed(new_text: String) -> void:
	selected_tower.function_text = new_text
