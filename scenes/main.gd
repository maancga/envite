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
	serverManager.connect("cardsReceivedSignal", Callable(self, "onReceivedCards"))
	serverManager.connect("viradoReceivedSignal", Callable(self, "onReceivedVirado"))
	serverManager.connect("gameStartedSignal", Callable(self, "onGameHasStarted"))
	serverManager.connect("receivedPlayedTurnSignal", Callable(self, "onReceivedPlayedTurn"))
	serverManager.connect("receiveCardPlayedSignal", Callable(self, "onReceivedPlayedCard"))

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

func onReceivedCards(cards):
	receivedCards = cards 

func onReceivedVirado(receivedVirado):
	virado = receivedVirado 

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
	gameScene.setUpScene(chosenName, 
		CardData.new(receivedCards.firstCard.value, receivedCards.firstCard.suit), 
		CardData.new(receivedCards.secondCard.value, receivedCards.secondCard.suit), 
		CardData.new(receivedCards.thirdCard.value, receivedCards.thirdCard.suit), 
		CardData.new(virado.value, virado.suit),
		str(playerId)
	)
	setFirstTurnPlayer()


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
	
