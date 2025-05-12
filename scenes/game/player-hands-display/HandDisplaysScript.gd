extends Node2D

class_name HandDisplaysScript

@onready var myHand: MyHand = $MyHand
@onready var dropZone: DropZone = $DropZone
@export var playerNamesNodePaths = []
@export var playerHandsNodePaths = []
@onready var playerNames: Array = loadNodes(playerNamesNodePaths)
@onready var playerHands: Array = loadNodes(playerHandsNodePaths)
@onready var playingButtonsDisplay: PlayingButtonsDisplay = $PlayingButtonsDisplay
@onready var vidoElectionScene: VidoElectionScene = $VidoElectionScene
@onready var tumboElectionScene: TumboElectionScene = $TumboElectionScene
@onready var virado = $Virado/Card
@onready var teamScore = $TeamScore
var notificationsManager: NotificationsManager
signal vidoCalledSignal()
signal vidoAcceptedSignal()
signal vidoRejectedSignal()
signal vidoRaisedSignal()
signal droppedCardSignal(card: String)
signal yourTurnSignal()
signal tumbarSignal()
signal achicarseSignal()

var currentPlayerTurnId: String
var players : Dictionary
var yourId: String
var playersArray: Array[String]
var team1Leader: String
var team2Leader: String
var team1: Array[String]
var team2: Array[String]
var viradoCalledThisRound = false

func _ready() -> void:
	vidoElectionScene.visible = false
	vidoElectionScene.connect("rejectButtonPressedSignal", onVidoRejected)
	vidoElectionScene.connect("acceptButtonPressedSignal", onVidoAccepted)
	vidoElectionScene.connect("raisedButtonPressedSignal", onVidoRaised)
	tumboElectionScene.visible = false
	tumboElectionScene.connect("tumbarButtonPressedSignal", onTumbarButtonPressed)
	tumboElectionScene.connect("achicarseButtonPressedSignal", onAchicarseButtonPressed)
	playingButtonsDisplay.connect("callVidoButtonPressedSignal", onVidoCalledButtonPressed)
	dropZone.connect("cardDroppedSignal", onCardDroppedSignal)

func loadNodes(nodePaths: Array) -> Array:
		var nodes := []
		for nodePath in nodePaths:
				var node := get_node(nodePath)
				if node != null:
						nodes.append(node)
		return nodes

func setVirado(card: CardData):
	virado.suit = card.suit
	virado.value = card.value
	virado.update_texture()

func setTeamLabels():
	if(isTeam1(yourId)): teamScore.highlightTeam1Row()
	if(isTeam2(yourId)): teamScore.highlightTeam2Row()


func setHands(card1: CardData, card2: CardData, card3: CardData):
	viradoCalledThisRound = false
	myHand.setHand(card1, card2, card3)
	resetOtherPlayersCards()
	cleanPlayedCards()
	paintCurrentTurn()

func setUp(_playerId: String, _playerTurnId: String, _players: Dictionary, _team1Leader: String, _team2Leader: String, _team1: Array[String], _team2: Array[String], _notificationsManager: NotificationsManager) -> void:
	yourId = _playerId
	currentPlayerTurnId = _playerTurnId
	players = _players
	team1Leader = _team1Leader
	team2Leader = _team2Leader
	team1 = _team1
	team2 = _team2
	notificationsManager = _notificationsManager
	for player in players.keys():
		playersArray.append(player)
	
	for player in playersArray:
		var distance = RelativeHandsDistance.new(playersArray, yourId).calculateDistance(player)
		var currentPlayer = players[player]
		var isYou = player == yourId
		setUpPlayerDisplay(playerNames[distance], currentPlayer["id"], currentPlayer["name"], isYou)

func setUpPlayerDisplay(playerNameDisplay: PlayerNameDisplay, currentPlayerId: String, currentPlayerName: String, isYou: bool):
	playerNameDisplay.setPlayerName(currentPlayerName)
	if isYou: playerNameDisplay.isYou()
	if currentPlayerId == team1Leader || currentPlayerId == team2Leader: playerNameDisplay.convertToLeader()
	if isTeam1(currentPlayerId): playerNameDisplay.setTeam1Color()
	if isTeam2(currentPlayerId): playerNameDisplay.setTeam2Color()

func paintCurrentTurn():
	if (currentPlayerTurnId == yourId): 
		if (not viradoCalledThisRound): playingButtonsDisplay.show()
		yourTurnSignal.emit()
	else: playingButtonsDisplay.hide()
	for player in playersArray:
		var distance = RelativeHandsDistance.new(playersArray, yourId).calculateDistance(player)
		var currentPlayer = players[player]
		if (currentPlayerTurnId == currentPlayer["id"]): playerNames[distance].isPlayerTurn()
		else: playerNames[distance].isNotPlayerTurn()

func updateHandPlayedCard(playerId: String, index: int):
	var distance = RelativeHandsDistance.new(playersArray, yourId).calculateDistance(playerId)
	var chosenHand = playerHands[distance]

	if (index == 1):
		chosenHand.playFirstCard()
	if (index == 2):
		chosenHand.playSecondCard()
	if (index == 3):
		chosenHand.playThirdCard()

func resetOtherPlayersCards():
	for hand in playerHands:
		if (hand != myHand): hand.resetCardTextures()

	
func addPlayedCard(player: String, card: Dictionary, cardHandIndex: int):
	dropZone.addCard(players[player]["name"], card["value"], card["suit"])
	updateHandPlayedCard(player, cardHandIndex)

func cleanPlayedCards():
	dropZone.cleanPlayedCards()

func onCardDroppedSignal(cardIndex: String):
	droppedCardSignal.emit(cardIndex)

func onVidoCalledButtonPressed() -> void:
	vidoCalledSignal.emit()

func setTurnTo(newPlayerId: String):
	currentPlayerTurnId = newPlayerId
	paintCurrentTurn()

func isTeam1(playerId: String):
	return team1.find(playerId) > -1

func isTeam2(playerId: String):
	return team2.find(playerId) > -1

func iAmTeam1Leader():
	return yourId == team1Leader

func iAmTeam2Leader():
	return yourId == team2Leader

func updateVidoView(vidoPlayerId: String):
	playingButtonsDisplay.hide()
	vidoElectionScene.visible = false
	var vidoCalledByTeam1 = isTeam1(vidoPlayerId)
	if(vidoCalledByTeam1 && iAmTeam2Leader()):
		vidoElectionScene.visible = true
	if (not vidoCalledByTeam1 && iAmTeam1Leader()):
		vidoElectionScene.visible = true

func setVidoCalledView(vidoPlayerId: String):
	updateVidoView(vidoPlayerId)

func raisedVidoTo7Piedras(vidoPlayerId: String):
	updateVidoView(vidoPlayerId)

func raisedVidoTo9Piedras(vidoPlayerId: String):
	updateVidoView(vidoPlayerId)

func raisedVidoToChico(vidoPlayerId: String):
	updateVidoView(vidoPlayerId)

func raisedVidoToGame(vidoPlayerId: String):
	updateVidoView(vidoPlayerId)

func refusedVido(_playerId: String):
	vidoElectionScene.visible = false
	paintCurrentTurn()

func acceptedVido(_playerId: String):
	viradoCalledThisRound = true
	vidoElectionScene.visible = false
	paintCurrentTurn()

func exitVidoCalled(_rejecterPlayer: String):
	vidoElectionScene.visible = false
	paintCurrentTurn()

func onVidoRejected():
	vidoRejectedSignal.emit()

func onVidoAccepted():
	vidoAcceptedSignal.emit()

func onVidoRaised():
	vidoRaisedSignal.emit()

func onTumbarButtonPressed():
	tumbarSignal.emit()

func onAchicarseButtonPressed():
	achicarseSignal.emit()

func getTeam(player: String) -> String:
	if player in team1: return "team1"
	if player in team2: return "team2"
	return "unknown"

func playerWonRound(player: String,  roundScore: int):
	if getTeam(player) == "team1": teamScore.setTeam1Rondas(roundScore)
	if getTeam(player) == "team2": teamScore.setTeam2Rondas(roundScore)
	await get_tree().create_timer(2.0).timeout
	cleanPlayedCards()

func teamWonPiedras(teamName: String, piedras: int):
	print("Team %s won chico points!" % [teamName])
	if teamName == "team1": teamScore.setTeam1Piedras(piedras)
	if teamName == "team2": teamScore.setTeam2Piedras(piedras)
	await get_tree().create_timer(2.0).timeout
	resetRoundScore()

func resetRoundScore():
	teamScore.setTeam1Rondas(0)
	teamScore.setTeam2Rondas(0)

func teamWonChico(teamName: String, chicosScore: int):
	print("Team %s won a chico!" % [teamName])
	if teamName == "team1": teamScore.setTeam1Chicos(chicosScore)
	if teamName == "team2": teamScore.setTeam2Chicos(chicosScore)
	await get_tree().create_timer(2.0).timeout
	resetPiedrasScore()

func resetPiedrasScore():
	teamScore.setTeam1Piedras(0)
	teamScore.setTeam2Piedras(0)
	resetRoundScore()

func teamWon(teamName: String):
	print("Team %s won!" % [teamName])

func team1OnTumboView():
	playingButtonsDisplay.hide()
	tumboElectionScene.visible = false
	if (iAmTeam1Leader()):
		tumboElectionScene.visible = true

func team2OnTumboView():
	playingButtonsDisplay.hide()
	tumboElectionScene.visible = false
	if (iAmTeam2Leader()):
		tumboElectionScene.visible = true

func acceptedTumbo():
	tumboElectionScene.visible = false
	paintCurrentTurn()
