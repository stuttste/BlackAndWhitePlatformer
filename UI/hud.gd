extends Control

var HEALTH_ORB_SCENE = preload("res://UI/health_orb.tscn")

@onready
var health_orbs = $HealthOrbs
@export
var max_health_amt: float = 3.0
var current_health_amt: float

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health_amt = max_health_amt
	
	var i = 0
	while i < max_health_amt:
		var health_orb_instance = HEALTH_ORB_SCENE.instantiate()
		health_orbs.add_child(health_orb_instance)
		i += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_health_orbs()
	
func update_health_orbs():
	var i = 0.0
	while i <= max_health_amt:
		var health_orb = health_orbs.get_child(i)
		if health_orb:
			if current_health_amt >= (i+1):
				health_orb.update_health(100.0)
			elif current_health_amt > i:
				health_orb.update_health((current_health_amt - int(current_health_amt)) * 100)
			else:
				health_orb.update_health(0.0)
		i += 1.0
		
func set_current_health(current_health:float):
	current_health_amt = current_health
