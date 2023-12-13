extends State

@export
var health_component: Health
@export
var stagger_component: Stagger
@export
var return_state: State
@export
var death_state: State
@export
var recover_delay_in_seconds: float 

var health_amt_at_begin
var recovered_from_stagger: bool = false

func enter():
	health_amt_at_begin = health_component.current_health
	recovered_from_stagger = false
	super()
	
func process_frame(_delta):
	if health_component.current_health != health_amt_at_begin:
		if health_component.current_health == 0.0:
			return death_state
		else:
			if not recovered_from_stagger:
				stagger_component.recover_from_stagger()
				recovered_from_stagger = true
			get_tree().create_timer(recover_delay_in_seconds).timeout.connect(Callable(self, "recover"))
			
func recover():
	parent.state_machine.change_state(return_state)
