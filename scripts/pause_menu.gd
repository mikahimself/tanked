extends Control

var pause_state: bool = false

func _input(event):
	if event.is_action_pressed("pause"):
		pause_state = not get_tree().paused
		get_tree().paused = pause_state
		visible = pause_state
		get_node("Panel/VBoxContainer/ContinueButton").grab_focus()
			
func _on_BackToMenuButton_pressed():
	audio_player.move_scene.play()
	scene_changer.change_scene("res://screens/main_menu.tscn")
	yield(scene_changer, "scene_changed")
	get_tree().paused = false

func _on_ContinueButton_pressed():
	audio_player.move.play()
	pause_state = false
	get_tree().paused = pause_state
	visible = false

func _on_ContinueButton_focus_exited():
	audio_player.move.play()

func _on_BackToMenuButton_focus_exited():
	audio_player.move.play()
