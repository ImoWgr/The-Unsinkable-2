extends PlayerBaseState
# the attack state of the player

const ATTACK_TIMEOUT = 3.0 # how long until the player sheathes their weapon
var time_since_attack = 0.0 # timer to track how much time passed since the last attack 


# Called when the state is entered.
func enter(owner):
	owner.animated_sprite.play("attack_up")
	owner.attack_stage = 1

# Called when the state is exited.
func exit(owner):
	owner.attack_stage = 0

# Called every physics frame while this state is active.
func physics_process(owner, delta):
	time_since_attack += delta # advance the timeout for the sheathing
	
	if time_since_attack == ATTACK_TIMEOUT:
		owner.animated_sprite.play("sheathe_sword")
		exit(self)
	elif Input.is_action_just_pressed("attack"):
		if owner.attack_stage == 1:
			owner.animated_sprite.play("attack_down")
			owner.attack_stage = 2
		elif owner.attack_stage == 2:
			owner.animated_sprite.play("attack_stab")
			owner.attack_stage = 1
		else:
			owner.animated_sprite.play("attack_up")
