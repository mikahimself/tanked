extends "res://scripts/state_machine.gd"

var angle_to_target = 0
var previous_angle_to_target = 0

func _ready():
	add_state("idle")
	add_state("drive_forward")
	add_state("drive_around_block")
	add_state("drive_backward")
	add_state("turn_while_idle")
	add_state("turn_right_while_blocked")
	add_state("turn_left_while_blocked")
	add_state("turn_right")
	add_state("turn_left")
	add_state("blocked")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	parent.check_distance_to_waypoint()
	parent.set_movement_velocity(state, states)
	parent.set_turn_direction(parent.get_target_direction(), state, states)
	parent._apply_rotation(delta)
	parent.check_shot_direction()

func _get_transition(delta):

	previous_angle_to_target = angle_to_target
	angle_to_target = parent.get_angle_to_target()

	match state:
		states.turn_left:
			if parent.get_front_raycast_length() < 150 and parent.is_colliding_with_tank():
				return states.blocked
			elif abs(parent.get_angle_to_target()) > 45:
				return states.turn_while_idle 
			elif parent.get_angle_to_target() > 15 or parent.get_left_raycast_length() < 100:
				return states.turn_right
			elif angle_to_target > -5 and parent.get_front_raycast_length() > 150:
				return states.drive_forward
			
		states.turn_right:
			if parent.get_front_raycast_length() < 150 and parent.is_colliding_with_tank():
				return states.blocked
			elif parent.get_angle_to_target() < -15 or parent.get_right_raycast_length() < 100:
				return states.turn_left
			elif angle_to_target < 5 and previous_angle_to_target < 5 and parent.get_front_raycast_length() > 120:
				return states.drive_forward
			
		states.idle:
			if parent.get_front_raycast_length() < 150 and parent.is_colliding_with_tank():
				if not parent.is_colliding_with_player():
					return states.blocked
			elif parent.get_angle_to_target() > 0 and not parent.is_colliding_with_tank():
				return states.turn_right
			elif parent.get_angle_to_target() < 0 and not parent.is_colliding_with_tank():
				return states.turn_left
			elif parent.is_target_in_front() and not parent.is_colliding_with_tank() and parent.get_front_raycast_length() > 150:
				return states.drive_forward
			elif parent.is_target_directly_behind():
				return states.drive_backward
			
		states.drive_forward:
			if angle_to_target > 5 and previous_angle_to_target > 15 and parent.get_right_raycast_length() > 100:
				return states.turn_right
			elif angle_to_target < -5 and previous_angle_to_target < -15 and parent.get_left_raycast_length() > 100:
				return states.turn_left
			elif parent.get_front_raycast_length() < 150:
				return states.idle
			elif not parent.is_target_in_front():
				if not parent.is_target_directly_behind():
					return states.turn_while_idle
				else:
					return states.drive_backward
		states.blocked:
			if parent.is_colliding_with_player():
				return states.idle
			elif parent.get_available_direction() == 1:
				return states.turn_right_while_blocked
			elif parent.get_available_direction() == -1:
				return states.turn_left_while_blocked

		states.turn_right_while_blocked:
			if parent.get_front_raycast_length() >= 140:
				return states.drive_around_block
		
		states.turn_left_while_blocked:
			if parent.get_front_raycast_length() >= 140:
				return states.drive_around_block

		states.drive_around_block:
			if parent.get_front_raycast_length() < 140 and parent.get_available_direction() == 1:
				return states.turn_right_while_blocked
			elif parent.get_front_raycast_length() < 140 and parent.get_available_direction() == -1:
				return states.turn_left_while_blocked
			elif parent.get_front_raycast_length() > 170:
				return states.drive_forward

		states.drive_backward:
			if not parent.is_target_directly_behind():
				return states.turn_while_idle
		states.turn_while_idle:
			if abs(parent.get_angle_to_target()) < 10 or parent.get_front_raycast_length() > 150:
				return states.drive_forward
			
		
			
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			print("IDLING")
		states.drive_forward:
			print("FORWARD")
		states.drive_backward:
			print("BACKWARD")
		states.turn_while_idle:
			print("TURN WHILE IDLE")
		states.turn_right:
			print("TURN RIGHT")
		states.turn_left:
			print("TURN LEFT")
		states.blocked:
			print("BLOCKED")
		states.turn_right_while_blocked:
			print("BLOCK TURN RIGHT")
		states.turn_left_while_blocked:
			print("BLOCK TURN LEFT")
		states.drive_around_block:
			print("DRIVE AROUND BLOCK")

func _exit_state(old_state, new_state):
	pass

	