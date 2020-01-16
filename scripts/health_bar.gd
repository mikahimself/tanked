extends Node2D

onready var health_bar_over = get_node("HealthBarOver")
onready var health_bar_under = get_node("HealthBarUnder")
onready var update_tween = get_node("UpdateTween")

func _ready():
	set_as_toplevel(true)

func _process(delta):
	global_position = get_parent().global_position + Vector2(-26, -25)


func on_max_health_updated(max_health):
	health_bar_over.max_value = max_health
	health_bar_under.max_value = max_health

func _on_base_tank_health_updated(health):
	health_bar_over.value = health
	update_tween.interpolate_property(health_bar_under, "value", health_bar_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()
