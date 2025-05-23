extends AnimatedSprite2D

# Geschwindigkeit des Gegners
var speed = 100
# Bewegungsrichtung des Gegners
var direction = Vector2.RIGHT
# Angriffsdistanz
var attack_distance = 100

# Referenz für das Ziel (z. B. der Spieler)
var target: Node2D = null

func _ready():
	# Die Standardanimation starten
	play("EyeDefault")
	# Ziel finden (ersetze 'Player' durch den tatsächlichen Node-Namen deines Ziels)
	target = get_node_or_null("../Player")

func _process(delta):
	# Bewegung
	position += direction * speed * delta

	# Richtung ändern, wenn eine Kollision erkannt wird
	if position.x < 0 or position.x > get_viewport_rect().size.x:
		direction.x = -direction.x

	# Angriffslogik prüfen
	if target:
		var distance = position.distance_to(target.position)
		if distance <= attack_distance:
			# Angriffsanimation abspielen
			play("EyeAttack")
		else:
			# Standardanimation abspielen
			play("EyeDefault")
