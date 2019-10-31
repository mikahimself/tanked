extends KinematicBody2D

var speed = 1
var nav = null setget set_nav
var path = []
var goal = Vector2()
var rot_dir = 0
var rot_speed = 1.25
var engine_power = 40
var setcourse = true
onready var timer = get_node("Timer")

var forward_dir = Vector2()
var target_dir = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

func set_nav(new_nav):
	nav = new_nav
	update_path()

func update_path():
	print("update")
	path = nav.get_simple_path(position, goal, false)
	
	if (path.size() == 0):
		print("zero")

func _process(delta):
	update()

func _draw():
	draw_line(Vector2(0,0), forward_dir * 50, Color(255,0,0), 3)
	draw_line(Vector2(0,0), target_dir * 50, Color(0,255,0), 3)

func drive(delta):
	rot_dir = 0
	
	speed = 0.01
	setcourse = true
	

	if (path.size() > 1):
		# what's the distance to the next waypoint
		var d = position.distance_to(path[0])
		
		# Forward direction is in relation to object's orientation
		forward_dir = Vector2.RIGHT
		# Target dir seems to come through negative rotation
		target_dir = position.direction_to(path[0]).rotated(-rotation)

		var angle_between = forward_dir.angle_to(target_dir) * (180/PI)

		if (angle_between) < 0:
			rot_dir = -1
		if (angle_between) >= 0:
			rot_dir = 1
		

		if target_dir.dot(forward_dir) > 0.998:
			speed = 1
			rot_dir = 0

		if d > 10:
			pass #position = position.linear_interpolate(path[0], speed * delta / d )
		else:
			path.remove(0)

func _physics_process(delta):
	drive(delta)
	rotation += rot_dir * rot_speed * delta
	#set_applied_force(Vector2(speed * engine_power, 0).rotated(rotation))
	move_and_collide(Vector2(speed * engine_power, 0).rotated(rotation) *  delta)

func _on_Timer_timeout():
	setcourse = true
	print("timeout")