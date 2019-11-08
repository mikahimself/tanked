extends KinematicBody2D

export (bool) var debug = false
var speed_fwd = 0.75
var speed_rev = 0.45
var rot_speed = 1.5
var rot_dir = 0
var reverse_mult = 0.6
var velocity = Vector2(0,0)
var cooldown = 0.5


var bullet = load("res://scenes/bullet.tscn")

var can_shoot = true

onready var b_cont = get_node("../bullet_container")
onready var shadow = $shadow
onready var shot_timer = $shot_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_timer.wait_time = cooldown


	
func _draw():
	if debug:
		draw_line(Vector2(0,0), Vector2(speed_fwd * 60, 0), Color(255,0,0), 3)

func get_controls():
	rot_dir = 0
	velocity = Vector2(0,0)

	if Input.is_action_pressed("left"):
		rot_dir = -1
	elif Input.is_action_pressed("right"):
		rot_dir = 1
	if Input.is_action_pressed("forward"):
		velocity = Vector2(speed_fwd, 0).rotated(rotation)
	if Input.is_action_pressed("back"):
		velocity = Vector2(-speed_rev, 0).rotated(rotation)
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		var b = bullet.instance()
		b_cont.add_child(b)
		shot_timer.start()
		b.start(global_position + Vector2(30,0).rotated(rotation), Vector2(1, 0).rotated(rotation))


func _process(delta):
	offset_shadow()
	update()

func offset_shadow():
	shadow.position = Vector2(4,4).rotated(-rotation)
	
func set_my_rotation(delta):
	rotation += rot_dir * rot_speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_controls()
	set_my_rotation(delta)
	
	move_and_collide(velocity)
	


func _on_shot_timer_timeout():
	can_shoot = true
