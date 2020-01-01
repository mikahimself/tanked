extends "res://scripts/state_machine.gd"

func _ready():
	add_state("idle")
	add_state("drive_forward")
	add_state("drive_backward")
	add_state("turn")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	parent.get_controls()
	parent._apply_rotation(delta)

func _get_transition(delta):
	match state:
		states.idle:
			if parent.velocity.normalized().dot(Vector2.RIGHT.rotated(parent.rotation)) > 0:
				return states.drive_forward
			elif parent.velocity.normalized().dot(Vector2.LEFT.rotated(parent.rotation)) > 0 :
				return states.drive_backward
		states.drive_forward:
			if parent.velocity.normalized().dot(Vector2.LEFT.rotated(parent.rotation)) > 0:
				return states.drive_backward
			elif parent.velocity.length() == 0:
				return states.idle
		states.drive_backward:
			if parent.velocity.normalized().dot(Vector2.RIGHT.rotated(parent.rotation)) > 0:
				return states.drive_forward
			elif parent.velocity.length() == 0:
				return states.idle
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
