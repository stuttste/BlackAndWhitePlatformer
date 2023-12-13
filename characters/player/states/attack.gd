extends State

@export
var hitbox_component: Hitbox
@export
var idle_state: State
@export
var parry_state: State
@export
var move_state: State
@export
var next_attack_state: State

@export
var forward_thrust : float = 0.0

func enter():
	super()
	parent.input_enabled = false
	
func exit():
	hitbox_component.disable_collider()
	super()
	
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('Click') and parent.is_on_floor() and next_attack_state:
		return next_attack_state
	elif Input.is_action_just_pressed("RClick") and parent.is_on_floor():
		return parry_state
	elif Input.is_action_just_pressed('MoveLeft') or Input.is_action_just_pressed('MoveRight'):
		return move_state
	
	return null
	
func process_physics(_delta):
	var movement = Input.get_axis('MoveLeft', 'MoveRight') * move_speed
	if not parent.animations.is_playing():
		if parent.is_on_floor():
			if movement != 0:
				return move_state
			return idle_state
	
	return null
