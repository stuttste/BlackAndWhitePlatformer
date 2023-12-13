extends State

@export
var hobble_state : State

func enter() -> void:
	super()

func process_frame(_delta: float) -> State:
	if parent.animations.is_playing(): return null
	else: return hobble_state
