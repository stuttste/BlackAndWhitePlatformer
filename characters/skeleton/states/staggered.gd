extends State

@export 
var stagger_comp: Stagger
@export
var stagger_recover_state: State

var recovered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	recovered = false
	stagger_comp.connect("recovered", Callable(self, "set_recovered"))

func enter() -> void:
	super()
	recovered = false
	parent.velocity.x = 0
	
func exit():
	recovered = false
	super()

func process_frame(_delta: float) -> State:
	if recovered: 
		recovered = false
		return stagger_recover_state
	else: 
		return null

func set_recovered():
	recovered = true
