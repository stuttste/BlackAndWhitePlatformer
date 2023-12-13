extends State

@export
var idle_state: State
@export
var attack_state: State
@export
var max_distance: int
@export
var min_distance: int

var player : Player

func enter():
	super()
	player = owner.player

func process_physics(_delta):
	if player:
		var direction = (player.global_position - parent.position)
		var direction_nomalized = direction.normalized()
		
		if direction_nomalized.x > 0:
			parent.sprite.flip_h = false
			parent.hitbox_col.position.x = parent.hitbox_col_x_value
		if direction_nomalized.x < 0:
			parent.sprite.flip_h = true
			parent.hitbox_col.position.x = parent.hitbox_col_x_value * -1
		
		if abs(direction.x) > max_distance:
			parent.animations.play(animation_name)
			parent.velocity.x = direction_nomalized.x * move_speed
			parent.move_and_slide()
		elif abs(direction.x) < min_distance:
			return attack_state
#			parent.animations.play_backwards(animation_name)
#			parent.velocity.x = (direction_nomalized.x * move_speed) * -1
#			parent.move_and_slide()
