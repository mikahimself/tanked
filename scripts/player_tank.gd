extends "res://scripts/base_tank.gd"

# Get input from player
func get_controls():
	rot_dir = 0
	velocity = Vector2(0,0)

	if Input.is_action_pressed("left_%s" % my_id):
		rot_dir = -1
		
	if Input.is_action_pressed("right_%s" % my_id):
		rot_dir = 1
		
	if Input.is_action_pressed("forward_%s" % my_id):
		velocity = Vector2(speed_fwd, 0).rotated(rotation)
		
	if Input.is_action_pressed("back_%s" % my_id):
		velocity = Vector2(speed_rev, 0).rotated(rotation)
	
	if Input.is_action_pressed("shoot_%s" % my_id) and can_shoot:
		shoot()
