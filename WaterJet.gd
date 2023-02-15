extends Area2D

export (int) var speed = 8;
onready var kill_timer = $KillTimer
var direction = 0

func _ready():
	kill_timer.start()

func _physics_process(delta):
	if direction != 0:
		var velocity = direction * speed
		global_position.y += velocity

func set_direction(direction):
	self.direction = direction

func _on_KillTimer_timeout():
	queue_free()

func _on_WaterJet_body_entered(body):
	if(body.has_method("handle_hit")):
		body.handle_hit()
		queue_free()
