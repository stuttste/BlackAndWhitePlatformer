class_name StaggerUI
extends TextureRect

var current_stagger : float = 0.0
var current_recovery: float

@onready var stagger_progress : TextureProgressBar = $StaggerProgress
@onready var recover_progress : TextureProgressBar = $RecoveryBar

# Called when the node enters the scene tree for the first time.
func _ready():
	recover_progress.visible = false
	recover_progress.value = recover_progress.max_value
	current_recovery = recover_progress.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	stagger_progress.value = current_stagger
	recover_progress.value = current_recovery
	
func update_stagger(stagger_amt: float):
	current_stagger = stagger_amt
	
#Expecting a percentage
func update_recovery(recovery_amt: float):
	current_recovery = recover_progress.max_value * recovery_amt
		
func trigger_recovery():
	recover_progress.value = recover_progress.max_value
	current_recovery = recover_progress.max_value
	recover_progress.visible = true
	stagger_progress.visible = false
	
func trigger_recover():
	current_recovery = recover_progress.max_value
	recover_progress.visible = false
	stagger_progress.visible = true
