extends PlayerBaseState
# the roll state for the player

func enter(owner):
	owner.animated_sprite.play("roll")
	owner.is_rolling = true


func exit(owner):
	owner.was_on_floor = true # preventing a overdue cue for the landing animation (idle-state)
	owner.is_rolling = false # marking the roll as over in any unforseen cases

func physics_process(owner, _delta):
	if not owner.is_rolling:
		owner.change_state("STATE_IDLE")

# marking if the roll is over
func _on_animated_sprite_2d_animation_finished(owner: CharacterBody2D) -> void:
	if owner.animated_sprite.animation == "roll":
		owner.is_rolling = false
