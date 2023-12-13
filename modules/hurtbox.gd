class_name Hurtbox
extends Area2D

@export
var health_component: Health
@export
var stagger_component: Stagger
@export
var particle_emitter: GPUParticles2D
@export
var parry_box: bool
@export
var stagger_amt: float
@export
var heal_amt: float = 0.5
@export
var apply_damage_directly: bool = false

func _init():
	collision_layer = 0
	collision_mask = 2

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(hitbox: Hitbox):
	if owner == hitbox.owner: return
	if not hitbox or not health_component: return
	
	hitbox.confirm_hit(self)
	
	if(parry_box):
		#Need to swap the x on the emitter if going to use this
		#particle_emitter.emitting = true
		hitbox.stagger(stagger_amt)
		if health_component.has_method("heal"):
			health_component.heal(heal_amt)
	else:
		if apply_damage_directly:
			if health_component.has_method("take_damage"):
				health_component.take_damage(hitbox.damage_amt)
		else:
			stagger_component.deal_stagger_dmg(hitbox.stagger_dmg_amt)
			
func is_elegible_for_execution() -> bool:
	if stagger_component:
		return stagger_component.execution_eligible()
	else:
		return false
