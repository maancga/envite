extends Control

signal nameChosenSignal(name)
signal startGameSignal()

@onready var userNameInput = $CanvasLayer/Screen/VBoxContainer/ChooseANameBlock/ChooseANameMargin/ChooseANameHBox/ChooseANameInputVBox/ChooseANameInput
@onready var startGameButton = $CanvasLayer/Screen/PanelContainer/MarginContainer2/StartGameButton
@onready var triumphsBlock = $CanvasLayer/Screen/PanelContainer/MarginContainer3/VBoxContainer2/MarginContainer/PanelContainer/MarginContainer/TriumphsBlock
@onready var goldPanel = $CanvasLayer/Screen/PanelContainer/MarginContainer3/VBoxContainer2/MarginContainer/PanelContainer/MarginContainer/TriumphsBlock/GoldPanel
@onready var silverPanel = $CanvasLayer/Screen/PanelContainer/MarginContainer3/VBoxContainer2/MarginContainer/PanelContainer/MarginContainer/TriumphsBlock/SilverPanel
@onready var bronzePanel = $CanvasLayer/Screen/PanelContainer/MarginContainer3/VBoxContainer2/MarginContainer/PanelContainer/MarginContainer/TriumphsBlock/BronzePanel
@onready var otherTriumphPanel =$CanvasLayer/Screen/PanelContainer/MarginContainer3/VBoxContainer2/MarginContainer/PanelContainer/MarginContainer/TriumphsBlock/OtherTriumphPanel
@onready var team1Column = $CanvasLayer/Screen/VBoxContainer/ConnectedPlayersBlock/SectionVAlignment/PlayersColumns/Team1Column
@onready var team2Column = $CanvasLayer/Screen/VBoxContainer/ConnectedPlayersBlock/SectionVAlignment/PlayersColumns/Team2Column

var yourId = null
var toDeleteTriumphsNodes = []
var ownerId: String = ""

func _ready():
	cleanPlayersLists()
	configureTriumphs([])
	addPlayerOwner("")


func setId(newPlayerId: String):
	yourId = newPlayerId
	
func updateList(newPlayerId: String, newPlayers: Dictionary, newTeam1: Array[String], newTeam2: Array[String], team1Leader: String, team2Leader: String):
	cleanPlayersLists()
	var playersArray = []
	for player in newPlayers.keys():
		playersArray.append(player)
	var team1Theme = preload("res://scenes/choose-name/PlayerNameLabelThemeTeam1.tres")
	var team2Theme = preload("res://scenes/choose-name/PlayerNameLabelThemeTeam2.tres")
	for player in playersArray:
		var currentPlayer = newPlayers[player]
		var playerName = currentPlayer["name"]
		var container = preload("res://scenes/choose-name/PlayerContainer.tscn").instantiate()
		if (currentPlayer["id"] == newPlayerId): container.isYou()
		if player in newTeam1:
			container.theme = team1Theme			
			team1Column.add_child(container)
			container.changeName(playerName)
		if player in newTeam2 :
			container.theme = team2Theme			
			team2Column.add_child(container)
			container.changeName(playerName)
		if (currentPlayer["id"] == team1Leader || currentPlayer["id"] == team2Leader): container.isLeader()
		if (currentPlayer["id"] == newPlayerId): container.isYou()
		if (ownerId == player): container.isGameOwner()



func configureTriumphs(triumphs: Array[Dictionary]):
	cleanTriumphs()
	if triumphs.size() == 0:
		goldPanel.get_node("MarginContainer/Label").text = "La mala (2 de lo virado)"
		goldPanel.visible = true
		return
	for triumph in triumphs.size():
		match triumph:
			0: 
				goldPanel.get_node("MarginContainer/Label").text = CardData.new(triumphs[triumph]["value"], triumphs[triumph]["suit"]).getCardName()
				goldPanel.visible = true
			1: 
				silverPanel.get_node("MarginContainer/Label").text = CardData.new(triumphs[triumph]["value"], triumphs[triumph]["suit"]).getCardName()
				silverPanel.visible = true
			2: 
				bronzePanel.get_node("MarginContainer/Label").text = CardData.new(triumphs[triumph]["value"], triumphs[triumph]["suit"]).getCardName()
				bronzePanel.visible = true
			_:
				var container = PanelContainer.new()
				container.theme = otherTriumphPanel.theme
				var margin = getSettedMarginContainer( CardData.new(triumphs[triumph]["value"], triumphs[triumph]["suit"]).getCardName())
				container.add_child(margin)
				triumphsBlock.add_child(container)
				toDeleteTriumphsNodes.push_back(container)
	var finalContainer = PanelContainer.new()
	finalContainer.theme = otherTriumphPanel.theme
	var finalMargin = getSettedMarginContainer("La mala (2 de lo virado)")
	finalContainer.add_child(finalMargin)
	triumphsBlock.add_child(finalContainer)
	toDeleteTriumphsNodes.push_back(finalContainer)

func getSettedMarginContainer(labelText: String):
	var finalMargin = MarginContainer.new()
	finalMargin.add_theme_constant_override("margin_left", 2)
	finalMargin.add_theme_constant_override("margin_top", 2)
	finalMargin.add_theme_constant_override("margin_right", 2)
	finalMargin.add_theme_constant_override("margin_bottom", 2)

	var finalLabel = Label.new()
	finalLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	finalLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	finalLabel.text = labelText
	finalMargin.add_child(finalLabel)
	return finalMargin

	
func cleanPlayersLists():
	for child in team1Column.get_children():
		child.queue_free()
	for child in team2Column.get_children():
		child.queue_free()
		
func cleanTriumphs():
	goldPanel.visible = false
	silverPanel.visible = false
	bronzePanel.visible = false
	otherTriumphPanel.visible = false

	for node in toDeleteTriumphsNodes:
		node.queue_free()
	toDeleteTriumphsNodes.clear()



func _on_button_pressed() -> void:
	startGameSignal.emit()

func _on_choose_a_name_ready_button_pressed() -> void:
	emit_signal("nameChosenSignal", userNameInput.text)

func addPlayerOwner(playerId: String):
	ownerId = playerId
	showStartGameButton()

func showStartGameButton():
	if(yourId != ownerId): startGameButton.disabled = true
	if(yourId == ownerId): 
		startGameButton.disabled = false

func onChooseNameButtonAreaEntered() -> void:
	$ButtonFocusedSound.play()

func onStartGameButtonAreaEntered() -> void:
	if not $CanvasLayer/Screen/PanelContainer/MarginContainer2/StartGameButton.disabled: $ButtonFocusedSound.play()
