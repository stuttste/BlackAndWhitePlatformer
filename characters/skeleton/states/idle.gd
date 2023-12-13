extends State



func enter() -> void:
	super()
	parent.velocity.x = 0

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	return null
