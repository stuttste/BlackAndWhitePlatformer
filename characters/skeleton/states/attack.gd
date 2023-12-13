extends State

@export
var hitbox_component: Hitbox
@export
var attack_anims: Array[String]
@export
var hobble_state: State
@export
var staggered_state: State
@export
var stagger_comp: Stagger
@onready
var cooldown_timer : Timer = $Cooldown

var staggered = false

func _ready():
	staggered = false
	stagger_comp.connect("staggered", Callable(self, "set_staggered"))
	
func enter():
	attack_anims.shuffle()
	animation_name = attack_anims[0]
	cooldown_timer.start()
	super()
	
func exit():
	if not cooldown_timer.is_stopped(): cooldown_timer.stop()
	hitbox_component.disable_collider()
	super()
	
func process_frame(_delta: float) -> State:
	if staggered: 
		staggered = false
		cooldown_timer.stop()
		return staggered_state
	else: return null

func _on_cooldown_timeout():
	parent.state_machine.change_state(hobble_state)
	
func set_staggered():
	staggered = true
