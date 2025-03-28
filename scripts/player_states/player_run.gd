extends PlayerBaseState
# the run state for the player

func enter(owner):
	owner.animated_sprite.play("run")

func exit(owner):
	owner.was_on_floor = true # preventing a overdue cue for the landing animation (idle-state)


func physics_process(owner, _delta):
	if owner.direction:
		owner.velocity.x = owner.direction * owner.SPEED
	else:
		owner.velocity.x = move_toward(owner.velocity.x, 0, owner.SPEED)
