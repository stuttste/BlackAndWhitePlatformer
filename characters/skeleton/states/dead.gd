extends State

@export
var default_state: State

var revive = false

func enter():
	super()
	
func exit():
	super()
	
func process_frame(_delta):
	if revive:
		revive = false
		return default_state
