extends "res://scripts/base_tank.gd"

# CPU Navigation
var path = []
var nav = null setget set_nav
var goal = Vector2() setget set_goal
var forward_dir = Vector2()
var target_dir = Vector2()
var shot_dir = Vector2()

export (float) var reaction_distance = 150
export (float) var min_dist_to_player = 50
export (float) var spd_mult_slow = 0.05
export (float) var spd_mult_medium = 0.5
export (float) var spd_mult_fast = 0.75
export (int) var min_turn_angle = 45
export (int) var max_turn_angle = 65

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

	var distance_to_player = position.distance_to(goal)
	
	#if (path.size() >= 3):
	if (distance_to_player >= min_dist_to_player):
		# Distance to the next waypoint and player
		var d = position.distance_to(path[0])
		
		# Forward direction is in relation to object's orientation
		forward_dir = Vector2.RIGHT
		# Target dir seems to come through negative rotation
		target_dir = position.direction_to(path[0]).rotated(-rotation)
		
		# Angle between target dir and current dir
		var angle_between = forward_dir.angle_to(target_dir) * (180/PI)

		# Choose where to turn
		if angle_between < -5:
			rot_dir = -1
		elif angle_between >= 5:
			rot_dir = 1
		
		# Set speed
		velocity = Vector2(speed_fwd, 0).rotated(rotation)
		
		if abs(angle_between) > min_turn_angle and abs(angle_between) <= max_turn_angle:
			velocity = Vector2(speed_fwd, 0).rotated(rotation) * spd_mult_slow
		elif abs(angle_between) > max_turn_angle:
			velocity = Vector2(speed_rev, 0).rotated(rotation)

		# Slow down when player is close
		if distance_to_player < reaction_distance:
			velocity = velocity * spd_mult_fast

		# Jump to next waypoint if close enough to current
		if d < seek_distance:
			path.remove(0)
	else:
		velocity = Vector2(0, 0)

func set_shot_direction():
	var d = position.distance_to(goal)
	var fd = Vector2.RIGHT
	if d < shot_distance:
		shot_dir = position.direction_to(goal).rotated(-rotation)
		
		if shot_ray.is_colliding():
			var body = shot_ray.get_collider()
			if body.is_in_group("wall"):
				pass
				#print("can't see shit")
			else:
				var angle_between = fd.angle_to(shot_dir) * (180/PI)
				if (angle_between) < 0:
					rot_dir = -1
				elif (angle_between) >= 0:
					rot_dir = 1
				
				if (abs(angle_between)) < 5:
				#	print("shoot")
					rot_dir = 0
					velocity = Vector2(speed_fwd * 0.1, 0).rotated(rotation)
				
	
func fire_cannon():
	pass

func _physics_process(delta):
	set_shot_direction()
