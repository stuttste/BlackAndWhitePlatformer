class_name Stagger
extends Node

signal staggered()
signal recovered()

@export
var hitbox: Hitbox
@export
var stagger_ui: StaggerUI
@export
var max_stagger: float = 100.0
@export
var recovery_time_in_sec: float = 5.0
@export
var recovery_amt_per_tick: float = 1.0
@export
var recovery_tick_rate_in_sec: float = 5.0

var is_staggered = false
var recovery_timer : Timer
var recover_from_stagger_timer : Timer
var current_stagger: float = 0.0

func _ready():
	recovery_timer = Timer.new()
	recovery_timer.wait_time = recovery_tick_rate_in_sec
	add_child(recovery_timer)
	
	recover_from_stagger_timer = Timer.new()
	recover_from_stagger_timer.wait_time = recovery_time_in_sec
	recover_from_stagger_timer.one_shot = true
	add_child(recover_from_stagger_timer)
	
	hitbox.connect("stagger_received", Callable(self, "deal_stagger_dmg"))
	recovery_timer.connect("timeout", Callable(self, "recover_tick"))
	recover_from_stagger_timer.connect("timeout", Callable(self, "recover_from_stagger"))

func _process(_delta):
	if not recover_from_stagger_timer.is_stopped():
		var percent_time_left = recover_from_stagger_timer.time_left/recover_from_stagger_timer.wait_time
		stagger_ui.update_recovery(percent_time_left) 
	update_ui()

func deal_stagger_dmg(dmg_amt: float):
	current_stagger += dmg_amt
	if current_stagger >= max_stagger:
		stagger_ui.trigger_recovery()
		is_staggered = true
		current_stagger = 0
		recover_from_stagger_timer.start()
		staggered.emit()
	elif current_stagger > 0.0:
		recovery_timer.start()
		
func recover_tick():
	current_stagger -= recovery_amt_per_tick
	current_stagger = max(current_stagger, 0.0)
	
	if current_stagger == 0.0:
		recovery_timer.stop()
	
func recover_from_stagger():
	current_stagger = 0.0
	is_staggered = false
	stagger_ui.update_recovery(100.0)
	stagger_ui.trigger_recover()
	if not recover_from_stagger_timer.is_stopped(): recover_from_stagger_timer.stop()
	recovered.emit()

func update_ui():
	if stagger_ui and stagger_ui.has_method("update_stagger"):
		stagger_ui.update_stagger(current_stagger)
		
func execution_eligible() -> bool:
	return is_staggered
