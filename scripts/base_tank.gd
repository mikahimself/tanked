extends KinematicBody2D

# Adjustable values
export (float) var speed_fwd = 50
export (float) var speed_rev = -30
export (float) var rot_speed = 1.5
export (float) var gun_cooldown_period = 0.5
export (float) var max_health = 100
onready var health = max_health setget _set_health

# Rotation and velocity
var rot_dir: int = 0
var velocity: Vector2 = Vector2(0,0)
var shadow_offset: Vector2 = Vector2(2, 2)
var bullet_offset: Vector2 = Vector2(10, 0)
var bullet_dir: Vector2 = Vector2(1, 0)

# Booleans
var can_shoot: bool = true
var is_cpu: bool = false
export (bool) var debug = false

# Nodes
onready var shadow = $shadow
onready var shot_timer = $ShotTimer
onready var invulnerable_timer = $InvulnerableTimer
onready var audio_shoot = $Audio_Shoot
onready var effect_animation = $EffectAnimation

# Identifiers
var my_id: int = 0

# Signals
signal shot_bullet(bullet_position, bullet_direction)
signal health_updated(health)
signal killed()

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_timer.wait_time = gun_cooldown_period

func _draw():
	if debug:
		draw_debug()

func draw_debug():
	draw_line(Vector2(0,0), Vector2(speed_fwd * 60, 0), Color(255,0,0), 3)

func get_controls() -> void:
	pass

func _process(delta):
	offset_shadow()
	update()

func offset_shadow() -> void:
	shadow.position = shadow_offset.rotated(-rotation)
	
func _apply_rotation(delta) -> void:
	rotation += rot_dir * rot_speed * delta

func _apply_movement(delta) -> void:
	if velocity != Vector2(0,0):
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.slide(collision.normal)

func aim():
	pass

func damage(amount):
	if invulnerable_timer.is_stopped():
		invulnerable_timer.start()
		_set_health(health - amount)
		effect_animation.play("Damage")
		effect_animation.queue("Invulnerable")
		

func kill_tank():
	print("Killed")

func _set_health(value):
	var previous_health = health
	health = clamp(value, 0, max_health)
	if health != previous_health:
		emit_signal("health_updated", health)

	if health == 0:
		kill_tank()
		emit_signal("killed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_cpu:
		aim()
	_apply_movement(delta)

func shoot() -> void:
	can_shoot = false
	var bullet_pos = global_position + bullet_offset.rotated(rotation)
	var bullet_dir_now = bullet_dir.rotated(rotation)
	shot_timer.start()
	emit_signal("shot_bullet", bullet_pos, bullet_dir_now)
	audio_shoot.play()
	
func _on_shot_timer_timeout() -> void:
	can_shoot = true


func _on_InvulnerableTimer_timeout():
	effect_animation.play("Normal")
