extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var was_on_floor = true  # Track if player was on floor last frame
var is_jumping = false   # Track if player is in the jumping animation


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	
	if Input.is_action_just_pressed("roll"):
		pass
	
	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	
	
	
	# Play animations
	if is_on_floor():
		if not was_on_floor: #just landed
			animated_sprite.play("landing")
		elif direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	
	
	else:
		if is_jumping:
			animated_sprite.play("jumping")
		else:
			animated_sprite.play("falling")
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void: # checking for jumping & landing animations
	if animated_sprite.animation == "jumping":
		is_jumping = false
	if animated_sprite.animation == "landing":
		was_on_floor = true
