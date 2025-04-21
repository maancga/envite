extends Node

var currentScene: Node = null
var hasChosenName = false
var isClientConnected = false
var hasGameStarted = false
var serverManagerScript = preload("res://shared/ServerManager.gd")
var serverManager
var gameScene = null
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
	gameScene.connect("vidoCalledSignal", Callable(self, 'onVidoCalled'))
	gameScene.connect("vidoAcceptedSignal", Callable(self, "onVidoAccepted"))
	gameScene.connect("vidoRejectedSignal", Callable(self, "onVidoRejected"))
	gameScene.connect("vidoRaisedSignal", Callable(self, "onVidoRaised"))
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
	serverManager.connect("receivePlayerCalledVidoSignal", Callable(self, "onReceivedPlayerCalledVido"))
	serverManager.connect("receivePlayerRefusedVidoSignal", Callable(self, "onReceivePlayerRefusedVido"))
	serverManager.connect("receivePlayerRaisedVidoTo7PiedrasSignal", Callable(self, "onPlayerRaisedVidoTo7Piedras"))
	serverManager.connect("receivePlayerRaisedVidoTo9PiedrasSignal", Callable(self, "onPlayerRaisedVidoTo9Piedras"))
	serverManager.connect("receivePlayerRaisedVidoToChicoSignal", Callable(self, "onPlayerRaisedVidoToChico"))
	serverManager.connect("receivePlayerRaisedVidoToGameSignal", Callable(self, "onPlayerRaisedVidoToGame"))
	serverManager.connect("receiveVidoCanOnlyBeCalledOnYourTurnSignal", Callable(self, "onVidoCanOnlyBeCalledOnYourTurn"))
	serverManager.connect("receiveOnlyLeaderCanTakeThisDecisionSignal", Callable(self, "onReceiveOnlyLeaderCanTakeThisDecision"))
	serverManager.connect("receivePlayerFromSameTeamCanNotTakeDecisionSignal", Callable(self, "onReceivePlayerFromSameTeamCanNotTakeDecision"))
	serverManager.connect("receivePlayerAcceptedVidoSignal", Callable(self, "onPlayerAcceptedVido"))
	serverManager.connect("receivePlayerRefusedVidoSignal", Callable(self, "onPlayerRefusedVido"))
	serverManager.connect("receivePlayerRaisedVidoTo7PiedrasSignal", Callable(self, "onPlayerRejectedVido"))


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

func onReceivedPlayersAndTeams(newPlayers, newTeam1, newTeam2, team1Leader, team2Leader):
	var playerId = multiplayer.get_unique_id()
	gameScene.setUpScene(str(playerId), newPlayers, newTeam1, newTeam2, team1Leader, team2Leader)

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

func onVidoCalled():
	serverManager.callVido()

func onVidoAccepted():
	serverManager.acceptVido()

func onVidoRejected():
	serverManager.rejectVido()

func onVidoRaised():
	serverManager.raisedVido()

func onReceivedPlayerCalledVido(player: String):
	gameScene.setPlayerCalledVido(player)

func onReceivePlayerRefusedVido(playerId: String):
	gameScene.rejectedVido(playerId)

func onPlayerRaisedVidoTo7Piedras(playerId: String):
	gameScene.raisedVidoTo7Piedras(playerId)

func onPlayerRaisedVidoTo9Piedras(playerId: String):
	gameScene.raisedVidoTo9Piedras(playerId)

func onPlayerRaisedVidoToChico(playerId: String):
	gameScene.raisedVidoToChico(playerId)

func onPlayerRaisedVidoToGame(playerId: String):
	gameScene.raisedVidoToGame(playerId)

func onPlayerRefusedVido(playerId: String):
	gameScene.refusedVido(playerId)

func onPlayerAcceptedVido(playerId: String):
	gameScene.acceptedVido(playerId)
	
func onReceivedPlayedTurn(playerId: String):
	gameScene.setPlayerTurn(playerId)

func onReceivedPlayedCard(player: String, card: Dictionary, cardHandIndex: int):
	gameScene.addPlayedCard(player, card, cardHandIndex)
	
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

func onVidoCanOnlyBeCalledOnYourTurn():
	gameScene.vidoCanOnlyBeCalledOnYourTurn()

func onReceiveOnlyLeaderCanTakeThisDecision():
	print("Only leader can make this decision")

func onReceivePlayerFromSameTeamCanNotTakeDecision(_playerId: String):
	print("eyyy")
	
