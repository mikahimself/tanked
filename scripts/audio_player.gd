extends Node

onready var move: AudioStreamPlayer = get_node("Move")
onready var engine_cpu: AudioStreamPlayer = get_node("EngineCpu")
onready var engine_player: AudioStreamPlayer = get_node("EnginePlayer")
onready var shot: AudioStreamPlayer = get_node("Shot")
onready var explosion: AudioStreamPlayer = get_node("Explosion")