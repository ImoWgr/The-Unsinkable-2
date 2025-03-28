extends PlayerBaseState
# the idle state for the player

# it's there ig??
func enter(_owner):
	pass
func exit(_owner):
	pass

# checking if the landing animation has finished
func _on_animated_sprite_2d_animation_finished(owner: CharacterBody2D) -> void:
	if owner.animated_sprite.animation == "landing":
		owner.was_on_floor = true


func physics_process(owner, _delta):
	owner.velocity.x = move_toward(owner.velocity.x, 0, owner.SPEED) # let the player come to a stop
	
	# Called when the state is entered
	if not owner.was_on_floor: # landing animation if the player is coming from a jump/fall
		owner.animated_sprite.play("landing")
	else: # actual idle animation
		owner.animated_sprite.play("idle")
