extends Area2D

var speed: int = 250
export (int) var damage = 5
var velocity: Vector2 = Vector2()
var explosion_scene: PackedScene = load("res://scenes/explosion.tscn")
var explosion: AnimationPlayer
onready var audio_explosion: AudioStreamPlayer = $AudioExplosion

func _ready():
	explosion = explosion_scene.instance()
	explosion.get_node("AnimationPlayer").connect("animation_finished", self, "_on_anim_finished")
	add_child(explosion)

func start(_position, _direction) -> void:
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed

func _process(delta):
	position += velocity * delta

func _on_Area2D_body_entered(body) -> void:
	velocity = Vector2.ZERO
	if body.is_in_group("tank"):
		position = body.position
		body.damage(damage)
	explosion.visible = true
	get_node("Sprite").visible = false
	rotation_degrees = 0
	audio_explosion.play()
	explosion.get_node("AnimationPlayer").play("Explosion")
	
func _on_anim_finished(anim_name) -> void:
	queue_free()
