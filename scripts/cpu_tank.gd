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
onready var ray_gun: RayCast2D = get_node("raycast_container/Ray_Gun")
onready var ray_right_side: RayCast2D = get_node("raycast_container/Ray_Right_Side")
onready var ray_left_side: RayCast2D = get_node("raycast_container/Ray_Left_Side")
onready var ray_right_front: RayCast2D = get_node("raycast_container/Ray_Right_Front")
onready var ray_left_front: RayCast2D = get_node("raycast_container/Ray_Left_Front")
onready var ray_front: RayCast2D = get_node("Ray_Front")

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
				if ray_left_side.is_colliding() or ray_left_front.is_colliding():
					rot_dir = 1
				else:
					rot_dir = -1
			1:
				if ray_right_side.is_colliding() or ray_right_front.is_colliding():
					rot_dir = -1
				else:
					rot_dir = 1
			0:
				rot_dir = 0
	elif state == states.idle:
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
		states.idle:
			velocity = Vector2.ZERO

func check_distance_to_waypoint() -> void:
	if path.size() > 0:
		var d = position.distance_to(path[0])
		if d < seek_distance:
			path.remove(0)
			
func is_colliding_with_tank() -> bool:
	if ray_front.is_colliding():
		var body = ray_front.get_collider()
		if body.is_in_group("tank"):
			return true
		else:
			return false
	else:
		return false

func check_shot_direction():
	if ray_gun.is_colliding():
		var body = ray_gun.get_collider()
		if body.is_in_group("wall"):
			pass
		elif body.is_in_group("player"):
			if can_shoot:
				shoot()
					