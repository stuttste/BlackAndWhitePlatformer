extends CharacterBody2D

const SPEED = 250.0
const ATTACK_FORCE_SPEED = 1000.0
const JUMP_VELOCITY = -400.0

@onready var anim_tree : AnimationTree = $AnimationTree
@onready var play_idle_timer : Timer = $PlayIdleTimer
@onready var state_machine: AnimationNodeStateMachinePlayback = anim_tree["parameters/playback"]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var normalized_velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var play_idle = false
var attacking = false
@export var input_enabled = true
var currentCombo = 0
var maxCombo = 3

func _ready():
	$AnimationTree.active = true

func _process(delta):
	pass

func _physics_process(delta):
	normalized_velocity = velocity.normalized()
	if normalized_velocity.x == 1:
		$AnimatedSprite2D.flip_h = false
	elif normalized_velocity.x == -1:
		$AnimatedSprite2D.flip_h = true
	
	if velocity != Vector2.ZERO: 
		play_idle = false
		play_idle_timer.stop()
	elif play_idle_timer.is_stopped():
		play_idle_timer.start()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("RClick") and input_enabled:
		handle_parry()

	if Input.is_action_just_pressed("Click") and currentCombo < maxCombo and is_on_floor() and input_enabled:
		handle_attacking()

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() and input_enabled:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("MoveLeft", "MoveRight")
	if direction and input_enabled:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if input_enabled:
		handle_animations()
	move_and_slide()

func reset_anims():
	anim_tree.set("parameters/conditions/moving", false)
	anim_tree.set("parameters/conditions/not_moving", true)
	anim_tree.set("parameters/conditions/in_air", false)
	anim_tree.set("parameters/conditions/on_ground", true)
	anim_tree.set("parameters/conditions/wind_blowing", false)
	anim_tree.set("parameters/conditions/wind_not_blowing", true)
	anim_tree.set("parameters/conditions/not_attacking", true)
	anim_tree.set("parameters/conditions/attacking", false)
	anim_tree.set("parameters/GroundAttack/conditions/attack2", false)
	anim_tree.set("parameters/GroundAttack/conditions/attack3", false)
	anim_tree.set("parameters/conditions/not_parry", true)
	anim_tree.set("parameters/conditions/parry", false)

func handle_animations():
	if velocity == Vector2.ZERO:
		anim_tree.set("parameters/conditions/moving", false)
		anim_tree.set("parameters/conditions/not_moving", true)
		anim_tree.set("parameters/conditions/in_air", false)
		anim_tree.set("parameters/conditions/on_ground", true)
		
		if play_idle:
			anim_tree.set("parameters/conditions/wind_blowing", true)
			anim_tree.set("parameters/conditions/wind_not_blowing", false)
		else:
			anim_tree.set("parameters/conditions/wind_blowing", false)
			anim_tree.set("parameters/conditions/wind_not_blowing", true)
	else:
		anim_tree.set("parameters/conditions/wind_blowing", false)
		anim_tree.set("parameters/conditions/wind_not_blowing", false)
		
		if is_on_floor() and velocity.x != 0:
			anim_tree.set("parameters/conditions/not_moving", false)
			anim_tree.set("parameters/conditions/in_air", false)
			anim_tree.set("parameters/conditions/on_ground", true)
			anim_tree.set("parameters/conditions/moving", true)
		elif not is_on_floor():
			anim_tree.set("parameters/conditions/not_moving", false)
			anim_tree.set("parameters/conditions/on_ground", false)
			anim_tree.set("parameters/conditions/moving", false)
			anim_tree.set("parameters/conditions/in_air", true)
		else:
			anim_tree.set("parameters/conditions/moving", false)
			anim_tree.set("parameters/conditions/not_moving", true)
	
	#print("DEBUG: velocity = " + str(normalized_velocity.x))
	anim_tree["parameters/Idle/blend_position"] = normalized_velocity
	anim_tree["parameters/Idle_wind/blend_position"] = normalized_velocity
	anim_tree["parameters/Jump/blend_position"] = normalized_velocity.y
	
#	var current_animation = state_machine.get_current_node()
#	print("current animation: ", current_animation)

func handle_attacking():
	input_enabled = false
	if currentCombo == 0:
		anim_tree.set("parameters/conditions/not_attacking", false)
		anim_tree.set("parameters/conditions/attacking", true)
		currentCombo += 1
	elif currentCombo == 1:
		anim_tree.set("parameters/GroundAttack/conditions/attack2", true)
		currentCombo += 1
	elif currentCombo == 2:
		anim_tree.set("parameters/GroundAttack/conditions/attack3", true)
		currentCombo += 1
	else:
		reset_attack_state()
		
func handle_parry():
	input_enabled = false
	reset_anims()
	anim_tree.set("parameters/conditions/not_parry", false)
	anim_tree.set("parameters/conditions/parry", true)
	
func release_parry():
	anim_tree.set("parameters/conditions/parry", false)
	anim_tree.set("parameters/conditions/not_parry", true)

func _on_play_idle_timer_timeout():
	play_idle = true

func reset_attack_state():
	currentCombo = 0
	anim_tree.set("parameters/GroundAttack/conditions/attack2", false)
	anim_tree.set("parameters/GroundAttack/conditions/attack3", false)
	anim_tree.set("parameters/conditions/attacking", false)
	anim_tree.set("parameters/conditions/not_attacking", true)
	enable_input()

func _on_animation_tree_animation_finished(anim_name):
	#Handle the end of combo
	if (anim_name == "Attack1") or (anim_name == "Attack2") or (anim_name == "Attack3"):
		currentCombo = 0

func enable_input():
	input_enabled = true
	
func apply_forward_momentum():
	var speed_adj = ATTACK_FORCE_SPEED
	if $AnimatedSprite2D.flip_h:
		speed_adj = speed_adj * -1.0
		
	velocity.x = speed_adj

func _on_animation_tree_animation_started(anim_name):
	pass
	#Apply force on swing (Removing for now but keeping code for reference
#	var speed_adj = ATTACK_FORCE_SPEED
#	if $AnimatedSprite2D.flip_h:
#		speed_adj = speed_adj * -1.0
#	if anim_name == "Attack1" or anim_name == "Attack2":
#		velocity.x = speed_adj
#	elif anim_name == "Attack3":
#		velocity.x = speed_adj * 1.3
		
