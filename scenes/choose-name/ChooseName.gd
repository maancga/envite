extends Control

signal nameChosenSignal(name)
signal startGameSignal()

@onready var userNameInput = $CanvasLayer/Screen/VBoxContainer/ChooseANameBlock/ChooseANameMargin/ChooseANameHBox/ChooseANameInputVBox/ChooseANameInput
@onready var teamPlayerList= $CanvasLayer/Screen/VBoxContainer/ConnectedPlayersBlock/SectionVAlignment/PlayersRows

func _ready():
	cleanPlayersLists()
	
func updateList(newPlayerId: String, newPlayers: Dictionary, newTeam1: Array[String], newTeam2: Array[String], team1Leader: String, team2Leader: String):
	cleanPlayersLists()
	var playersArray = []
	for player in newPlayers.keys():
		playersArray.append(player)
	var firstPlayerContainer = CenterContainer.new()
	firstPlayerContainer.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	var secondPlayerContainer = CenterContainer.new()
	secondPlayerContainer.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	for player in playersArray:
		var currentPlayer = newPlayers[player]
		var playerName = currentPlayer["name"]
		var playerNameLabel = Label.new()
		playerNameLabel.text = playerName
		if (currentPlayer["id"] == team1Leader || currentPlayer["id"] == team2Leader): playerNameLabel.text += " (Líder)"
		if (currentPlayer["id"] == newPlayerId): playerNameLabel.add_theme_color_override("font_color", "54ba5e")
		if player in newTeam1:
			var hbox = HBoxContainer.new()
			teamPlayerList.add_child(hbox)
			firstPlayerContainer.add_child(playerNameLabel)
			hbox.add_child(firstPlayerContainer)
			hbox.add_child(secondPlayerContainer)
		if player in newTeam2 :
			secondPlayerContainer.add_child(playerNameLabel)
			firstPlayerContainer = CenterContainer.new()
			firstPlayerContainer.set_h_size_flags(Control.SIZE_EXPAND_FILL)
			secondPlayerContainer = CenterContainer.new()
			secondPlayerContainer.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
func cleanPlayersLists():
	for child in teamPlayerList.get_children():
		child.queue_free()

func _on_button_pressed() -> void:
	startGameSignal.emit()

func _on_choose_a_name_ready_button_pressed() -> void:
	emit_signal("nameChosenSignal", userNameInput.text)
