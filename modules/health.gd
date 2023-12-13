class_name Health
extends Node

@export
var health_ui: HealthOrbDisplay
@export
var max_health : float

var current_health: float

signal damaged(dmg_amt)
signal healed(heal_amt)
signal killed()

func _ready():
	current_health = max_health
	health_ui.max_health_amt = max_health

func take_damage(_dmg_amt):
	print(owner.name," Damaged! Current Health: ", str(current_health))
	
	current_health -= 1.0
	
	if current_health <= 0.0:
		current_health = 0.0
		killed.emit()
	else:
		damaged.emit(1.0)
		
	update_ui()
		
func heal(heal_amt):
	current_health = min(current_health + heal_amt, max_health)
	healed.emit(heal_amt)
	
	update_ui()
	
func update_ui():
	if health_ui and health_ui.has_method("set_current_health"):
		health_ui.set_current_health(current_health)
		
