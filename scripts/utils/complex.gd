class_name Complex
extends RefCounted

var real: float
var imag: float

func _init(r: float = 0.0, i: float = 0.0) -> void:
	real = r
	imag = i

func add(b: Complex) -> Complex:
	return Complex.new(real + b.real, imag + b.imag)

func subtract(b: Complex) -> Complex:
	return Complex.new(real - b.real, imag - b.imag)

func multiply(b: Complex) -> Complex:
	return Complex.new(real * b.real - imag * b.imag, real * b.imag + imag * b.real)

func divide(b: Complex) -> Complex:
	var denominator = b.real * b.real + b.imag * b.imag
	
	if denominator == 0.0:
		return Complex.new(NAN, NAN)
	
	return Complex.new(
		(real * b.real + imag * b.imag) / denominator,
		(imag * b.real - real * b.imag) / denominator
	)

func magnitude() -> float:
	return sqrt(real * real + imag * imag)

func argument() -> float:
	return atan2(imag, real)

func _to_string() -> String:
	return str(real) + (" + " if imag >= 0 else " - ") \
		+ str(abs(imag)) + "i"
