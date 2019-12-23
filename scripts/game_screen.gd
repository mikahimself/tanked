extends Node2D

export (bool) var debug = false
var is_chroma_on = false

export (float) var search_interval = 0.5

onready var nav = get_node("nav")
onready var cpu = get_node("cpu")
onready var player = get_node("player")
onready var path_update_timer = get_node("path_update_timer")
onready var target_container = get_node("target_container")
onready var shader = get_node("Shader/ChromaticAberration")
onready var rng = RandomNumberGenerator.new()

var target = load("res://scenes/target.tscn")
var bullet = load("res://scenes/bullet.tscn")

onready var b_cont = get_node("bullet_container")

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_level()
	set_enemy()
	rng.randomize()
	path_update_timer.wait_time = search_interval
	path_update_timer.start()
	$player.connect("shot_bullet", self, "on_bullet_shot")

func setup_level():
	
	pass

func set_enemy():
	cpu.goal = player.position
	cpu.nav = nav

func _process(delta):
	if is_chroma_on:
		ramp_up_chroma(delta)
	else:
		ramp_down_chroma(delta)

func _on_Timer_timeout():
	var pos = player.position
	cpu.set_goal(pos)

	if debug:
		draw_tracks()

func ramp_up_chroma(delta):
	var value = shader.material.get_shader_param("amount")
	value = value * (1 - delta) + 0.4 * delta * 2
	shader.material.set_shader_param("amount", value)
	if value > 0.39:
		is_chroma_on = false

func ramp_down_chroma(delta):
	var value = shader.material.get_shader_param("amount")
	value = value * (1 - delta) + 0 * delta * 4
	shader.material.set_shader_param("amount", value)

func draw_tracks():
	# Clear previous tracks
	for child in target_container.get_children():
		target_container.remove_child(child)
		child.queue_free()

	# Draw new tracks
	for i in cpu.path.size():
		if i > 1:
			var trgt = target.instance()
			trgt.position = cpu.path[i]
			target_container.add_child(trgt)

# TODO: Flash Chroma when player is hit.
func _on_chroma_update_timer_timeout():
	if rng.randf_range(0,10) < 2:
		is_chroma_on = true

func on_bullet_shot(bullet_position, bullet_direction) -> void:
	var b = bullet.instance()
	b_cont.add_child(b)
	b.start(bullet_position, bullet_direction)
