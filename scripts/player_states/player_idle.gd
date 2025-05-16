extends PlayerBaseState
# the idle state for the player

# it's there ig??
func enter(_owner):
	pass
func exit(owner):
	owner.was_on_floor = true
	owner.sword_sheathed = true

# checking if the landing animation has finished
func _on_animated_sprite_2d_animation_finished(owner: CharacterBody2D) -> void:
	if owner.animated_sprite.animation == "landing":
		owner.was_on_floor = true
	if owner.animated_sprite.animation == "sheathe_sword":
		owner.sword_sheathed = true


func physics_process(owner, _delta):
	owner.velocity.x = move_toward(owner.velocity.x, 0, owner.SPEED) # let the player come to a stop
	
	# Called when the state is entered
	if not owner.was_on_floor: # landing animation if the player is coming from a jump/fall
		owner.animated_sprite.play("landing")
	elif not owner.sword_sheathed: # sheathing animation if the player is coming from attacking (after 3 seconds)
		owner.animated_sprite.play("sheathe_sword")
	else: # actual idle animation
		owner.animated_sprite.play("idle")
