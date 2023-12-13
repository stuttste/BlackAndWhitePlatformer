class_name Hitbox
extends Area2D

signal stagger_received(stagger_amt)
signal execution_detected(enemy)

@export
var health_component: Health
@export
var hitbox_col: CollisionShape2D
@export
var heal_on_hit_amt: float
@export
var damage_amt: float
@export
var stagger_dmg_amt: float
@export
var executions_enabled: bool = false

func _init():
	collision_layer = 2
	collision_mask = 0

func stagger(stagger_amt: float):
	print("Successfully parried: stagger_amt=", str(stagger_amt))
	stagger_received.emit(stagger_amt)
	
func confirm_hit(hurtbox : Hurtbox):
	if health_component and health_component.has_method("heal"):
		health_component.heal(heal_on_hit_amt)
		
	if hurtbox and executions_enabled:
		if hurtbox.is_elegible_for_execution():
			execution_detected.emit(hurtbox.owner)

func enable_collider():
	hitbox_col.set_deferred("disabled", false)
		
func disable_collider():
	hitbox_col.set_deferred("disabled", true)
