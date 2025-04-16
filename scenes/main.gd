extends Node

var currentScene: Node = null
var hasChosenName = false
var isClientConnected = false
var hasGameStarted = false
var chosenName = ''
var receivedCards = []
var virado = null
var serverManagerScript = preload("res://shared/ServerManager.gd")
var serverManager
var gameScene = null
var currentPlayerTurnId
var players = {}
var team1 = []
var team2 = []


func _ready():
	var args = OS.get_cmdline_args()
	if "--server" in args:
		print("🧠 Starting in SERVER mode")
		startServer()
	else:
		print("🎮 Starting in CLIENT mode")
		loadConnectionScene()
		loadChangeNameScene()

func startServer():
	var server = serverManagerScript.new()
	server.name = "ServerManager"
	add_child(server)
	server.startServer()

func loadChangeNameScene():
	var chooseNameScene = preload("res://scenes/ChooseNameScene.tscn").instantiate()
	add_child(chooseNameScene)
	chooseNameScene.connect("nameChosenSignal", Callable(self, "onNameChosen"))

	currentScene = chooseNameScene

func loadConnectionScene():
	serverManager = serverManagerScript.new()
	serverManager.name = "ServerManager"
	add_child(serverManager)
	serverManager.connect("clientConnectedSignal", Callable(self, "onClientConnected"))
	serverManager.connect("receivedPlayersAndTeamsSignal", Callable(self, "onReceivedPlayersAndTeams"))
	serverManager.connect("cardsReceivedSignal", Callable(self, "onFirstReceivedCards"))
	serverManager.connect("viradoReceivedSignal", Callable(self, "onFirstReceivedVirado"))
	serverManager.connect("gameStartedSignal", Callable(self, "onGameHasStarted"))
	serverManager.connect("receivedPlayedTurnSignal", Callable(self, "onReceivedPlayedTurn"))
	serverManager.connect("receiveCardPlayedSignal", Callable(self, "onReceivedPlayedCard"))
	serverManager.connect("receivePlayerRoundWinnerSignal", Callable(self, "onReceivedRoundWinner"))
	serverManager.connect("receiveTeamWonChicoPointsSignal", Callable(self, "onReceivedTeamWonChicoPoints"))
	serverManager.connect("receiveTeamWonChicoSignal", Callable(self, "onReceivedTeamWonChico"))
	serverManager.connect("receiveTeamWonSignal", Callable(self, "onReceivedTeamWon"))
	serverManager.connectClient()

func onNameChosen(userName):
	hasChosenName = true
	chosenName = userName
	serverManager.chooseName(userName)
	tryLoadGameScene()

func onClientConnected():
	print("Connected to server!", )
	isClientConnected = true
	tryLoadGameScene()

func onGameHasStarted():
	hasGameStarted = true
	tryLoadGameScene()

func onFirstReceivedCards(cards):
	receivedCards = cards 

func onFirstReceivedVirado(receivedVirado):
	virado = receivedVirado 

func onReceivedPlayersAndTeams(newPlayers, newTeam1, newTeam2):
	players = newPlayers
	team1 = newTeam1
	team2 = newTeam2

func tryLoadGameScene():
	if (hasChosenName && isClientConnected && hasGameStarted):
		loadGameScene()

func loadGameScene():
	currentScene.queue_free()
	currentScene = null

	gameScene = preload("res://scenes/GameScene.tscn").instantiate()
	add_child(gameScene)
	gameScene.connect("playedCard", Callable(self, "onPlayedCard"))
	currentScene = gameScene

	var playerId = multiplayer.get_unique_id()
	gameScene.setUpScene(chosenName, str(playerId), players, team1, team2 )
	gameScene.setInitialCards(
		CardData.new(receivedCards.firstCard.value, receivedCards.firstCard.suit), 
		CardData.new(receivedCards.secondCard.value, receivedCards.secondCard.suit), 
		CardData.new(receivedCards.thirdCard.value, receivedCards.thirdCard.suit), 
		CardData.new(virado.value, virado.suit)
	)
	setFirstTurnPlayer()
	serverManager.connect("cardsReceivedSignal", Callable(self, "onReceivedCards"))
	serverManager.connect("viradoReceivedSignal", Callable(self, "onReceivedVirado"))

func onReceivedCards(cards):
	print("new hand received!", cards)
	gameScene.setCards(
		CardData.new(cards.firstCard.value, cards.firstCard.suit), 
		CardData.new(cards.secondCard.value, cards.secondCard.suit), 
		CardData.new(cards.thirdCard.value, cards.thirdCard.suit), 
	)

func onReceivedVirado(newVirado):
	print("new hand received!", newVirado)
	gameScene.setVirado(
		CardData.new(newVirado.value, newVirado.suit)
	)


func onPlayedCard(cardIndex: String):
	serverManager.playCard(cardIndex)
	
func onReceivedPlayedTurn(playerId: String):
	currentPlayerTurnId = playerId
	if !gameScene: return
	gameScene.setPlayerTurn(playerId)

func setFirstTurnPlayer():
	gameScene.setPlayerTurn(currentPlayerTurnId)

func onReceivedPlayedCard(player: Dictionary, card: Dictionary, playedOrder: int):
	gameScene.addPlayedCard(player, card, playedOrder)
	
func onReceivedRoundWinner(player: String, roundScore: int):
	gameScene.playerWonRound(player, roundScore)

func onReceivedTeamWonChicoPoints(teamName: String, chicoPoints: int):
	gameScene.teamWonChicoPoints(teamName, chicoPoints)

func onReceivedTeamWonChico(teamName: String, chicos: int):
	gameScene.teamWonChico(teamName, chicos)

func onReceivedTeamWon(teamName: String):
	gameScene.teamWon(teamName)
