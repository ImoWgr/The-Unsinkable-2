extends CharacterBody2D

@export var speed: float = 300.0
@export var gravity: float = 500.0
@export var attack_range: float = 20.0
@export var attack_cooldown: float = 1.5

@onready var player = get_node("/root/World/Player")
@onready var anim = $AnimatedSprite2D
@onready var sight_area = $Area2D

var player_visible: bool = false
var can_attack: bool = true

func _ready():
	print("Spieler gefunden:", player)

	sight_area.body_entered.connect(_on_body_entered)
	sight_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_visible = true

func _on_body_exited(body):
	if body.name == "Player":
		player_visible = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if player_visible and player:
		var distance = global_position.distance_to(player.global_position)
		if distance <= attack_range:
			velocity.x = 0
			anim.play("attack")
			if can_attack:
				attack()
		else:
			var direction = (player.global_position - global_position).normalized()
			velocity.x = direction.x * speed
			anim.play("walk")
	else:
		velocity.x = 0
		anim.play("walk")

	move_and_slide()

func attack():
	can_attack = false
	print("Angriff!")
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
