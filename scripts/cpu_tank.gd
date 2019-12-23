extends "res://scripts/base_tank.gd"

# CPU Navigation
var path = []
var nav: Navigation2D = null setget set_nav
var goal: Vector2 = Vector2() setget set_goal
var forward_dir: Vector2 = Vector2()
var target_dir: Vector2 = Vector2()
var shot_dir: Vector2 = Vector2()

var no_turn_angle: int = 5

# Raycasts
onready var shot_ray: RayCast2D = $gun_ray
onready var ray_r_r: RayCast2D = get_node("raycast_container/RayCast2D_RR")
onready var ray_l_r: RayCast2D = get_node("raycast_container/RayCast2D_LR")
onready var ray_forward_short_r: RayCast2D = get_node("raycast_container/RayCast2D_RB")
onready var ray_forward_short_l: RayCast2D = get_node("raycast_container/RayCast2D_LB")

# CPU parametes
export (int) var seek_distance = 20
export (int) var shot_distance = 250

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


func is_target_in_front() -> bool:
	if path.size() > 0:
		var target_dir = position.direction_to(path[0]).rotated(-rotation)
		var facing = target_dir.normalized().dot(Vector2.RIGHT)
		if (facing > 0):
			return true
		else:
			return false
	return true

func is_target_directly_behind() -> bool:
	if path.size() > 0:
		var target_dir = position.direction_to(path[0]).rotated(-rotation)
		var facing = target_dir.normalized().dot(Vector2.RIGHT)
		if facing == 1:
			return true
		else:
			return false
	return false


func get_angle_to_target() -> float:
	if path.size() > 0:
		var target_dir = position.direction_to(path[0]).rotated(-rotation)
		var angle_between = Vector2.RIGHT.angle_to(target_dir) * (180/PI)
		return angle_between
	else:
		return 0.0

func get_target_direction() -> int:
	if path.size() > 0:
		var target_dir = position.direction_to(path[0]).rotated(-rotation)
		var angle_between = Vector2.RIGHT.angle_to(target_dir) * (180/PI)
		if angle_between < -(no_turn_angle):
			return -1 # left
		elif angle_between > no_turn_angle:
			return 1 # right
		else:
			return 0
	else:
		return 0

func set_turn_direction(target, state, states):
	if state != states.turn_while_idle:
		match target:
			-1:
				if ray_forward_short_l.is_colliding():
					rot_dir = 1
				elif ray_l_r.is_colliding():
					rot_dir = 0
				else:
					rot_dir = -1
			1:
				if ray_forward_short_r.is_colliding():
					rot_dir = -1
				elif ray_r_r.is_colliding():
					rot_dir = 0
				else:
					rot_dir = 1
			0:
				rot_dir = 0
	else:
		rot_dir = target

func set_movement_velocity(state, states):
	match state:
		states.drive_forward:
			velocity = Vector2(speed_fwd, 0).rotated(rotation)
		states.drive_backward:
			velocity = Vector2(speed_rev, 0).rotated(rotation)
		states.turn_while_idle:
			velocity = Vector2.ZERO

func check_distance_to_waypoint() -> void:
	if path.size() > 0:
		var d = position.distance_to(path[0])
		if d < seek_distance:
			path.remove(0)

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