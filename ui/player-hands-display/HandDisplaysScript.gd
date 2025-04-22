extends Node2D

class_name HandDisplaysScript

@onready var myHand: MyHand = $MyHand
@onready var playedCards: UIPlayedCards = $PlayedCards
@export var playerNamesNodePaths = []
@export var playerHandsNodePaths = []
@onready var playerNames: Array = loadNodes(playerNamesNodePaths)
@onready var playerHands: Array = loadNodes(playerHandsNodePaths)

var currentPlayerTurnId: String
var players : Dictionary
var yourId: String
var playersArray: Array[String]
var selectedCard: Card = null
var team1Leader: String
var team2Leader: String
var team1: Array[String]
var team2: Array[String]

func _ready() -> void:
	connectClickedCards()

func loadNodes(nodePaths: Array) -> Array:
		var nodes := []
		for nodePath in nodePaths:
				var node := get_node(nodePath)
				if node != null:
						nodes.append(node)
		return nodes
	
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
	
	for player in playersArray:
		var distance = RelativeHandsDistance.new(playersArray, yourId).calculateDistance(player)
		var currentPlayer = players[player]
		setUpPlayerDisplay(playerNames[distance], currentPlayer["id"], currentPlayer["name"])

func setUpPlayerDisplay(playerNameDisplay: PlayerNameDisplay, currentPlayerId: String, currentPlayerName: String):
	playerNameDisplay.setPlayerName(currentPlayerName)
	if currentPlayerId == team1Leader || currentPlayerId == team2Leader: playerNameDisplay.convertToLeader()
	if isTeam1(currentPlayerId): playerNameDisplay.setTeam1Color()
	if isTeam2(currentPlayerId): playerNameDisplay.setTeam2Color()

func paintCurrentTurn():
	for player in playersArray:
		var distance = RelativeHandsDistance.new(playersArray, yourId).calculateDistance(player)
		var currentPlayer = players[player]
		if (currentPlayerTurnId == currentPlayer["id"]): playerNames[distance].isPlayerTurn()
		else: playerNames[distance].isNotPlayerTurn()

func playCard(playerId: String, index: int):
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
	playedCards.addCard(players[player]["name"], card["value"], card["suit"])
	playCard(player, cardHandIndex)

func cleanPlayedCards():
	playedCards.cleanPlayedCards()
	playedCards.setAmountOfPlayers(playersArray.size())

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
