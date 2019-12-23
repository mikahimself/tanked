extends Area2D

var speed = 250
var damage = 5
var velocity = Vector2()
var explosion_scene = load("res://scenes/Explosion.tscn")
var explosion

func _ready():
	explosion = explosion_scene.instance()
	explosion.get_node("AnimationPlayer").connect("animation_finished", self, "_on_anim_finished")
	add_child(explosion)

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed

func _process(delta):
	position += velocity * delta

func _on_Area2D_body_entered(body):
	velocity = Vector2.ZERO
	explosion.visible = true
	get_node("Sprite").visible = false
	rotation_degrees = 0
	explosion.get_node("AnimationPlayer").play("Explosion")
	
func _on_anim_finished(anim_name):
	queue_free()
