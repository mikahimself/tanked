extends Control

var pause_state: bool = false

func _input(event):
	if event.is_action_pressed("pause"):
		pause_state = not get_tree().paused
		get_tree().paused = pause_state
		visible = pause_state
		get_node("Panel/VBoxContainer/ContinueButton").grab_focus()
			
func _on_BackToMenuButton_pressed():
	get_tree().paused = false
	get_tree().get_root().get_node("GameScreen").quit_game()

func _on_ContinueButton_pressed():
	pause_state = false
	get_tree().paused = pause_state
	visible = false
