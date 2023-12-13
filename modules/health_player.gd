class_name PlayerHealth
extends Health

func take_damage(_dmg_amt):
	print("Player Damaged!")
	
	if current_health < 1.0:
		current_health = 0
		killed.emit()
	else:
		current_health -= (1.0 + (current_health - int(current_health)))
		damaged.emit(1.0)
		
	update_ui()
