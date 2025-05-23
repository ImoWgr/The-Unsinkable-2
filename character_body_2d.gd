extends CharacterBody2D

@export var speed: float = 60.0

@onready var player = get_node("/root/World/Player") # Pfad ggf. anpassen
@onready var anim = $AnimatedSprite2D
@onready var sight_area = $Area2D

var player_visible: bool = false

func _ready():
	sight_area.body_entered.connect(_on_body_entered)
	sight_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_visible = true

func _on_body_exited(body):
	if body.name == "Player":
		player_visible = false

func _physics_process(_delta: float) -> void:
	if player_visible and player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		anim.play("walk") # Optional: Animation abspielen
	else:
		velocity = Vector2.ZERO
		anim.play("idle") # Optional: Idle-Animation

	move_and_slide()
