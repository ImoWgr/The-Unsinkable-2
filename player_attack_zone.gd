extends Area2D
var enemies_in_range := []

func _on_body_entered(body: Node2D) -> void:
	enemies_in_range.append(body)
	print("PlayerAttackZone: enemy in reach")
	print(enemies_in_range)

func _on_body_exited(body: Node2D) -> void:
	enemies_in_range.erase(body)
	print("PlayerAttackZone: enemy escaped reach")
	print(enemies_in_range)

func _on_player_attack() -> void:
	enemies_in_range = enemies_in_range.filter(is_instance_valid)
	for enemy in enemies_in_range:
			if enemy and enemy.has_method("lose_lives"):
				enemy.lose_lives(1)
				print(enemy, "yuh")
