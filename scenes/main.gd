extends Node

var serverManager
var gameScene
var chooseNameScene
var silence = false
var yourId: String
var optionsCanvasReference
var menuCanvasReference
var menuSceneReference: Menu

func _ready():
	var args = OS.get_cmdline_args()
	if "--server" in args:
		print("🧠 Starting in SERVER mode")
		startServer()
	else:
		print("🎮 Starting in CLIENT mode")
		if "--silence" in args:
			silence = true
		var menuScene = preload("res://scenes/main-menu/Menu.tscn").instantiate()
		menuSceneReference = menuScene
		var canvas = CanvasLayer.new()
		canvas.add_child(menuScene)
		add_child(canvas)
		menuScene.connect("createGameSignal", onCreateGame)
		menuScene.connect("joinGameSignal", onJoinGame)
		menuScene.connect("openOptionsSignal", onOpenOptions)
		menuScene.connect("exitGameSignal", onExitGame)
		menuCanvasReference = canvas
		connectToServer()

func startServer():
	serverManager = preload("res://shared/ServerController.gd").new()
	serverManager.name = "ServerManager"
	add_child(serverManager)
	serverManager.startServer()

func onExitGame():
	get_tree().quit()

func onCreateGame():
	setUpAndLoadChooseNameScene()
	serverManager.clientRequestsCreateGame()
	loadGameSceneInvisible()

func onJoinGame():
	setUpAndLoadChooseNameScene()
	serverManager.clientRequestsJoinGame(menuSceneReference.inputText.text)
	loadGameSceneInvisible()
	
func onOpenOptions():
	var optionsScene = preload("res://scenes/options/Options.tscn").instantiate()
	var canvas = CanvasLayer.new()
	canvas.add_child(optionsScene)
	add_child(canvas)
	optionsScene.connect("exitOptionsButtonPressedSignal", onCloseOptions)
	optionsCanvasReference = canvas

func onCloseOptions():
	optionsCanvasReference.queue_free()

func setUpAndLoadChooseNameScene():
	chooseNameScene = preload("res://scenes/choose-name/ChooseName.tscn").instantiate()
	chooseNameScene.connect("nameChosenSignal", onNameChosen)
	chooseNameScene.connect("startGameSignal", onClientCallsStartsGame)
	add_child(chooseNameScene)
	chooseNameScene.setId(yourId)

func loadGameSceneInvisible():
	gameScene = preload("res://scenes/game/GameScene.tscn").instantiate()
	gameScene.visible = false
	add_child(gameScene)
	gameScene.connect("vidoCalledSignal", onClientCallsVido)
	gameScene.connect("vidoAcceptedSignal", onClientCallsAcceptVido)
	gameScene.connect("vidoRejectedSignal", onClientCallsRejectVido)
	gameScene.connect("vidoRaisedSignal", onClientCallsVidoRaise)
	gameScene.connect("playedCardSignal", onClientCallsPlayCard)
	gameScene.connect("tumbarSignal", onClientTumbar)
	gameScene.connect("achicarseSignal", onClientAchicarse)
	if silence: gameScene.muteMusic()


func connectToServer():
	serverManager = preload("res://shared/ClientController.gd").new()
	serverManager.name = "ServerManager"
	add_child(serverManager)
	connectServerManagerSignals()
	serverManager.connectClient()

func connectServerManagerSignals() -> void:
	serverManager.connect("receivedPlayersAndTeamsSignal", Callable(self, "onReceivedPlayersAndTeams"))
	serverManager.connect("receivedPlayerAddedSignal", Callable(self, "onReceivedPlayersAdded"))
	serverManager.connect("cardsReceivedSignal", Callable(self, "onReceivedCards"))
	serverManager.connect("viradoReceivedSignal", Callable(self, "onReceivedVirado"))
	serverManager.connect("gameStartedSignal", Callable(self, "onGameHasStarted"))
	serverManager.connect("receivedPlayedTurnSignal", Callable(self, "onReceivedPlayedTurn"))
	serverManager.connect("receiveCardPlayedSignal", Callable(self, "onReceivedPlayedCard"))
	serverManager.connect("receivePlayerRoundWinnerSignal", Callable(self, "onReceivedRoundWinner"))
	serverManager.connect("receiveTeamWonPiedrasSignal", Callable(self, "onReceivedTeamWonPiedras"))
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
	serverManager.connect("receivePlayerIsGameOwnerSignal", Callable(self, "onAssignPlayerOwner"))
	serverManager.connect("receiveClientIdSignal", onReceivedClientId)
	serverManager.connect("receiveTriumphsConfigurationSignal", Callable(self, "onReceivedTriumphsConfiguration"))
	serverManager.connect("receiveCannNotPlayCardBecauseTumboIsBeingDecidedSignal", Callable(self, "onReceiveCannNotPlayCardBecauseTumboIsBeingDecided"))
	serverManager.connect("receiveCannNotCallVidoBecauseTumboIsBeingDecidedSignal", Callable(self, "onReceiveCannNotCallVidoBecauseTumboIsBeingDecided"))
	serverManager.connect("receiveTeam1IsOnTumboSignal", Callable(self, "onReceiveTeam1IsOnTumboSignal"))
	serverManager.connect("receiveTeam2IsOnTumboSignal", Callable(self, "onReceiveTeam2IsOnTumboSignal"))
	serverManager.connect("receiveCannNotTakeThisDecisionIfNotInWaitingForTumboSignal", Callable(self, "onReceiveCannNotTakeThisDecisionIfNotInWaitingForTumbo"))
	serverManager.connect("receiveTumboIsAcceptedSignal", Callable(self, "onReceiveTumboIsAccepted"))
	serverManager.connect("receiveTumboIsRejectedSignal", Callable(self, "onReceiveTumboIsRejected"))
	serverManager.connect("receiveCanNotMakeTheActionAfterTheGameEndedSignal", Callable(self, "onReceiveCanNotMakeTheActionAfterTheGameEnded"))
	serverManager.connect("receivedGameAssignedSignal", Callable(self, "onReceiveGameAssigned"))
	serverManager.connect("receivedGameJoinFailedSignal", Callable(self, "onReceiveGameJoinFailedSignal"))

func onNameChosen(userName):
	serverManager.chooseName(userName)

func onGameHasStarted():
	menuCanvasReference.visible = false
	showGameScene()

func onReceivedClientId(playerId: String):
	yourId = playerId

func onReceivedPlayersAndTeams(newPlayers, newTeam1, newTeam2, team1Leader, team2Leader):
	var playerId = multiplayer.get_unique_id()
	var playerAmounts = newTeam1.size() + newTeam2.size()
	var handDisplayScene = null
	match playerAmounts:
		4: handDisplayScene = preload("res://scenes/game/player-hands-display/FourPlayersHandsDisplay.tscn").instantiate()
		6: handDisplayScene = preload("res://scenes/game/player-hands-display/SixPlayersHandsDisplay.tscn").instantiate()
		8: handDisplayScene = preload("res://scenes/game/player-hands-display/EightPlayersHandsDisplay.tscn").instantiate()
		10: handDisplayScene = preload("res://scenes/game/player-hands-display/TenPlayersHandsDisplay.tscn").instantiate()
		12: handDisplayScene = preload("res://scenes/game/player-hands-display/TwelvePlayersHandsDisplay.tscn").instantiate()
	gameScene.setUpScene(str(playerId), newPlayers, newTeam1, newTeam2, team1Leader, team2Leader, handDisplayScene)


func onReceivedPlayersAdded(newPlayers, newTeam1, newTeam2, team1Leader, team2Leader):
	var playerId = multiplayer.get_unique_id()
	chooseNameScene.updateList(str(playerId), newPlayers, newTeam1, newTeam2, team1Leader, team2Leader)

func showGameScene():
	chooseNameScene.queue_free()
	gameScene.visible = true


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

func onClientCallsPlayCard(cardIndex: String):
	serverManager.playCard(cardIndex)

func onClientCallsVido():
	serverManager.callVido()

func onClientCallsAcceptVido():
	serverManager.acceptVido()

func onClientCallsRejectVido():
	serverManager.rejectVido()

func onClientTumbar():
	serverManager.tumbar()

func onClientAchicarse():
	serverManager.achicarse()

func onClientCallsVidoRaise():
	serverManager.raisedVido()

func onClientCallsStartsGame():
	serverManager.startGame()

func onAssignPlayerOwner(playerId: String):
	chooseNameScene.addPlayerOwner(playerId)

func onReceivedTriumphsConfiguration(triumphs: Array[Dictionary]):
	chooseNameScene.configureTriumphs(triumphs)

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

func onReceivedTeamWonPiedras(teamName: String, piedras: int):
	gameScene.teamWonPiedras(teamName, piedras)

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

func onReceiveCannNotPlayCardBecauseTumboIsBeingDecided():
	gameScene.cannNotPlayBecauseTumboIsBeingDecided()

func onReceiveCannNotCallVidoBecauseTumboIsBeingDecided():
	gameScene.cannNotCallVidoBecauseTumboIsBeingDecided()

func onReceiveTeam1IsOnTumboSignal():
	gameScene.notifyTeam1IsOnTumbo()

func onReceiveTeam2IsOnTumboSignal():
	gameScene.notifyTeam2IsOnTumbo()

func onReceiveCannNotTakeThisDecisionIfNotInWaitingForTumbo():
	gameScene.notifyCannNotTakeThisDecisionIfNotInWaitingForTumbo()
	
func onReceiveTumboIsAccepted():
	gameScene.notifyTumboIsAccepted()

func onReceiveTumboIsRejected():
	gameScene.notifyTumboIsRejected()

func onReceiveCanNotMakeTheActionAfterTheGameEnded():
	gameScene.notifyCanNotMakeTheActionAfterTheGameEnded()

func onReceiveGameAssigned(gameId: String):
	chooseNameScene.setLobbyName(gameId)

func onReceiveGameJoinFailedSignal():
	var notify = preload("res://scenes/game/notifications/Notifications.tscn").instantiate()
	add_child(notify)
	notify.showMessage("Esa partida no existe")
	

func onReceiveOnlyLeaderCanTakeThisDecision():
	print("Only leader can make this decision")

func onReceivePlayerFromSameTeamCanNotTakeDecision(_playerId: String):
	print("eyyy")
	
