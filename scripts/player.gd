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
	
	# initial state
	change_state("STATE_IDLE")

# handeling the _animation_finished signal
func _on_animation_finished() -> void:
	if current_state and current_state.has_method("_on_animated_sprite_2d_animation_finished"):
		# forward the signal to the current state-script
		current_state._on_animated_sprite_2d_animation_finished(self)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0 # decides the speed of the player
const JUMP_VELOCITY = -300.0 # decides the jump-speed of the player

var lives = 3 # tracks the lives of the player

var was_on_floor = true  # tracks if the player was on the floor
var is_jumping = false   # tracks if the player is in the jumping animation
var direction = 0 # tracks the input direction
var is_rolling = false # tracks if the player is rolling

# states stuff
var current_state = null
var states = {}
func change_state(new_state_name: String) -> void:
	if current_state:
		current_state.exit(self)
	current_state = states[new_state_name]
	current_state.enter(self)



func _physics_process(delta: float) -> void:
	# Add the gravity.

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction: -1, 0, 1
	direction = Input.get_axis("move_left", "move_right")
	
	# universal state changes; manages movement & death
	if lives > 0:
		if not is_rolling:
			if is_on_floor():
				if direction != 0 and current_state != states["STATE_RUN"]:
					change_state("STATE_RUN")
				elif Input.is_action_just_pressed("jump") and current_state != states["STATE_JUMP"]:
					change_state("STATE_JUMP")
				elif direction == 0 and current_state != states["STATE_IDLE"]:
					change_state("STATE_IDLE")
				elif Input.is_action_just_pressed("roll") and direction != 0:
					change_state("STATE_ROLL")
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
	if lives:
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
	
	
	#print(current_state)
	move_and_slide()
