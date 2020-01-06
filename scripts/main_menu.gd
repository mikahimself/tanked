extends Control

onready var campaign_button: Button = get_node("VBoxContainer/CenterContainer/VBoxContainer3/VBoxContainer_Buttons/CampaignButton")
onready var audio_move_start: AudioStreamPlayer = get_node("Audio_Move_Start")
onready var audio_move: AudioStreamPlayer = get_node("Audio_Move")

func _ready():
	campaign_button.grab_focus()
	audio_move.stop()
	
# Button Actions
func _on_CampaignButton_pressed():
	audio_move.play()
	game_data.game_mode = game_data.game_modes.CAMPAIGN

func _on_QuickMatchButton_pressed():
	audio_move_start.play()
	game_data.game_mode = game_data.game_modes.QUICK_MATCH
	
func _on_MultiPlayerButton_pressed():
	audio_move.play()

func _on_QuitGameButton_pressed():
	audio_move.play()
	get_tree().quit()
	
func _on_Audio_Move_Start_finished():
	get_tree().change_scene("res://screens/match_options_screen.tscn")

# Focus Sounds
func _on_CampaignButton_focus_entered():
	audio_move.play()

func _on_QuickMatchButton_focus_entered():
	audio_move.play()

func _on_MultiPlayerButton_focus_entered():
	audio_move.play()

func _on_QuitGameButton_focus_exited():
	audio_move.play()

func _on_QuitGameButton_focus_entered():
	audio_move.play()


