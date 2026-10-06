class_name Function
extends RefCounted

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
	
	return x*x


func point_at(x: float) -> Vector2:
	return Vector2(x, evaluate(x))


func sample(start_x: float, size: float, steps: int = 100) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in range(steps + 1):
		var x := lerpf(start_x, start_x + size, float(i) / steps) * 10
		var y := evaluate(x) / 10
		if not is_nan(y) and not is_inf(y):
			points.append(Vector2(x, -y))
	return points
