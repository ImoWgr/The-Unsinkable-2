extends PlayerBaseState
# the death state of the player

func enter(owner):
	owner.animated_sprite.play("death")
	owner.velocity.x = 0
	owner.velocity.y = 0

func exit(_owner):
	pass

func physics_process(_owner, _delta):
	pass

func _on_animated_sprite_2d_animation_finished(owner: CharacterBody2D) -> void:
	if owner.animated_sprite.animation == "death":
		print("player died")
		owner.get_tree().reload_current_scene()
