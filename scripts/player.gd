extends CharacterBody2D

func _ready():
	# connecting the animation_finished signal to a method in this script; to allow its usage in the state-scripts
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	# inatializing states
	states["STATE_IDLE"] = preload("res://scripts/player_states/player_idle.gd").new()
	states["STATE_RUN"] = preload("res://scripts/player_states/player_run.gd").new()
	states["STATE_JUMP"] = preload("res://scripts/player_states/player_jump.gd").new()
	states["STATE_ROLL"] = preload("res://scripts/player_states/player_roll.gd").new()
	states["STATE_DEATH"] = preload("res://scripts/player_states/player_death.gd").new()
	states["STATE_ATTACK"] = preload("res://scripts/player_states/player_attack.gd").new()
	
	# initial state
	change_state("STATE_IDLE")
	
	#var AttackZone = $PlayerAttackZone # calls on the Player Attack Zone
	#AttackZone.set_process(false) # disables the Attack Zone (the default state)
@onready var AttackZone = $PlayerAttackZone


# handeling the _animation_finished signal
func _on_animation_finished() -> void:
	if current_state and current_state.has_method("_on_animated_sprite_2d_animation_finished"):
		# forward the signal to the current state-script
		current_state._on_animated_sprite_2d_animation_finished(self)

# handeling the death_timer signal
func on_death_timer_timeout() -> void:
	if current_state and current_state.has_method("on_death_timer_timeout"):
		# forward the signal to the current state-script
		current_state.on_death_timer_timeout(self)

# @onready var death_timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0 # decides the speed of the player
const JUMP_VELOCITY = -300.0 # decides the jump-speed of the player

var lives = 3 # tracks the lives of the player


var was_on_floor = true  # tracks if the player was on the floor
var is_jumping = false   # tracks if the player is in the jumping animation
var direction = 0 # tracks the input direction
var is_rolling = false # tracks if the player is rolling
var sword_attack_stage = 0 # tracks on which attack stage the player is for the 3 different attacks
var sword_sheathed = true

# states stuff
var current_state = null
var states = {}
func change_state(new_state_name: String) -> void:
	if current_state:
		current_state.exit(self)
	current_state = states[new_state_name]
	current_state.enter(self)
	#print(current_state)


func lose_lives(subtracted_lives) -> void:
	lives -= subtracted_lives
	print("remaining lives: ", lives)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if Input.is_action_just_pressed("kill_player"):
		lives = 0
	
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction: -1, 0, 1
	direction = Input.get_axis("move_left", "move_right")
	
	# universal state changes; manages movement, attacking, and death
	if lives > 0:
		if not is_rolling:
			if is_on_floor():
				if direction != 0 and current_state != states["STATE_RUN"]:
					change_state("STATE_RUN")
				elif Input.is_action_just_pressed("jump") and current_state != states["STATE_JUMP"]:
					change_state("STATE_JUMP")
				elif direction == 0 and current_state != states["STATE_IDLE"] and current_state != states["STATE_ATTACK"]:
					change_state("STATE_IDLE")
				elif Input.is_action_just_pressed("roll") and direction != 0:
					change_state("STATE_ROLL")
				elif Input.is_action_just_pressed("attack") and current_state != states["STATE_ATTACK"]:
					change_state("STATE_ATTACK")
				else:
					pass
			elif current_state != states["STATE_JUMP"]:
				change_state("STATE_JUMP")
			else:
				pass
		else:
			pass
	elif current_state != states["STATE_DEATH"]:
		change_state("STATE_DEATH")
	else:
		pass
	
	# calling the physics_process of the current state (to execute it)
	if current_state and current_state.has_method("physics_process"): 
		current_state.physics_process(self, delta)

	
	# Flip the Sprite
	if lives > 0:
		if direction > 0:
			animated_sprite.flip_h = false
			AttackZone.rotation_degrees = 0
			AttackZone.y.scale = 0
		elif direction < 0:
			animated_sprite.flip_h = true
			AttackZone.rotation_degrees = 180
			AttackZone.y.scale = -1
	
	#print(current_state)
	move_and_slide()
