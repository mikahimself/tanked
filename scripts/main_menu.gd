extends Control

onready var campaign_button: Button = get_node("VBoxContainer/CenterContainer/VBoxContainer3/VBoxContainer_Buttons/CampaignButton")

func _ready():
	campaign_button.grab_focus()
	audio_player.move.stop()
	
# Button Actions
func _on_CampaignButton_pressed():
	audio_player.move.play()
	game_data.game_mode = game_data.game_modes.CAMPAIGN

func _on_QuickMatchButton_pressed():
	audio_player.move_scene.play()
	game_data.game_mode = game_data.game_modes.QUICK_MATCH
	scene_changer.change_scene("res://screens/match_options_screen.tscn", 0, false)
	
func _on_MultiPlayerButton_pressed():
	audio_player.move.play()

func _on_QuitGameButton_pressed():
	audio_player.move.play()
	yield(audio_player.move, "finished")
	get_tree().quit()
	

# Button Focus Sounds
func _on_CampaignButton_focus_entered():
	audio_player.move.play()

func _on_QuickMatchButton_focus_entered():
	audio_player.move.play()

func _on_MultiPlayerButton_focus_entered():
	audio_player.move.play()

func _on_QuitGameButton_focus_exited():
	audio_player.move.play()

func _on_QuitGameButton_focus_entered():
	audio_player.move.play()


