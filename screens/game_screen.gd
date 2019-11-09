extends Node2D

onready var nav = get_node("nav")
#onready var map = get_node("level_container/level")
onready var cpu = get_node("cpu")
onready var player = get_node("player")
onready var path = get_node("path")
onready var timer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_enemy()
	timer.start()

func set_enemy():
	cpu.goal = player.position
	cpu.nav = nav

func _process(delta):
	path.position = cpu.path[0]

func _on_Timer_timeout():
	var pos = player.position
	cpu.set_goal(pos)
