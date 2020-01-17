extends Node2D

export (bool) var debug = false
var is_chroma_on = true

export (float) var search_interval = 0.5

# Node references
onready var nav: Navigation2D = get_node("nav")
onready var bullet_container: Node2D = get_node("bullet_container")
onready var path_update_timer: Timer = get_node("path_update_timer")
onready var target_container: Node2D = get_node("target_container")
onready var shader: TextureRect = get_node("Shader/ChromaticAberration")
onready var rng = RandomNumberGenerator.new()

var target: PackedScene = load("res://scenes/target.tscn")
var bullet: PackedScene = load("res://scenes/bullet.tscn")
var health_bar: PackedScene = load("res://scenes/health_bar.tscn")


var current_level: Node2D
var cpu_tanks: Array = []
var player_tanks: Array = []

func _ready():
	setup_level()
	setup_tanks()
	rng.randomize()
	path_update_timer.wait_time = search_interval
	path_update_timer.start()
	get_tree().paused = false

func setup_level() -> void:
	var level = load(game_data.levels[game_data.current_level])
	current_level = level.instance()
	nav.add_child(current_level)

func setup_tanks() -> void:
	var plr_id = 1
	player_tanks = []
	cpu_tanks = []
	
	for i in range (0, game_data.no_of_players):
		var player = game_data.PlayerTank.instance()
		player.my_id = plr_id
		player.position = current_level.start_positions[plr_id - 1]
		player.rotation_degrees = current_level.start_rotations[plr_id - 1]
		player.connect("shot_bullet", self, "on_bullet_shot")
		player_tanks.append(player)
		add_child(player)
		plr_id += 1
		
	for i in range (0, game_data.no_of_enemies):
		var enemy = game_data.CpuTank.instance()
		enemy.is_cpu = true
		enemy.my_id = plr_id
		enemy.position = current_level.start_positions[plr_id - 1]
		enemy.rotation_degrees = current_level.start_rotations[plr_id - 1]
		enemy.nav = nav
		enemy.speed_fwd = 0.0
		enemy.connect("shot_bullet", self, "on_bullet_shot")
		cpu_tanks.append(enemy)
		enemy.debug = false
		add_child(enemy)
		plr_id += 1

func _process(delta):
	if is_chroma_on:
		ramp_up_chroma(delta)
	else:
		ramp_down_chroma(delta)

func _on_Timer_timeout() -> void:
	for tank in cpu_tanks:
		var new_target = check_distance_to_players(tank.position)
		tank.set_goal(new_target)

	if debug:
		draw_tracks()

func check_distance_to_players(cpu_position) -> Vector2:
	var selected = 0
	var shortest = 9999
	for i in range (0, player_tanks.size()):
		if cpu_position.distance_to(player_tanks[i].position) < shortest:
			selected = i
			shortest = cpu_position.distance_to(player_tanks[i].position)
	return player_tanks[selected]

func ramp_up_chroma(delta) -> void:
	var value = shader.material.get_shader_param("amount")
	value = value * (1 - delta) + 0.4 * delta * 2
	shader.material.set_shader_param("amount", value)
	if value > 0.39:
		is_chroma_on = false

func ramp_down_chroma(delta) -> void:
	var value = shader.material.get_shader_param("amount")
	value = value * (1 - delta) + 0 * delta * 4
	shader.material.set_shader_param("amount", value)

func draw_tracks() -> void:
	# Clear previous tracks
	for child in target_container.get_children():
		target_container.remove_child(child)
		child.queue_free()

	# Draw new tracks
	for tank in cpu_tanks:
		for i in tank.path.size():
			if i > 1:
				var trgt = target.instance()
				trgt.position = tank.path[i]
				target_container.add_child(trgt)

# TODO: Flash Chroma when player is hit.
func _on_chroma_update_timer_timeout() -> void:
	if rng.randf_range(0,10) < 2:
		is_chroma_on = true

func on_bullet_shot(bullet_position, bullet_direction) -> void:
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start(bullet_position, bullet_direction)

#func quit_game():

#	scene_changer.change_scene("res://screens/main_menu.tscn")
	#get_tree().change_scene("res://screens/main_menu.tscn")