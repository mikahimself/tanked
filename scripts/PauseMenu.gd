extends Control

var pause_state: bool = false
onready var audio_move_quit: AudioStreamPlayer = get_node("Audio_Move_Quit")
onready var audio_move: AudioStreamPlayer = get_node("Audio_Move")

func _input(event):
	if event.is_action_pressed("pause"):
		pause_state = not get_tree().paused
		get_tree().paused = pause_state
		visible = pause_state
		get_node("Panel/VBoxContainer/ContinueButton").grab_focus()
			
func _on_BackToMenuButton_pressed():
	audio_move_quit.play()

func _on_ContinueButton_pressed():
	audio_move.play()
	pause_state = false
	get_tree().paused = pause_state
	visible = false

func _on_ContinueButton_focus_exited():
	audio_move.play()


func _on_BackToMenuButton_focus_exited():
	audio_move.play()

func _on_Audio_Move_Quit_finished():
	get_tree().paused = false
	get_tree().get_root().get_node("GameScreen").quit_game()
