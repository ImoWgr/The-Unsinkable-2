extends PlayerBaseState
# the attack state of the player

const ATTACK_TIMEOUT = 2.0 # how long until the player sheathes their weapon
const ATTACK_FINISHED = 0.75
var time_since_attack = 0.0 # timer to track how much time passed since the last attack 


# plays initial (first) attack animation
func enter(owner):
	owner.animated_sprite.play("attack_up")
	owner.sword_attack_stage = 1
	

# resets the attack stage
func exit(owner):
	owner.sword_attack_stage = 0


func physics_process(owner, delta):
	# advance the timeout for the sheathing
	time_since_attack += delta
	#print(time_since_attack)
	# if enough time has passed since last attack, exit state & mark that the sword is unsheathed
	if time_since_attack > ATTACK_TIMEOUT:
		owner.sword_sheathed = false
		owner.change_state("STATE_IDLE")
		time_since_attack = 0.0
	# hande the different attack animations once the player attacks again
	elif Input.is_action_just_pressed("attack"):
		if owner.sword_attack_stage == 1: # second attack type
			owner.animated_sprite.play("attack_down")
			owner.sword_attack_stage = 2
			time_since_attack = 0.0
		elif owner.sword_attack_stage == 2: # third attack type
			owner.animated_sprite.play("attack_stab")
			owner.sword_attack_stage = 1
			time_since_attack = 0.0
		else:
			owner.animated_sprite.play("attack_up") # first attack type
			time_since_attack = 0.0
	
	if time_since_attack > ATTACK_FINISHED:
		owner.attack_zone.set_process(true)
	else:
		owner.attack_zone.set_process(false)
	
	
