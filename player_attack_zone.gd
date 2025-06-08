extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.lose_lives(1)
	print("PlayerAttackZone: player has hit enemy")
	
