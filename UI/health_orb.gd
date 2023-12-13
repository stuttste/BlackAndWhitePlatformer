class_name HealthOrb
extends TextureRect

@onready
var prog_bar = $HealthOrbProgress
@onready
var full_texture = $FullTexture
@onready
var part_emit = $HealthOrbParticles

var max_health: float = 100.0
var current: float
var emit_particles: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	current = max_health
	full_texture.visible = false
	part_emit.emitting = false
	part_emit.position = Vector2(size.x/2.0, size.y/2.0)
	update_orb()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_orb()
		

func update_orb():
	if current == max_health:
		full_texture.visible = true
		part_emit.emitting = (emit_particles and true)
	else:
		full_texture.visible = false
		part_emit.emitting = false
		
	prog_bar.max_value = max_health
	prog_bar.value = current

func update_health(current_amt: float):
	current = current_amt
