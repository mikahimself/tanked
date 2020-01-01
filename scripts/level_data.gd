extends Node2D

export (int) var level_no = 0
export (int) var no_of_enemies = 0
export (String) var level_name = ""

export (Vector2) var p1_start_position = Vector2.ZERO
export (Vector2) var p2_start_position = Vector2.ZERO
export (Vector2) var p3_start_position = Vector2.ZERO
export (Vector2) var p4_start_position = Vector2.ZERO

export (float) var p1_start_rotation = 0.0
export (float) var p2_start_rotation = 0.0
export (float) var p3_start_rotation = 0.0
export (float) var p4_start_rotation = 0.0

var start_positions: Array = []
var start_rotations: Array = []

func _ready():
	start_positions = [p1_start_position, p2_start_position, p3_start_position, p4_start_position]
	start_rotations = [p1_start_rotation, p2_start_rotation, p3_start_rotation, p4_start_rotation]