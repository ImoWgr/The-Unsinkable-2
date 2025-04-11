extends PlayerBaseState
# the death state of the player

func enter(owner):
	owner.animated_sprite.play("death")

func exit(_owner):
	pass

func physics_process(_owner, _delta):
	pass
