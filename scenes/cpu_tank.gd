extends "res://scripts/base_tank.gd"

# CPU Navigation
var path = []
var nav = null setget set_nav
var goal = Vector2() setget set_goal
var forward_dir = Vector2()
var target_dir = Vector2()
var shot_dir = Vector2()

onready var shot_ray = $gun_ray

# CPU parametes
export var seek_distance = 20
export var shot_distance = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

# Set target to player
func set_goal(new_goal):
	goal = new_goal
	if (nav):
		update_path()

# Update navigation
func set_nav(new_nav):
	nav = new_nav
	update_path()

# Update path if player position changes
func update_path():
	path = nav.get_simple_path(position, goal, false)
	
	if (path.size() == 0):
		pass

func _process(delta):
	update()

func _draw():
	if (debug):
		draw_line(Vector2(0,0), forward_dir * 50, Color(255,0,0), 3)
		draw_line(Vector2(0,0), target_dir * 50, Color(0,255,0), 3)
		draw_line(Vector2(0,0), shot_dir * 175, Color(0,0,255), 3)

func get_controls():
	rot_dir = 0
	
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
		
		if (abs(angle_between)) < 10:
			velocity = Vector2(speed_fwd, 0).rotated(rotation)
			rot_dir = 0
		elif (abs(angle_between)) > 60 and (abs(angle_between) < 120):
			velocity = Vector2(speed_fwd * 1, 0).rotated(rotation)
		elif (abs(angle_between)) >= 120:
			velocity = Vector2(speed_rev, 0).rotated(rotation)
			rot_dir = 0

		if d > seek_distance:
			pass
		else:
			path.remove(0)

func set_shot_direction():
	var d = position.distance_to(goal)
	var fd = Vector2.RIGHT
	if d < shot_distance:
		shot_dir = position.direction_to(goal).rotated(-rotation)
		
		if shot_ray.is_colliding():
			var body = shot_ray.get_collider()
			if body.is_in_group("wall"):
				print("can't see shit")
			else:
				var angle_between = fd.angle_to(shot_dir) * (180/PI)
				if (angle_between) < 0:
					rot_dir = -1
				elif (angle_between) >= 0:
					rot_dir = 1
				
				if (abs(angle_between)) < 5:
					print("shoot")
					rot_dir = 0
					velocity = Vector2(speed_fwd * 0.1, 0).rotated(rotation)
				
	
func fire_cannon():
	pass

func _physics_process(delta):
	move_and_collide(Vector2(speed_fwd * 5, 0).rotated(rotation) *  delta)
#	set_shot_direction()
