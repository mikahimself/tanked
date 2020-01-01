extends Control

#onready var start_button = get_node("VBoxContainer/CenterContainer/VBoxContainer3/VBoxContainer_Buttons/StartGameButton")
onready var players_button = get_node("VBoxContainer/CenterContainer/VBoxContainer3/VBoxContainer_Buttons/NoOfPlayersButton")
var players: int = 1

func _ready():
	players_button.grab_focus()

func _on_StartGameButton_pressed():
	game_data.no_of_players = players
	get_tree().change_scene("res://screens/game_screen.tscn")

func _on_NoOfPlayersButton_pressed():
	set_no_of_players()
	players_button.set_text("PLAYERS: %s" % players)

func _on_QuitGameButton_pressed():
	get_tree().quit()

func set_no_of_players():
	players += 1
	if players > 2:
		players = 1