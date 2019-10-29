extends Area2D

var speed = 250
var damage = 5
var velocity = Vector2()

func _ready():
	pass # Replace with function body.

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed

func _process(delta):
	position += velocity * delta
	


func _on_Area2D_body_entered(body):
	queue_free()
