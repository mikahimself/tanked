extends Node2D

export (bool) var debug = false
export (float) var search_interval = 0.5

onready var nav = get_node("nav")
#onready var map = get_node("level_container/level")
onready var cpu = get_node("cpu")
onready var player = get_node("player")
#onready var path = get_node("path")
onready var path_update_timer = get_node("path_update_timer")
onready var target_container = get_node("target_container")

var target = load("res://scenes/target.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_enemy()
	path_update_timer.wait_time = search_interval
	path_update_timer.start()

func set_enemy():
	cpu.goal = player.position
	cpu.nav = nav

func _on_Timer_timeout():
	var pos = player.position
	cpu.set_goal(pos)

	if debug:
		draw_tracks()

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