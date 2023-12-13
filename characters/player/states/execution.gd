extends State

@export
var idle_state: State
@export
var move_state: State
@export
var jump_state: State
@export
var attack_state: State
@export
var parry_state: State

func enter():
	super()
	
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('Jump') and parent.is_on_floor():
		return jump_state
	elif Input.is_action_just_pressed('Click') and parent.is_on_floor() and attack_state:
		return attack_state
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
