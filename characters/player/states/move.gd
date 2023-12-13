extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State
@export
var attack_state: State
@export
var parry_state: State

@export
var footstep_player: AudioStreamPlayer2D
@export
var friction_modifier: float = 0.0

func enter():
	super()
	friction_modifier = clampf(friction_modifier, 0.0, 1.0)
	
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('Jump') and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("RClick") and parent.is_on_floor():
		return parry_state
	if Input.is_action_just_pressed("Click"):
		return attack_state
	return null
	
func process_physics(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var movement = Input.get_axis('MoveLeft', 'MoveRight') * move_speed
	
	if movement != 0:
		parent.sprite.flip_h = movement < 0
	
	if movement:
		parent.velocity.x = movement
	else:
		var decel_speed = move_speed
		if friction_modifier > 0.0:
			decel_speed = move_speed * friction_modifier
		parent.velocity.x = move_toward(parent.velocity.x, 0, decel_speed)
		
	parent.move_and_slide()
		
	if !parent.is_on_floor():
		return fall_state
	elif parent.velocity.x == 0:
		return idle_state
	
	return null
	
func play_footstep():
	footstep_player.pitch_scale = randf_range(0.8, 1.2)
	footstep_player.play()
