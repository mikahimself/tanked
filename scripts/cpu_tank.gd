extends "res://scripts/base_tank.gd"

# CPU Navigation
var path: Array = []
var nav: Navigation2D = null setget set_nav
var goal: Vector2 = Vector2() setget set_goal
var forward_dir: Vector2 = Vector2()
var target_dir: Vector2 = Vector2()
var shot_dir: Vector2 = Vector2()
var no_turn_angle: int = 5

# Raycasts
onready var ray_gun: RayCast2D = get_node("raycast_container/Ray_Gun")
onready var ray_right_front_turn: RayCast2D = get_node("Ray_Right_Front_Turn")
onready var ray_left_front_turn: RayCast2D = get_node("Ray_Left_Front_Turn")
onready var ray_front: RayCast2D = get_node("Ray_Front")
onready var ray_front_right: RayCast2D = get_node("Ray_Front_Right")
onready var ray_front_left: RayCast2D = get_node("Ray_Front_Left")
onready var ray_front_right2: RayCast2D = get_node("Ray_Front_Right2")
onready var ray_front_left2: RayCast2D = get_node("Ray_Front_Left2")

onready var ray_front_1 = get_node("Ray_Front_1")
onready var ray_front_2 = get_node("Ray_Front_2")
onready var ray_front_3 = get_node("Ray_Front_3")


# CPU parametes
export (int) var seek_distance = 20
export (int) var shot_distance = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

# Set target to player
func set_goal(new_goal) -> void:
	goal = new_goal
	if (nav):
		update_path()

# Update navigation
func set_nav(new_nav) -> void:
	nav = new_nav
	update_path()

# Update path if player position changes
func update_path() -> void:
	path = nav.get_simple_path(position, goal, false)
	
	if (path.size() == 0):
		pass

# Uncomment if debug drawing is needed.
#func _process(delta):
#	update()

#func _draw():
#	if (debug):
#		draw_line(Vector2(0,0), forward_dir * 50, Color(255,0,0), 3)
#		draw_line(Vector2(0,0), target_dir * 50, Color(0,255,0), 3)
#		draw_line(Vector2(0,0), shot_dir * 175, Color(0,0,255), 3)


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

func is_front_clear() -> bool:
	if ray_front_right.is_colliding() or ray_front_left.is_colliding() or ray_front_right2.is_colliding() or ray_front_left2.is_colliding():
		return false
	else:
		return true

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

func get_left_raycast_length() -> float:
	var ray_total = 0
	var ray_length = 50

	if not ray_left_front_turn.is_colliding():
		ray_total += ray_length
	else:
		ray_total += position.distance_to(ray_left_front_turn.get_collision_point())
	
	if not ray_front_left.is_colliding():
		ray_total += ray_length
	else:
		ray_total += position.distance_to(ray_front_left.get_collision_point())

	if not ray_front_left2.is_colliding():
		ray_total += ray_length
	else:
		ray_total += position.distance_to(ray_front_left2.get_collision_point())

	return ray_total

func get_right_raycast_length() -> float:
	var ray_total = 0
	var ray_length = 50

	if not ray_right_front_turn.is_colliding():
		ray_total += ray_length
	else:
		ray_total += position.distance_to(ray_right_front_turn.get_collision_point())

	if not ray_front_right.is_colliding():
		ray_total += ray_length
	else:
		ray_total += position.distance_to(ray_front_right.get_collision_point())

	if not ray_front_right2.is_colliding():
		ray_total += ray_length
	else:
		ray_total += position.distance_to(ray_front_right2.get_collision_point())
	
	return ray_total

func get_front_raycast_length() -> float:
	var ray_total = 0
	var ray_length = 50

	if not ray_front_1.is_colliding():
		ray_total += ray_length
	else:
		ray_total += position.distance_to(ray_front_1.get_collision_point())

	if not ray_front_2.is_colliding():
		ray_total += ray_length
	else:
		ray_total += position.distance_to(ray_front_2.get_collision_point())

	if not ray_front_3.is_colliding():
		ray_total += ray_length
	else:
		ray_total += position.distance_to(ray_front_3.get_collision_point())


	return ray_total

func get_available_direction() -> int:
	if get_left_raycast_length() > get_right_raycast_length():
		return -1
	elif get_right_raycast_length() > get_left_raycast_length():
		return 1
	else:
		return 0
	

func set_turn_direction(target, state, states) -> void:
	if state == states.drive_forward or state == states.drive_backward:
		rot_dir = 0
	elif state == states.idle:
		rot_dir = target
	elif state == states.turn_right or state == states.turn_right_while_blocked:
		rot_dir = 1
	elif state == states.turn_left or state == states.turn_left_while_blocked:
		rot_dir = -1
	elif state == states.blocked or states.drive_around_block:
		rot_dir = 0
	else:
		rot_dir = target

func set_movement_velocity(state, states) -> void:
	match state:
		states.drive_forward:
			velocity = Vector2(speed_fwd, 0).rotated(rotation)
		states.drive_backward:
			velocity = Vector2(speed_rev, 0).rotated(rotation)
		states.idle:
			velocity = Vector2.ZERO
		states.blocked:
			velocity = Vector2.ZERO
		states.drive_around_block:
			velocity = Vector2(speed_fwd, 0).rotated(rotation)
		states.turn_right:
			if get_front_raycast_length() > 120:
				velocity = Vector2(speed_fwd, 0).rotated(rotation)
			else:
				velocity = Vector2.ZERO
		states.turn_left:
			if get_front_raycast_length() > 120:
				velocity = Vector2(speed_fwd, 0).rotated(rotation)
			else:
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

func is_colliding_with_player() -> bool:
	if ray_front.is_colliding():
		var body = ray_front.get_collider()
		if body.is_in_group("player"):
			return true
		else:
			return false
	else:
		return false

func check_shot_direction() -> void:
	if ray_gun.is_colliding():
		var body = ray_gun.get_collider()
		if body.is_in_group("wall"):
			pass
		elif body.is_in_group("player"):
			if can_shoot:
				shoot()
					