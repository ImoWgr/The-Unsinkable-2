extends Area2D

func _on_body_entered(body: Node2D) -> void: # if the player enters the death zone, it should subtract one life from the player
	body.lose_life()
	print("PlayerDeathZone: player lost a life")
