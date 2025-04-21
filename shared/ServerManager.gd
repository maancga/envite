extends Node

class_name ServerManager

const CardIndex = {
	CARD_1 = "1",
	CARD_2 = "2",
	CARD_3 = "3"
}

signal clientConnectedSignal
signal cardsReceivedSignal(cards)
signal viradoReceivedSignal(virado)
signal gameStartedSignal()
signal receivedPlayedTurnSignal(playerId)
signal receiveCardPlayedSignal(playerId, card, playedOrder)
signal receivePlayerRoundWinnerSignal(playerId, card, playedOrder)
signal receivedPlayersAndTeamsSignal(players, team1, team2)
signal receiveTeamWonChicoPointsSignal(teamName, chicoPoints)
signal receiveTeamWonChicoSignal(teamName, chicos)
signal receiveTeamWonSignal(teamName)
signal informGotDealerSignal(dealer)
signal receivePlayerCouldNotPlayCardBecauseItsNotTurnSignal(playerId)
signal receivePlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHandSignal(playerId)
signal receivePlayerCouldNotPlayCardBecauseItsPlayedAlreadySignal(playerId)
signal receivePlayerCalledVidoSignal(playerId)
signal receivePlayerFromSameTeamCanNotTakeDecisionSignal(playerId)
signal receiveOnlyLeaderCanTakeThisDecisionSignal()
signal receivePlayerRefusedVidoSignal(playerId)
signal receivePlayerRaisedVidoTo7PiedrasSignal(playerId)
signal receivePlayerRaisedVidoTo9PiedrasSignal(playerId)
signal receivePlayerRaisedVidoToChicoSignal(playerId)
signal receivePlayerRaisedVidoToGameSignal(playerId)
signal receivePlayerAcceptedVidoSignal(playerId)
signal receivePlayerRaisedVidoSignal(playerId)

var preGame: PreGame
var game: Game
var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor
var hasGameStarted = false

func _init() -> void:
	gamePlayers = GamePlayers.new()

############## SERVER

func startServer(port = 9000):
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(port)
	if err != OK:
		push_error("❌ Could not start server!")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(onClientConnected)
	print("🟢 Server running on port", port)
	playerInteractor = RealPlayerInteractor.new()
	playerInteractor.connect("sendPlayersAndTeamsSignal", Callable(self, "onReceivedPlayersAndTeams", ))
	playerInteractor.connect("dealHandToPlayerSignal", Callable(self, "onDealtHand", ))
	playerInteractor.connect("dealVirado", Callable(self, "onDealtVirado", ))
	playerInteractor.connect("sendCurrentPlayerTurnSignal", Callable(self, "onPlayerTurn"))
	playerInteractor.connect("sendPlayerPlayedCardSignal", Callable(self, "onPlayedCard"))
	playerInteractor.connect("sendPlayerCouldNotPlayCardBecauseItsNotTurnSignal", Callable(self, "onPlayerCouldNotPlayCardBecauseItsNotTurn"))
	playerInteractor.connect("sendPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHandSignal", Callable(self, "onPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHand"))
	playerInteractor.connect("sendPlayerCouldNotPlayCardBecauseItsPlayedAlreadySignal", Callable(self, "onPlayerCouldNotPlayCardBecauseItsPlayedAlready"))
	playerInteractor.connect("sendPlayerRoundWinnerSignal", Callable(self, "onPlayerRoundWinner"))
	playerInteractor.connect("sendTeamWonChicoPointsSignal", Callable(self, "onTeamWonChicoPoints"))
	playerInteractor.connect("sendTeamWonChicoSignal", Callable(self, "onTeamWonChico"))
	playerInteractor.connect("sendTeamWonSignal", Callable(self, "onTeamWon"))
	playerInteractor.connect("informDealerSignal", Callable(self, "onGotDealer"))
	playerInteractor.connect("informPlayerFromSameTeamCanNotTakeDecisionSignal", Callable(self, "onPlayerFromSameTeamCanNotTakeDecision"))
	playerInteractor.connect("informOnlyLeaderCanTakeThisDecisionSignal", Callable(self, "onOnlyLeaderCanTakeThisDecision"))
	playerInteractor.connect("sendPlayerCalledVidoSignal", Callable(self, "onPlayerCalledVido"))
	playerInteractor.connect("sendPlayerRefusedVidoSignal", Callable(self, "onPlayerRefusedVido"))
	playerInteractor.connect("sendVidoRaisedFor7PiedrasSignal", Callable(self, "onVidoRaisedFor7Piedras"))
	playerInteractor.connect("sendVidoRaisedFor9PiedrasSignal", Callable(self, "onVidoRaisedFor9Piedras"))
	playerInteractor.connect("sendVidoRaisedForChicoSignal", Callable(self, "onVidoRaisedForChico"))
	playerInteractor.connect("sendVidoRaisedForGameSignal", Callable(self, "onVidoRaisedForGame"))



	playerInteractor.name = "Interactor"
	add_child(playerInteractor)
	preGame = PreGame.new(playerInteractor, gamePlayers)
	preGame.name = "Pregame"
	add_child(preGame)

func onClientConnected(id):
	print("🟢 Client connected with id: ", id)

func onReceivedPlayersAndTeams(players: Dictionary, team1: Array[String], team2: Array[String], team1Leader: String, team2Leader: String):
	print("Sending players and teams...")
	print("players: ", players)
	print("team1: ", team1)
	print("team2: ", team2)
	print("teamLeader1: ", team1Leader)
	print("teamLeader2: ", team2Leader )
	rpc("receivePlayersAndTeams", players, team1, team2, team1Leader, team2Leader)

func onDealtHand(player: String, hand: ServerHand):
	print("Dealt hand to player ", gamePlayers.getPlayerName(player), " with cards: ", hand.to_dict())
	rpc_id(int(player),"receiveHand", hand.to_dict())

func onDealtVirado(card: ServerCard):
	print("Dealt virado: ", card.getCardName())
	rpc("receiveVirado", card.to_dict())

func onPlayerTurn(player: String):
	print("Player ", gamePlayers.getPlayerName(player), " turn")
	rpc("receivePlayerTurn", player)

func onPlayerCouldNotPlayCardBecauseItsNotTurn(player: String):	
	print("can not play since its not its turn")
	rpc_id(int(player), "receivePlayerCouldNotPlayCardBecauseItsNotTurn")

func onPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHand(player: String):
	print("can not play since it has already played a card in this hand")
	rpc_id(int(player), "receivePlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHand")

func onPlayerCouldNotPlayCardBecauseItsPlayedAlready(player: String):
	print("can not play since it has already played that card")
	rpc_id(int(player), "receivePlayerCouldNotPlayCardBecauseItsPlayedAlready")

func onPlayedCard(player: String, card: ServerCard, playedOrder: int, cardHandIndex: int):
	print("Player ", gamePlayers.getPlayerName(player), " played its ", cardHandIndex, " card: ", card.getCardName(), " with order: ", playedOrder)
	rpc("receiveCardPlayed", player, card.to_dict(), cardHandIndex)

func onPlayerRoundWinner(player: String, roundScore: int):
	print("Hand winner is %s" % [gamePlayers.getPlayerName(player)])
	print("%s won the hand" % [gamePlayers.getTeam(player)])
	rpc("receivePlayerRoundWinner", player, roundScore)

func onTeamWonChicoPoints(teamName: String, chicoPoints: int):
	rpc("receiveTeamWonChicoPoints", teamName, chicoPoints)

func onTeamWonChico(teamName: String, chicos: int):
	rpc("receiveTeamWonChico", teamName, chicos)

func onTeamWon(teamName: String):
	rpc("receiveTeamWon", teamName)

func onGotDealer(dealer: String):
	rpc("receiveDealer", dealer)

func onPlayerCalledVido(playerId: String):
	print("player %s called vido" % [playerId])
	rpc("receivePlayerCalledVido", playerId)

func onPlayerRefusedVido(playerId):
	print("player %s refused vido" % [playerId])
	rpc("receivePlayerRefusedVido", playerId)

func onVidoRaisedFor7Piedras(playerId):
	print("player %s raised vido to 7 piedras" % [playerId])
	rpc("receivePlayerRaisedVidoTo7Piedras", playerId)

func onVidoRaisedFor9Piedras(playerId):
	print("player %s raised vido to 9 piedras" % [playerId])
	rpc("receivePlayerRaisedVidoTo9Piedras", playerId)

func onVidoRaisedForChico(playerId):
	print("player %s raised vido to chico" % [playerId])
	rpc("receivePlayerRaisedVidoToChico", playerId)

func onVidoRaisedForGame(playerId):
	print("player %s raised vido to game" % [playerId])
	rpc("receivePlayerRaisedVidoToGame", playerId)

func onPlayerAcceptedVido(playerId):
	print("player %s accepted vido" % [playerId])
	rpc("receivePlayerAcceptedVido", playerId)

func onPlayerRaisedVido(playerId):
	print("player %s raised vido" % [playerId])
	rpc("receivePlayerRaisedVido", playerId)

func onPlayerFromSameTeamCanNotTakeDecision(playerId: String):
	print("Player %s can not take the decision since it is from the same team" % playerId)
	rpc_id(int(playerId), "receivePlayerFromSameTeamCanNotTakeDecision")

func onOnlyLeaderCanTakeThisDecision(playerId: String):
	print("Player %s can not take the decision since it is not the leader" % playerId)
	rpc_id(int(playerId), "receiveOnlyLeaderCanTakeThisDecision")


@rpc("any_peer")
func onClientPlayedCard(cardIndex):
	var sender = multiplayer.get_remote_sender_id()
	var playerId = str(sender)
	print("Player ", gamePlayers.getPlayerName(playerId), " attempted to play its ", cardIndex," card.")
	if cardIndex == "1": game.playFirstCard(playerId)
	if cardIndex == "2": game.playSecondCard(playerId)
	if cardIndex == "3": game.playThirdCard(playerId)

@rpc("any_peer")
func onClientChoosesName(chosenName: String):
	var sender = multiplayer.get_remote_sender_id()
	var playerId = str(sender)
	if gamePlayers.playerExists(playerId): return
	print("Player ", playerId, " chose name: ", chosenName)
	preGame.addPlayer(str(sender), chosenName)
	game = preGame.start()
	if game is Game:
		game.newGame()
		for player in gamePlayers.playerIds:
			rpc_id(int(player), "gameStarted")

@rpc("any_peer")
func onClientCalledVido():
	var sender = multiplayer.get_remote_sender_id()
	var playerId = str(sender)
	print("player %s attempts to call vido" % [playerId])
	game.callVido(playerId)

@rpc("any_peer")
func onClientAcceptedVido():
	var sender = multiplayer.get_remote_sender_id()
	var playerId = str(sender)
	print("player %s attempts to accepts the vido" % [playerId])
	game.acceptVido(playerId)

@rpc("any_peer")
func onClientRejectedVido():
	var sender = multiplayer.get_remote_sender_id()
	var playerId = str(sender)
	print("player %s attempts to reject the vido" % [playerId])
	game.rejectVido(playerId)

@rpc("any_peer")
func onClientRaisedVido():
	var sender = multiplayer.get_remote_sender_id()
	var playerId = str(sender)
	print("player %s attempts to raise the vido" % [playerId])
	game.raiseVido(playerId)


################ CLIENT

func connectClient(ip = "127.0.0.1", port = 9000):
	if multiplayer.has_multiplayer_peer() and not multiplayer.is_server():
		print("⚠️ Already connected — ignoring request.")
		return
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip, port)
	if err != OK:
		push_error("❌ Could not connect to server!")
		return
	multiplayer.multiplayer_peer = peer
	clientConnectedSignal.emit()

@rpc("authority")
func receivePlayersAndTeams(players: Dictionary, team1: Array[String], team2: Array[String], team1Leader: String, team2Leader: String):
	receivedPlayersAndTeamsSignal.emit(players, team1, team2, team1Leader, team2Leader)
	
@rpc("authority")
func receiveHand(hand: Dictionary):
	cardsReceivedSignal.emit(hand)

@rpc("authority")
func receiveVirado(virado: Dictionary):
	viradoReceivedSignal.emit(virado)

@rpc("authority")
func gameStarted():
	gameStartedSignal.emit()

@rpc("authority")
func receivePlayerTurn(player: String):
	receivedPlayedTurnSignal.emit(player)

@rpc("authority")
func receiveCardPlayed(player: String, card: Dictionary, cardHandIndex: int):
	receiveCardPlayedSignal.emit(player, card, cardHandIndex)

@rpc("authority")
func receivePlayerRoundWinner(player: String, roundScore: int):
	receivePlayerRoundWinnerSignal.emit(player, roundScore)

@rpc("authority")
func receiveTeamWonChicoPoints(teamName: String, chicoPoints: int):
	receiveTeamWonChicoPointsSignal.emit(teamName, chicoPoints)

@rpc("authority")
func receiveTeamWonChico(teamName: String, chicos: int):
	receiveTeamWonChicoSignal.emit(teamName, chicos)

@rpc("authority")
func receiveTeamWon(teamName: String):
	receiveTeamWonSignal.emit(teamName)

@rpc("authority")
func receiveDealer(dealer: String):
	informGotDealerSignal.emit(dealer)

@rpc("authority")
func receivePlayerCouldNotPlayCardBecauseItsNotTurn(player: String):
	receivePlayerCouldNotPlayCardBecauseItsNotTurnSignal.emit(player)

@rpc("authority")
func receivePlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHand(player: String):
	receivePlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHandSignal.emit(player)

@rpc("authority")
func receivePlayerCouldNotPlayCardBecauseItsPlayedAlready(player: String):
	receivePlayerCouldNotPlayCardBecauseItsPlayedAlreadySignal.emit(player)

@rpc("authority")
func receivePlayerCalledVido(playerId: String):
	receivePlayerCalledVidoSignal.emit(playerId)

@rpc("authority")
func receivePlayerRefusedVido(playerId: String):
	receivePlayerRefusedVidoSignal.emit(playerId)

@rpc("authority")
func receivePlayerRaisedVidoTo7Piedras(playerId: String):
	receivePlayerRaisedVidoTo7PiedrasSignal.emit(playerId)

@rpc("authority")
func receivePlayerRaisedVidoTo9Piedras(playerId: String):
	receivePlayerRaisedVidoTo9PiedrasSignal.emit(playerId)

@rpc("authority")
func receivePlayerRaisedVidoToChico(playerId: String):
	receivePlayerRaisedVidoToChicoSignal.emit(playerId)

@rpc("authority")
func receivePlayerRaisedVidoToGame(playerId: String):
	receivePlayerRaisedVidoToGameSignal.emit(playerId)

@rpc("authority")
func receivePlayerAcceptedVido(playerId):
	receivePlayerAcceptedVidoSignal.emit(playerId)

@rpc("authority")
func receivePlayerRaisedVido(playerId):
	receivePlayerRaisedVidoSignal.emit(playerId)

@rpc("authority")
func receivePlayerFromSameTeamCanNotTakeDecision(playerId: String):
	receivePlayerFromSameTeamCanNotTakeDecisionSignal.emit(playerId)

@rpc("authority")
func receiveOnlyLeaderCanTakeThisDecision():
	receiveOnlyLeaderCanTakeThisDecisionSignal.emit()

func playCard(cardIndex: String) -> void:
	if cardIndex not in CardIndex.values():
		push_error("Invalid cardIndex: " + cardIndex)
		return

	rpc_id(1, "onClientPlayedCard", cardIndex)

func chooseName(playerName: String) -> void:
	rpc_id(1, "onClientChoosesName", playerName)

func callVido() -> void:
	rpc_id(1, "onClientCalledVido")

func acceptVido() -> void:
	rpc_id(1, "onClientAcceptedVido")

func rejectVido() -> void:
	rpc_id(1, "onClientRejectedVido")

func raisedVido() -> void:
	rpc_id(1, "onClientRaisedVido")
