class_name TowerButton
extends Button

var type := 0

var price := 0

var towers := [
	["res://assets/Tower/shooter.png", 100, "Shooter\nA reliable all-rounder.\nHits one enemy at a time.\nMedium range and damage."],
	["res://assets/Tower/slime.png", 150, "Slime\nSlows enemies down.\nHits several enemies at once.\nDeals no damage."],
	["res://assets/Tower/bomber.png", 250, "Bomber\nExplodes on the first hit.\nHeavy damage to all\nenemies nearby."],
	["res://assets/Tower/booster.png", 200, "Booster\nDoesn't attack enemies.\nShoots your towers instead\nand boosts them."],
	["res://assets/Tower/sniper.png", 350, "Sniper\nExtreme range.\nVery high damage to one enemy.\nSlow to reload."],
	["res://assets/Tower/mage.png", 600, "Mage\nAn imaginary tower.\nFades in and out and only\nattacks while visible.\nHuge range, area damage.\nExpensive."],
	]

func setDisabled(value: bool) -> void:
	disabled = value
	material.set_shader_parameter("amount", 1.0 if value else 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func setType(index: int) -> void:
	$VBoxContainer/Type.texture = load(towers[index][0])
	price = towers[index][1]
	$VBoxContainer/MarginContainer/HBoxContainer/Label.text = str(price)
	tooltip_text = towers[index][2]
	type = index
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
