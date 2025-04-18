extends Node

var currentScene: Node = null
var hasChosenName = false
var isClientConnected = false
var hasGameStarted = false
var receivedCards = []
var virado = null
var serverManagerScript = preload("res://shared/ServerManager.gd")
var serverManager
var gameScene = null
var currentPlayerTurnId
var players = {}
var team1 = []
var team2 = []
@onready var chooseNameSceneResource = preload("res://scenes/ChooseNameScene.tscn")
@onready var gameSceneResource = preload("res://scenes/GameScene.tscn")

func _ready():
	var args = OS.get_cmdline_args()
	if "--server" in args:
		print("🧠 Starting in SERVER mode")
		startServer()
	else:
		print("🎮 Starting in CLIENT mode")
		connectToServer()
		loadChangeNameScene()

func startServer():
	var server = serverManagerScript.new()
	server.name = "ServerManager"
	add_child(server)
	server.startServer()

func loadChangeNameScene():
	var chooseNameScene = chooseNameSceneResource.instantiate()
	add_child(chooseNameScene)
	gameScene = gameSceneResource.instantiate()
	gameScene.visible = false
	add_child(gameScene)
	gameScene.playersDisplay.connect("playedCard", self.onPlayedCard)
	chooseNameScene.connect("nameChosenSignal", Callable(self, "onNameChosen"))
	currentScene = chooseNameScene

func connectToServer():
	serverManager = serverManagerScript.new()
	serverManager.name = "ServerManager"
	add_child(serverManager)

	connectServerManagerSignals()
	serverManager.connectClient()

func connectServerManagerSignals() -> void:
	serverManager.connect("clientConnectedSignal", Callable(self, "onClientConnected"))
	serverManager.connect("receivedPlayersAndTeamsSignal", Callable(self, "onReceivedPlayersAndTeams"))
	serverManager.connect("cardsReceivedSignal", Callable(self, "onReceivedCards"))
	serverManager.connect("viradoReceivedSignal", Callable(self, "onReceivedVirado"))
	serverManager.connect("gameStartedSignal", Callable(self, "onGameHasStarted"))
	serverManager.connect("receivedPlayedTurnSignal", Callable(self, "onReceivedPlayedTurn"))
	serverManager.connect("receiveCardPlayedSignal", Callable(self, "onReceivedPlayedCard"))
	serverManager.connect("receivePlayerRoundWinnerSignal", Callable(self, "onReceivedRoundWinner"))
	serverManager.connect("receiveTeamWonChicoPointsSignal", Callable(self, "onReceivedTeamWonChicoPoints"))
	serverManager.connect("receiveTeamWonChicoSignal", Callable(self, "onReceivedTeamWonChico"))
	serverManager.connect("receiveTeamWonSignal", Callable(self, "onReceivedTeamWon"))
	serverManager.connect("informGotDealerSignal", Callable(self, "onGotDealer"))
	serverManager.connect("receivePlayerCouldNotPlayCardBecauseItsNotTurnSignal", Callable(self, "onPlayerCouldNotPlayCardBecauseItsNotTurn"))
	serverManager.connect("receivePlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHandSignal", Callable(self, "onPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHand"))
	serverManager.connect("receivePlayerCouldNotPlayCardBecauseItsPlayedAlreadySignal", Callable(self, "onPlayerCouldNotPlayCardBecauseItsPlayedAlready"))

	

func onNameChosen(userName):
	hasChosenName = true
	serverManager.chooseName(userName)
	
	tryLoadGameScene()

func onClientConnected():
	isClientConnected = true
	tryLoadGameScene()

func onGameHasStarted():
	hasGameStarted = true
	tryLoadGameScene()

func onReceivedPlayersAndTeams(newPlayers, newTeam1, newTeam2):
	var playerId = multiplayer.get_unique_id()
	gameScene.setUpScene(str(playerId), newPlayers, newTeam1, newTeam2)

func tryLoadGameScene():
	if (hasChosenName && isClientConnected && hasGameStarted):
		showGameScene()

func showGameScene():
	gameScene.visible = true
	currentScene = gameScene


func onReceivedCards(cards):
	gameScene.setCards(
		CardData.new(cards.firstCard.value, cards.firstCard.suit), 
		CardData.new(cards.secondCard.value, cards.secondCard.suit), 
		CardData.new(cards.thirdCard.value, cards.thirdCard.suit), 
	)

func onReceivedVirado(newVirado):
	gameScene.setVirado(
		CardData.new(newVirado.value, newVirado.suit)
	)


func onPlayedCard(cardIndex: String):	
	serverManager.playCard(cardIndex)
	
func onReceivedPlayedTurn(playerId: String):
	gameScene.setPlayerTurn(playerId)

func onReceivedPlayedCard(player: String, card: Dictionary, playedOrder: int, cardHandIndex: int):
	gameScene.addPlayedCard(player, card, playedOrder, cardHandIndex)
	
func onReceivedRoundWinner(player: String, roundScore: int):
	gameScene.playerWonRound(player, roundScore)

func onReceivedTeamWonChicoPoints(teamName: String, chicoPoints: int):
	gameScene.teamWonChicoPoints(teamName, chicoPoints)

func onReceivedTeamWonChico(teamName: String, chicos: int):
	gameScene.teamWonChico(teamName, chicos)

func onReceivedTeamWon(teamName: String):
	gameScene.teamWon(teamName)

func onGotDealer(dealer: String):
	gameScene.setDealer(dealer)

func onPlayerCouldNotPlayCardBecauseItsNotTurn():
	gameScene.notifyIsNotTurn()

func onPlayerCouldNotPlayCardBecauseItsPlayedAlready():
	gameScene.notifyCardPlayedAlready()

func onPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHand():
	gameScene.notifyHasPlayedAlreadyInHand()
