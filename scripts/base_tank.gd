extends KinematicBody2D

# Adjustable values
export (float) var acceleration = 0.1
export (float) var deceleration = 0.5
export (float) var speed_fwd_max = 50
export (float) var speed_fwd = 0
export (float) var speed_rev_max = -30
export (float) var speed_rev = -30
export (float) var rot_speed = 1.5
export (float) var shot_period = 0.5
export (float) var invulnerability_period = 1.0
export (int) var max_health = 100
onready var health: int = max_health setget _set_health

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
onready var shadow: Sprite = $shadow
onready var shot_timer: Timer = $ShotTimer
onready var invulnerability_timer: Timer = $InvulnerabilityTimer
onready var effect_animation: AnimationPlayer = $EffectAnimation
onready var audio_engine = $AudioEngine
onready var audio_shot = $AudioShot

# Identifiers
var my_id: int = 0

# Sound related
var min_pitch: float = 0.3
var max_pitch: float = 9.5
var min_percentage: float = 0.3
var max_percentage: float = 1.0

# Signals
signal shot_bullet(bullet_position, bullet_direction)
signal health_updated(health)
signal killed()

# Called when the node enters the scene tree for the first time.
func _ready():
	shot_timer.wait_time = shot_period
	invulnerability_timer.wait_time = invulnerability_period

func _draw():
	if debug:
		draw_debug()

func draw_debug():
	draw_line(Vector2(0,0), Vector2(speed_fwd * 60, 0), Color(255,0,0), 3)

func get_controls() -> void:
	pass

func _process(delta):
	offset_shadow()
	set_engine_pitch()
	set_track_particles()
	update()

func check_if_alive() -> bool:
	if health == 0:
		return false
	else:
		return true

func offset_shadow() -> void:
	shadow.position = shadow_offset.rotated(-rotation)
	
func _apply_rotation(delta) -> void:
	rotation += rot_dir * rot_speed * delta

func _apply_movement(delta) -> void:
	if velocity != Vector2(0,0):
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.slide(collision.normal)

func aim() -> void:
	pass

func damage(amount) -> void:
	if invulnerability_timer.is_stopped() and check_if_alive():
		invulnerability_timer.start()
		_set_health(health - amount)
		effect_animation.play("Damage")
		effect_animation.queue("Invulnerable")

func kill_tank() -> void:
	speed_fwd = 0
	velocity = Vector2.ZERO
	$Particles_Killed.emitting = true
	$HealthBar.visible = false
	set_collision_layer_and_mask(true)
	
func set_collision_layer_and_mask(is_dead: bool) -> void:
	if is_dead:
		set_collision_layer_bit(5, true)
		set_collision_layer_bit(0, false)
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(4, false)
	else:
		set_collision_layer_bit(5, false)
		set_collision_layer_bit(0, true)
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(4, true)

func _set_health(value) -> void:
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

func set_engine_pitch():
	var pitch = clamp(max_pitch * (clamp(speed_fwd / speed_fwd_max, min_percentage, max_percentage)), min_pitch, max_pitch)
	if audio_engine != null:
		audio_engine.pitch_scale = pitch

func shoot() -> void:
	can_shoot = false
	var bullet_pos = global_position + bullet_offset.rotated(rotation)
	var bullet_dir_now = bullet_dir.rotated(rotation)
	shot_timer.start()
	emit_signal("shot_bullet", bullet_pos, bullet_dir_now)
	audio_shot.play()
	
func _on_shot_timer_timeout() -> void:
	can_shoot = true

func _on_InvulnerableTimer_timeout():
	effect_animation.play("Normal")

func play_engine_running() -> void:
	audio_engine.play()

func stop_engine_running() -> void:
	audio_engine.stop()

func set_track_particles() -> void:
	if $Particles_Track1.emitting:
		if speed_fwd < 10:
			$Particles_Track1.emitting = false
			$Particles_Track2.emitting = false
	else:
		if speed_fwd > 5:
			$Particles_Track1.emitting = true
			$Particles_Track2.emitting = true