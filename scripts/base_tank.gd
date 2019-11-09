extends KinematicBody2D

# Adjustable values
export (float) var speed_fwd = 50
export (float) var speed_rev = -30
export (float) var rot_speed = 1.5
export (float) var gun_cooldown_period = 0.5

# Rotation and velocity
var rot_dir = 0
var velocity = Vector2(0,0)

# Booleans
var can_shoot = true
var is_cpu_controlled = false
export (bool) var debug = false

# Nodes
onready var shadow = $shadow
onready var shot_timer = $shot_timer


var bullet = load("res://scenes/bullet.tscn")
onready var b_cont = get_node("../bullet_container")


# Called when the node enters the scene tree for the first time.
func _ready():
	shot_timer.wait_time = gun_cooldown_period

	
func _draw():
	if debug:
		draw_debug()

func draw_debug():
	draw_line(Vector2(0,0), Vector2(speed_fwd * 60, 0), Color(255,0,0), 3)

func get_controls():
	pass

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
	if velocity != Vector2(0,0):
		var collision = move_and_collide(velocity * delta)
		if collision:
    		velocity = velocity.slide(collision.normal)
	


func _on_shot_timer_timeout():
	can_shoot = true
