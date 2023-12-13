extends State


@export
var idle_state: State
@export
var move_state: State

func enter():
	super()
	
func process_physics(delta):
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis('MoveLeft', 'MoveRight') * move_speed
	
	if movement != 0:
		parent.sprite.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()

	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null
