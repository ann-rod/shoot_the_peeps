extends Area2D
signal hit
signal player_fired_jet(jet, pos, dir)

export (PackedScene) var WaterJet
export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
onready var jet_origin_up = $JetOriginUp
onready var jet_origin_down = $JetOriginDown
onready var attack_cooldown = $AttackCooldown
var player_y_direction = -1 # player is facing up the screen

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's moevement vector
	#if Input.is_action_pressed("move_right"):
	#	velocity.x += 1
	#if Input.is_action_pressed("move_left"):
	#	velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		player_y_direction = 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		player_y_direction = -1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.y > 0:
		$AnimatedSprite.animation = "down"
		$AnimatedSprite.flip_v = false
	elif velocity.y <= 0:
		$AnimatedSprite.animation = "up"

func _on_Player_body_entered(body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		shoot()

func shoot():
	if(attack_cooldown.is_stopped()):
		var jet_instance = WaterJet.instance()
		var jet_pos = jet_origin_up.global_position if(player_y_direction < 0) else jet_origin_down.global_position
		emit_signal("player_fired_jet", jet_instance, jet_pos, player_y_direction)
		attack_cooldown.start()
	else:
		pass

