extends State

@export
var fall_state: State
@export
var jump_state: State
@export
var move_state: State
@export
var attack_state: State
@export
var parry_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('Jump') and parent.is_on_floor():
		return jump_state
	if Input.is_action_pressed('MoveLeft') or Input.is_action_pressed('MoveRight'):
		return move_state
	if Input.is_action_just_pressed("RClick") and parent.is_on_floor():
		return parry_state
	if Input.is_action_just_pressed("Click"):
		return attack_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
