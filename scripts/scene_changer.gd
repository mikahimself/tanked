extends CanvasLayer

signal scene_changed()
signal fade_finished()

onready var animation_player = get_node("AnimationPlayer")

func change_scene(scene_path, delay = 0.5, fade = true) -> void:
	yield(get_tree().create_timer(delay), "timeout")
	if (fade):
		animation_player.play("fade")
		yield(animation_player, "animation_finished")
		emit_signal("fade_finished")
	assert(get_tree().change_scene(scene_path) == OK)
	if (fade):
		animation_player.play_backwards("fade")
	emit_signal("scene_changed")