extends Node

# Preload level scenes
var Level_1:PackedScene = preload("res://levels/level_1.tscn")
var levels: Array = []

# Preload vehicles
var PlayerTank: PackedScene = preload("res://scenes/player_tank.tscn")
var CpuTank: PackedScene = preload("res://scenes/cpu_tank.tscn")

# Level info
var current_level: int = 0

func _ready():
	_setup_level_array()
	
func _setup_level_array() -> void:
	levels.append(Level_1)