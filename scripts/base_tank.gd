extends KinematicBody2D

var speed = 0.75
var rot_speed = 1.5
var rot_dir = 0
var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_controls():
	rot_dir = 0
	velocity = Vector2(0,0)

	if Input.is_action_pressed("left"):
		rot_dir = -1
	elif Input.is_action_pressed("right"):
		rot_dir = 1
	if Input.is_action_pressed("forward"):
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_pressed("back"):
		velocity = Vector2(-speed * 0.75, 0).rotated(rotation)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_controls()
	rotation += rot_dir * rot_speed * delta
	move_and_collide(velocity)
	
