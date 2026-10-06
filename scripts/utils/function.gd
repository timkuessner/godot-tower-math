class_name Function
extends RefCounted

const STEPS = 100

var text: String = ""
var is_valid: bool = false

func _init(function_text: String = "") -> void:
	if function_text != "":
		set_text(function_text)


func set_text(function_text: String) -> void:
	text = function_text
	is_valid = true


func evaluate(x: float) -> float:
	if !is_valid:
		return NAN
	
	return sin(x)


func point_at(x: float) -> Vector2:
	return Vector2(x, evaluate(x))

func create_path(length: float) -> PackedVector2Array:
	var path := PackedVector2Array()
	
	for i in range(STEPS + 1):
		var x := lerpf(0, length, float(i)/STEPS)
		var y := evaluate(x) * 10
		
		if not is_nan(y) and not is_inf(y):
			path.append(Vector2i(x, -y))
	return path
