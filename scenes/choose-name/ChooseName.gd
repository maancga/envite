extends Control

signal nameChosenSignal(name)
signal startGameSignal()

@onready var userNameInput = $CanvasLayer/Screen/VBoxContainer/ChooseANameBlock/ChooseANameMargin/ChooseANameHBox/ChooseANameInputVBox/ChooseANameInput
@onready var teamPlayerList= $CanvasLayer/Screen/VBoxContainer/ConnectedPlayersBlock/SectionVAlignment/PlayersRows
@onready var startGameButton = $CanvasLayer/Screen/VBoxContainer/ConnectedPlayersBlock/Control/VBoxContainer/MarginContainer2/StartGameButton
@onready var triumphsRows = $CanvasLayer/Screen/VBoxContainer/ConnectedPlayersBlock/Control/VBoxContainer/MarginContainer/TriumphsBlock/PanelContainer6/TriumphsRows
var yourId = null

func _ready():
	cleanPlayersLists()
	startGameButton.visible = false

func setId(newPlayerId: String):
	yourId = newPlayerId
	
func updateList(newPlayerId: String, newPlayers: Dictionary, newTeam1: Array[String], newTeam2: Array[String], team1Leader: String, team2Leader: String):
	cleanPlayersLists()
	var playersArray = []
	for player in newPlayers.keys():
		playersArray.append(player)
	var team1Theme = preload("res://scenes/choose-name/PlayerNameLabelThemeTeam1.tres")
	var team2Theme = preload("res://scenes/choose-name/PlayerNameLabelThemeTeam2.tres")
	var firstPlayerContainer = PanelContainer.new()
	firstPlayerContainer.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	firstPlayerContainer.theme = team1Theme
	var secondPlayerContainer = PanelContainer.new()
	secondPlayerContainer.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	secondPlayerContainer.theme = team2Theme
	for player in playersArray:
		var currentPlayer = newPlayers[player]
		var playerName = currentPlayer["name"]
		var playerNameLabel = Label.new()
		playerNameLabel.text = playerName
		playerNameLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		playerNameLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		playerNameLabel.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		playerNameLabel.set_v_size_flags(Control.SIZE_EXPAND_FILL)
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
			firstPlayerContainer = PanelContainer.new()
			firstPlayerContainer.set_h_size_flags(Control.SIZE_EXPAND_FILL)
			firstPlayerContainer.theme = team1Theme
			secondPlayerContainer = PanelContainer.new()
			secondPlayerContainer.set_h_size_flags(Control.SIZE_EXPAND_FILL)
			secondPlayerContainer.theme = team2Theme


func configureTriumphs(triumphs: Array[Dictionary]):
	cleanTriumphs()
	for triumph in triumphs:
		var panelContainer = CenterContainer.new()
		var label = Label.new()
		panelContainer.add_child(label)
		triumphsRows.add_child(panelContainer)
		label.text = CardData.new(triumph["value"], triumph["suit"]).getCardName()
	var lastContainer = CenterContainer.new()
	var lastLabel = Label.new()
	lastContainer.add_child(lastLabel)
	triumphsRows.add_child(lastContainer)
	lastLabel.text = "La mala (2 de lo virado)"
	
func cleanPlayersLists():
	for child in teamPlayerList.get_children():
		child.queue_free()
		
func cleanTriumphs():
	for child in triumphsRows.get_children():
		child.queue_free()

func _on_button_pressed() -> void:
	startGameSignal.emit()

func _on_choose_a_name_ready_button_pressed() -> void:
	emit_signal("nameChosenSignal", userNameInput.text)

func addPlayerOwner(playerId: String):
	if(yourId != playerId): startGameButton.visible = false
	if(yourId == playerId): startGameButton.visible = true
