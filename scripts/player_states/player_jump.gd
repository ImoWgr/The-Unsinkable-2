extends PlayerBaseState
# the jump state for the player

func enter(owner):
	# Called when the state is entered
	if Input.is_action_just_pressed("jump") and owner.is_on_floor:
		owner.animated_sprite.play("jumping")
	else:
		owner.animated_sprite.play("falling")

func exit(owner):
	owner.was_on_floor = false # cue for the landing animation (idle-state)


func physics_process(owner, _delta):
	if Input.is_action_just_pressed("jump") and owner.is_on_floor():
		owner.velocity.y = owner.JUMP_VELOCITY
		owner.is_jumping = true
	
	owner.velocity.x = owner.direction * owner.SPEED # allowing movement in the air



# checking for jumping & landing animations
func _on_animated_sprite_2d_animation_finished(owner: CharacterBody2D) -> void:
	if owner.animated_sprite.animation == "jumping":
		owner.is_jumping = false
