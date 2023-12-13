extends CharacterBody2D

@onready
var animations = $AnimationPlayer
@onready
var sprite = $AnimatedSprite2D
@onready
var state_machine = $StateMachine
@onready
var hitbox_col = $Hitbox/HitboxCol
@onready
var hurtbox_col = $Hurtbox/HurtboxCol
@onready
var player_detector : PlayerDetector = $PlayerDetector
@onready
var col : CollisionShape2D = $CollisionShape2D
@onready
var health_component : Health = $Behaviors/Health

@export
var ui_elements : Array[Node]
@export
var death_state: State
@export
var executed_state: State
@export
var execution_anims: Array[Execution]

var player : Player
var hitbox_col_x_value

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	hitbox_col_x_value = hitbox_col.position.x

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _on_health_killed():
	#turn off player monitoring
	player_detector.monitoring = false
	#disable collision
	col.set_deferred("disabled", true)
	hurtbox_col.set_deferred("disabled", true)
	#hide the UI
	hide_ui_elements()
	#swap to dead state
	state_machine.change_state(death_state)


func _on_player_detector_player_entered(player_body):
	player = player_body
	state_machine.change_state($StateMachine/Hobble)
	print("Player entered")


func _on_player_detector_player_exited():
	print("Player exited")
	
func hide_ui_elements():
	for child in ui_elements:
		child.visible = false

func perform_execution() -> Execution:
	if not executed_state: return null
	
	var execution_anim_selection : Execution = execution_anims.pick_random()
	executed_state.animation_name = execution_anim_selection.enemy_animation_name
	state_machine.change_state(executed_state)
	
	return execution_anim_selection
	
func take_damage():
	if not health_component: return
	
	health_component.take_damage(1.0)
