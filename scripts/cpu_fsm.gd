extends "res://scripts/state_machine.gd"

var angle_to_target = 0
var front_min_distance: float = 100.0
var front_clear_distance: float = 150.0
var side_clear_distance: float = 100.0
var turn_angle: float = 5.0
var turn_angle_front: float = 10.0
var turn_idle_angle: float = 60.0

func _ready():
	add_state("idle")
	add_state("drive_forward")
	add_state("drive_around_block")
	add_state("drive_backward")
	add_state("turn_right_while_blocked")
	add_state("turn_left_while_blocked")
	add_state("turn_right")
	add_state("turn_left")
	add_state("aim")
	add_state("blocked")
	add_state("dead")
	call_deferred("set_state", states.idle)

func _state_logic(delta) -> void:
	if state != states.dead:
		parent.check_distance_to_waypoint()
		parent.set_movement_velocity(state, states)
		parent.set_turn_direction(parent.get_target_direction(), state, states)
		parent._apply_rotation(delta)
		parent.check_shot_direction()

# How/When to transition
func _get_transition(delta):
	
	if not parent.check_if_alive():
		return states.dead

	angle_to_target = parent.get_angle_to_target()

	match state:
		states.turn_left:
			if parent.get_distance_to_target() < 30 and parent.is_line_to_target:
				return states.aim
			elif parent.get_front_raycast_length() < front_clear_distance and parent.is_colliding_with_tank():
				return states.blocked
			elif abs(angle_to_target) > turn_idle_angle:
				return states.idle
			elif angle_to_target > turn_angle_front or parent.get_left_raycast_length() < side_clear_distance:
				return states.turn_right
			elif angle_to_target > -(turn_angle):
				return states.drive_forward
			
		states.turn_right:
			if parent.get_distance_to_target() < 30 and parent.is_line_to_target:
				return states.aim
			elif parent.get_front_raycast_length() < front_clear_distance and parent.is_colliding_with_tank():
				return states.blocked
			elif abs(angle_to_target) > turn_idle_angle:
				return states.idle
			elif angle_to_target < -(turn_angle_front) or parent.get_right_raycast_length() < side_clear_distance:
				return states.turn_left
			elif angle_to_target < turn_angle:
				return states.drive_forward
			
		states.idle:
			if parent.get_distance_to_target() < 30 and parent.is_line_to_target:
				return states.aim
			if parent.get_front_raycast_length() < front_clear_distance and parent.is_colliding_with_tank():
				if not parent.is_colliding_with_player():
					return states.blocked
			elif angle_to_target > 0 and not parent.is_colliding_with_tank() and parent.get_front_raycast_length() > front_min_distance:
				return states.turn_right
			elif angle_to_target < 0 and not parent.is_colliding_with_tank() and parent.get_front_raycast_length() > front_min_distance:
				return states.turn_left
			elif parent.is_target_in_front() and not parent.is_colliding_with_tank() and parent.get_front_raycast_length() >= front_clear_distance:
				return states.drive_forward
			elif parent.is_target_directly_behind():
				return states.drive_backward
			
		states.drive_forward:
			if parent.get_distance_to_target() < 30 and parent.is_line_to_target:
				return states.aim
			elif angle_to_target > turn_angle_front and parent.get_right_raycast_length() > side_clear_distance:
				return states.turn_right
			elif angle_to_target < -(turn_angle_front) and parent.get_left_raycast_length() > side_clear_distance:
				return states.turn_left
			elif parent.get_front_raycast_length() < front_clear_distance:
				return states.idle

		states.aim:
			if parent.get_distance_to_target() >= 30:
				return states.idle

		states.blocked:
			if parent.is_colliding_with_player():
				return states.idle
			elif parent.get_available_direction() == 1:
				return states.turn_right_while_blocked
			elif parent.get_available_direction() == -1:
				return states.turn_left_while_blocked

		states.turn_right_while_blocked:
			if parent.get_front_raycast_length() >= 160:
				return states.drive_around_block
		
		states.turn_left_while_blocked:
			if parent.get_front_raycast_length() >= 160:
				return states.drive_around_block

		states.drive_around_block:
			if parent.get_front_raycast_length() < 160 and parent.get_available_direction() == 1:
				return states.turn_right_while_blocked
			elif parent.get_front_raycast_length() < 160 and parent.get_available_direction() == -1:
				return states.turn_left_while_blocked
			elif parent.get_front_raycast_length() > 170:
				return states.drive_forward

		states.drive_backward:
			if not parent.is_target_directly_behind():
				return states.idle
			
	return null

# What do when entering a state. Use match.
func _enter_state(new_state, old_state) -> void:
	match new_state:
		states.drive_forward:
			parent.play_engine_running()
		states.dead:
			parent.stop_engine_running()
	
# What do when exiting a state. Use match.
func _exit_state(old_state, new_state) -> void:
	pass

	