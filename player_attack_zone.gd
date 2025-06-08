extends Area2D

func _on_body_entered(body: Node2D) -> void: # if the player enters the death zone, it should subtract one life from the player
	if self.is_processing():
		print("attack_zone enabled")
		body.lose_lives(1)
		print("PlayerAttackZone: player has hit enemy")
	
