extends Node

enum single_game_mode_list { CAMPAIGN, SINGLE_BATTLE }

# Preload level scenes
var Level_1: String = "res://levels/level_01.tscn"
var Level_2: String = "res://levels/level_02.tscn"
var Level_3: String = "res://levels/level_2.tscn"
var Level_4: String = "res://levels/level_1.tscn"
var Level_5: String = "res://levels/level_01_blank.tscn"
var levels: Array = []

# Game mode related
var game_modes: Dictionary = {}
var game_mode

# Difficulty level
var difficulty_levels: Dictionary = {}
var difficulty_level = 1

# Players
var no_of_players: int = 1
var no_of_enemies: int = 1 setget set_no_of_enemies

# Vehicles
var PlayerTank: PackedScene = preload("res://scenes/player_tank.tscn")
var CpuTank: PackedScene = preload("res://scenes/cpu_tank.tscn")
var tanks: Array = []

# Level info
var current_level: int = 2

func _ready():
	_setup_level_array()
	_setup_game_modes()
	_setup_difficulty_levels()
	
func _setup_game_modes() -> void:
	add_game_mode("VS_BATTLE")
	add_game_mode("COOP_BATTLE")
	add_game_mode("CAMPAIGN")
	add_game_mode("QUICK_MATCH")

func _setup_level_array() -> void:
	levels.append(Level_1)
	levels.append(Level_2)
	levels.append(Level_3)
	levels.append(Level_4)
	levels.append(Level_5)

func _setup_difficulty_levels() -> void:
	add_difficulty_level("EASY")
	add_difficulty_level("NORMAL")
	add_difficulty_level("HARD")

func add_difficulty_level(level_name) -> void:
	difficulty_levels[difficulty_levels.size()] = level_name

func add_game_mode(mode_name) -> void:
	game_modes[mode_name] = game_modes.size()

func set_no_of_enemies(enemy_no):
	no_of_enemies = enemy_no
	if no_of_enemies > 3:
		no_of_enemies = 1

func set_difficulty(difficulty):
	difficulty_level = difficulty
	if difficulty_level >= difficulty_levels.size():
		difficulty_level = 0

func get_difficulty() -> String:
	return difficulty_levels[difficulty_level]