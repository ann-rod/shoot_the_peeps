extends RigidBody2D

func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _process(delta):
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func handle_hit():
	queue_free()
