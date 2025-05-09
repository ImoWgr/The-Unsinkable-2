extends PlayerBaseState
# the attack state of the player

const ATTACK_TIMEOUT = 3.0 # how long until the player sheathes their weapon
var time_since_attack = 0.0 # timer to track how much time passed since the last attack 


# Called when the state is entered.
func enter(owner):
	owner.animated_sprite.play("attack_up")
	owner.sword_attack_stage = 1

# Called when the state is exited.
func exit(owner):
	owner.sword_attack_stage = 0

# Called every physics frame while this state is active.
func physics_process(owner, delta):
	# advance the timeout for the sheathing
	time_since_attack += delta
	print(time_since_attack)
	# if enough time has passed since last attack, exit state & mark that the sword is unsheathed
	if time_since_attack > ATTACK_TIMEOUT:
		owner.sword_sheathed = false
		owner.change_state("STATE_IDLE")
	# hande the different attack animations once the player attacks again
	elif Input.is_action_just_pressed("attack"):
		if owner.sword_attack_stage == 1:
			owner.animated_sprite.play("attack_down")
			owner.sword_attack_stage = 2
		elif owner.sword_attack_stage == 2:
			owner.animated_sprite.play("attack_stab")
			owner.sword_attack_stage = 1
		else:
			owner.animated_sprite.play("attack_up")
