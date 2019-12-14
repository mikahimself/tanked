extends "res://scripts/base_tank.gd"

# Get input from player
func get_controls():
	rot_dir = 0
	velocity = Vector2(0,0)

	if Input.is_action_pressed("left"):
		rot_dir = -1
		
	if Input.is_action_pressed("right"):
		rot_dir = 1
		
	if Input.is_action_pressed("forward"):
		velocity = Vector2(speed_fwd, 0).rotated(rotation)
		
	if Input.is_action_pressed("back"):
		velocity = Vector2(speed_rev, 0).rotated(rotation)
	
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		var b = bullet.instance()
		b_cont.add_child(b)
		shot_timer.start()
		b.start(global_position + Vector2(30,0).rotated(rotation), Vector2(1, 0).rotated(rotation))