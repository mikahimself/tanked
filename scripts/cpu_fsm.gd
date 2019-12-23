extends "res://scripts/state_machine.gd"

func _ready():
	add_state("idle")
	add_state("drive_forward")
	add_state("drive_backward")
	add_state("turn_while_idle")
	call_deferred("set_state", states.drive_forward)

func _state_logic(delta):
	parent.check_distance_to_waypoint()
	parent.set_movement_velocity(state, states)
	parent.set_turn_direction(parent.get_target_direction(), state, states)
	parent._apply_rotation(delta)
	#parent._apply_movement(delta)

func _get_transition(delta):
	match state:
		states.idle:
			if parent.velocity.normalized().dot(Vector2.RIGHT.rotated(parent.rotation)) > 0:
				return states.drive_forward
			elif parent.velocity.normalized().dot(Vector2.LEFT.rotated(parent.rotation)) > 0 :
				return states.drive_backward
		states.drive_forward:
			if not parent.is_target_in_front():
				if not parent.is_target_directly_behind():
					return states.turn_while_idle
				else:
					return states.drive_backward
		states.drive_backward:
			if not parent.is_target_directly_behind():
				return states.turn_while_idle
		states.turn_while_idle:
			if abs(parent.get_angle_to_target()) < 5:
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

func _exit_state(old_state, new_state):
	pass
