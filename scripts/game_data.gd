extends Node

# Preload level scenes
var Level_1: String = "res://levels/level_01.tscn"
var Level_2: String = "res://levels/level_02.tscn"
var Level_3: String = "res://levels/level_2.tscn"
var Level_4: String = "res://levels/level_1.tscn"
var levels: Array = []

# Preload vehicles
var PlayerTank: PackedScene = preload("res://scenes/player_tank.tscn")
var CpuTank: PackedScene = preload("res://scenes/cpu_tank.tscn")

# Level info
var current_level: int = 0

# Game info
var no_of_players: int = 1

# Vehicles
var tanks: Array = []

func _ready():
	_setup_level_array()
	
func _setup_level_array() -> void:
	levels.append(Level_1)
	levels.append(Level_2)
	levels.append(Level_3)
	levels.append(Level_4)
