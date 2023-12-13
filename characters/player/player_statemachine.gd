class_name Player
extends CharacterBody2D

@onready
var animations = $AnimationPlayer
@onready
var sprite = $AnimatedSprite2D
@onready
var state_machine = $StateMachine
@onready
var hitbox_col = $Hitbox/HitboxColShape

@export var attack_momentum = 1000.0
@export var execution_state : State

var hitbox_col_x_value
var input_enabled = true
var execution_target

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	hitbox_col_x_value = hitbox_col.position.x

func _unhandled_input(event: InputEvent) -> void:
	if input_enabled:
		state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	#flip hitbox collider based on sprite direction
	if sprite.flip_h:
		hitbox_col.position.x = hitbox_col_x_value * -1
	else:
		hitbox_col.position.x = hitbox_col_x_value
		
	state_machine.process_frame(delta)

func enable_input():
	input_enabled = true
	
func apply_forward_momentum():
	var speed_adj = attack_momentum
	if sprite.flip_h:
		speed_adj = speed_adj * -1.0
		
	velocity.x = speed_adj
	move_and_slide()


func _on_hitbox_execution_detected(enemy):
	if not enemy.has_method("perform_execution"):
		return
		
	execution_target = enemy
	var chosen_execution : Execution = enemy.perform_execution()
	if chosen_execution:
		
		var adjusted_x = chosen_execution.distance_x
		var distance = enemy.position - position
		if distance.x > 0 : adjusted_x = adjusted_x * -1
		var adjusted_pos = execution_target.global_position + Vector2(adjusted_x, 0.0)
		adjusted_pos = Vector2(adjusted_pos.x, position.y)
		
		global_position = adjusted_pos
		
		execution_state.animation_name = chosen_execution.player_animation_name
		state_machine.change_state(execution_state)
		
func apply_execution_damage():
	if not execution_target: return
	
	if execution_target.has_method("take_damage"):
		execution_target.take_damage()
		
	execution_target = null
