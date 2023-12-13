class_name PlayerDetector
extends Area2D

signal player_entered(player)
signal player_exited()

func _init():
	collision_layer = 0
	collision_mask = 4
	
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
func _on_body_entered(player: Player):
	if player:
		player_entered.emit(player)
		
func _on_body_exited(player: Player):
	if player:
		player_exited.emit()
