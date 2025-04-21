extends Node2D

class_name FourPlayersHandsDisplay

@onready var myName: PlayerNameDisplay = $MyName
@onready var myHand: MyHand = $MyHand
@onready var secondHand: UnknownHand = $Player2Hand
@onready var thirdHand: UnknownHand = $Player3Hand
@onready var fourthHand: UnknownHand = $Player4Hand
@onready var playedCards: UIPlayedCards = $PlayedCards
@onready var player2Name: PlayerNameDisplay = $Player2Name
@onready var player3Name: PlayerNameDisplay = $Player3Name
@onready var player4Name: PlayerNameDisplay = $Player4Name
@onready var playCardButton: Button = $PlayCardButton
@onready var callVidoButton: Button = $CallVidoButton
@onready var vidoElectionScene: VidoElectionScene = $VidoElectionScene
signal vidoCalledSignal()
signal vidoAcceptedSignal()
signal vidoRejectedSignal()
signal vidoRaisedSignal()


var currentPlayerTurnId: String
var players : Dictionary
var yourId: String
var playersArray: Array[String]
var selectedCard: Card = null
var team1Leader: String
var team2Leader: String
var team1: Array[String]
var team2: Array[String]
signal playedCard(card)

func _ready() -> void:
	vidoElectionScene.visible = false
	vidoElectionScene.connect("rejectButtonPressedSignal", onVidoRejected)
	vidoElectionScene.connect("acceptButtonPressedSignal", onVidoAccepted)
	vidoElectionScene.connect("raisedButtonPressedSignal", onVidoRaised)
	connectClickedCards()
	
func connectClickedCards() -> void:
	myHand.card1.clickedCard.connect(onCardClicked)
	myHand.card2.clickedCard.connect(onCardClicked)
	myHand.card3.clickedCard.connect(onCardClicked)

func onCardClicked(clickedCard: Card):
	selectedCard = clickedCard

func setHands(card1: CardData, card2: CardData, card3: CardData):
	myHand.setInitialCards(card1, card2, card3)
	resetOtherPlayersCards()
	cleanPlayedCards()

func setUp(_playerId: String, _playerTurnId: String, _players: Dictionary, _team1Leader: String, _team2Leader: String, _team1: Array[String], _team2: Array[String]) -> void:
	yourId = _playerId
	currentPlayerTurnId = _playerTurnId
	players = _players
	team1Leader = _team1Leader
	team2Leader = _team2Leader
	team1 = _team1
	team2 = _team2
	for player in players.keys():
		playersArray.append(player)
	var yourPlayer = players[yourId]
	
	setUpPlayerDisplay(myName, yourPlayer["id"], yourPlayer["name"])

	print(playersArray)
	for player in playersArray:
		var distance = RelativeHandsDistance.new(playersArray, yourId).calculateDistance(player)
		print("distance from %s: %s to %s:%s distance: %s", [yourId, players[yourId]["name"], player, players[player]["name"], distance])
		var currentPlayer = players[player]
		if (distance == 1):
			setUpPlayerDisplay(player2Name, currentPlayer["id"], currentPlayer["name"])
		if (distance == 2):
			setUpPlayerDisplay(player3Name, currentPlayer["id"], currentPlayer["name"])
		if (distance == 3):
			setUpPlayerDisplay(player4Name, currentPlayer["id"], currentPlayer["name"])


func setUpPlayerDisplay(playerNameDisplay: PlayerNameDisplay, currentPlayerId: String, currentPlayerName: String):
	playerNameDisplay.setPlayerName(currentPlayerName)
	if currentPlayerId == team1Leader || currentPlayerId == team2Leader: playerNameDisplay.convertToLeader()
	if isTeam1(currentPlayerId): playerNameDisplay.setTeam1Color()
	if isTeam2(currentPlayerId): playerNameDisplay.setTeam2Color()

func paintCurrentTurn():
	var yourPlayer = players[yourId]
	
	if currentPlayerTurnId == yourPlayer["id"]: myName.isPlayerTurn()
	else: myName.isNotPlayerTurn()

	for player in playersArray:
		var distance = RelativeHandsDistance.new(playersArray, yourId).calculateDistance(player)
		var currentPlayer = players[player]
		if (distance == 1):
			if (currentPlayerTurnId == currentPlayer["id"]): player2Name.isPlayerTurn()
			else: player2Name.isNotPlayerTurn()
		if (distance == 2):
			if (currentPlayerTurnId == currentPlayer["id"]): player3Name.isPlayerTurn()
			else: player3Name.isNotPlayerTurn()
		if (distance == 3):
			if (currentPlayerTurnId == currentPlayer["id"]): player4Name.isPlayerTurn()
			else: player4Name.isNotPlayerTurn()



func playCard(playerId: String, index: int):
	var distance = RelativeHandsDistance.new(playersArray, yourId).calculateDistance(playerId)

	var chosenHand = null
	if (distance == 0):
		chosenHand = myHand
	if (distance == 1):
		chosenHand = secondHand
	if (distance == 2):
		chosenHand = thirdHand
	if (distance == 3):
		chosenHand = fourthHand

	if (index == 1):
		chosenHand.playFirstCard()
	if (index == 2):
		chosenHand.playSecondCard()
	if (index == 3):
		chosenHand.playThirdCard()

func resetOtherPlayersCards():
	secondHand.resetCardTextures()
	thirdHand.resetCardTextures()
	fourthHand.resetCardTextures()

	
func addPlayedCard(player: String, card: Dictionary, cardHandIndex: int):
	playedCards.addCard(players[player]["name"], card["value"], card["suit"])
	playCard(player, cardHandIndex)

func playCardButtonPressed():
	if selectedCard == myHand.card1: playedCard.emit("1")
	if selectedCard == myHand.card2: playedCard.emit("2")
	if selectedCard == myHand.card3: playedCard.emit("3")


func _on_play_card_button_pressed() -> void:
	if !selectedCard: return
	playCardButtonPressed()
	selectedCard = null

func cleanPlayedCards():
	playedCards.cleanPlayedCards()
	playedCards.setAmountOfPlayers(playersArray.size())


func _on_call_vido_button_pressed() -> void:
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
	playCardButton.visible = false
	callVidoButton.visible = false
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

func exitVidoCalled(_rejecterPlayer: String):
	playCardButton.visible = true
	callVidoButton.visible = true
	vidoElectionScene.visible = false

func onVidoRejected():
	vidoRejectedSignal.emit()

func onVidoAccepted():
	vidoAcceptedSignal.emit()

func onVidoRaised():
	vidoRaisedSignal.emit()
