extends State

@export
var idle_state: State
@export
var move_state: State
@export
var attack_state: State

func enter():
	super()
	parent.input_enabled = false
	
func exit():
	super()
	
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('Click') and parent.is_on_floor():
		return attack_state
	elif Input.is_action_pressed('MoveLeft') or Input.is_action_pressed('MoveRight'):
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
