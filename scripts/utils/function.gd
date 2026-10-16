class_name Function
extends RefCounted

var text: String = ""
var function: Expression = Expression.new()
var is_valid: bool = false

const MATH_CONSTANTS := {
	"PI": PI,
	"TAU": TAU,
	"exp(1)": exp(1),
}

var replacements := [
	["exp", "K7mQ2aV9pL4zN8rT6wY0"],
	["−", "-"],
	["×", "*"],
	["·", "*"],
	["÷", "/"],

	["²", "**2"],
	["³", "**3"],
	["⁴", "**4"],
	["⁵", "**5"],
	["⁶", "**6"],
	["⁷", "**7"],
	["⁸", "**8"],
	["⁹", "**9"],

	["π", "PI"],
	["pi", "PI"],
	["tau", "TAU"],
	["τ", "TAU"],
	["e", "exp(1)"],

	["arcsin", "asin"],
	["arccos", "acos"],
	["arctan", "atan"],
	["ln", "log"],

	["√", "sqrt"],
	["^", "**"],

	["[", "("],
	["]", ")"],
	["{", "("],
	["}", ")"],
	["K7mQ2aV9pL4zN8rT6wY0", "exp"],
]

func _init(function_text: String = "") -> void:
	if function_text != "":
		set_text(function_text)
	else:
		set_text("0")

func set_text(function_text: String) -> void:
	is_valid = true
	text = pharser(function_text)
	var err: Error = function.parse(text, ["x"])
	if err != OK:
		is_valid = false
	elif (is_nan(f(0))):
		is_valid = false

# Main Pipeline
func pharser(t: String) -> String:
	t = normalise(t)
	
	t = implicit_multiplication(t)
	
	return t

func implicit_multiplication(text: String) -> String:
	for constant in MATH_CONSTANTS:
		text = text.replace(constant, str(MATH_CONSTANTS[constant]))
	
	var regex = RegEx.new()
	
	regex.compile("([0-9])([a-z])")
	text = regex.sub(text, "$1*$2", true)
	
	regex.compile("([0-9])\\(")
	text = regex.sub(text, "$1*(", true)
	
	regex.compile("\\)([a-z0-9(])")
	text = regex.sub(text, ")*$1", true)
	
	regex.compile("\\)\\(")
	text = regex.sub(text, "$1*$2", true)
	
	return text

func normalise(t: String) -> String:
	if (t == ""):
		return "0"
	t = t.to_lower()
	for r in replacements:
		t = t.replace(r[0], r[1])
	return t

func f(x: float) -> float:
	var y = function.execute([x], null, false)
	if function.has_execute_failed() or typeof(y) not in [TYPE_FLOAT, TYPE_INT]:
		return NAN
	if !is_finite(y):
		return NAN
	return y

func point_at(x: float) -> Vector2:
	return Vector2(x, f(x))

# leange des Pfades und Schrittweite, negative Schrittweite fuehrt zur Richtungswechsel
func create_path(length: float, step: float) -> PackedVector2Array:
	var path := PackedVector2Array()
	if (!is_valid or length<=0 or step == 0):
		return path
	var i: int = 0
	
	var x: float = 0
	var y: float = 0
	
	var yOffset: float = f(0)
	
	path.append(Vector2(0, 0))
	
	var xOld = 0
	var yOld = 0

	while i<10000:
		i += 1
		x += step
		var fx = f(x)
		if (is_nan(fx)):
			break
		y = fx - yOffset
		length -= sqrt((xOld-x)**2+(yOld-y)**2)
		
		if (length>0):
			path.append(Vector2(x, -y))
		else:
			break
		xOld = x
		yOld = y
	return path

func rescrale(path: PackedVector2Array, scale: int) -> PackedVector2Array:
	var newPath: = PackedVector2Array()
	for position in path:
		newPath.append(Vector2(position[0]*scale, position[1]*scale))
	return newPath
