extends Node

class_name ServerManager

const CardIndex = {
	CARD_1 = "1",
	CARD_2 = "2",
	CARD_3 = "3"
}

signal clientConnectedSignal()
signal receiveClientIdSignal(playerId)
signal cardsReceivedSignal(cards)
signal viradoReceivedSignal(virado)
signal gameStartedSignal()
signal receivedPlayedTurnSignal(playerId)
signal receiveCardPlayedSignal(playerId, card, playedOrder)
signal receivePlayerRoundWinnerSignal(playerId, card, playedOrder)
signal receivedPlayersAndTeamsSignal(players, team1, team2)
signal receivedPlayerAddedSignal(players, team1, team2)
signal receiveTeamWonPiedrasSignal(teamName, piedras)
signal receiveTeamWonChicoSignal(teamName, chicos)
signal receiveTeamWonSignal(teamName)
signal informGotDealerSignal(dealer)
signal receivePlayerCouldNotPlayCardBecauseItsNotTurnSignal()
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
signal receiveVidoCanOnlyBeCalledOnYourTurnSignal()
signal receivePlayerCantBeAddedSinceMaxIsReachedSignal()
signal receiveGameCanNotStartSinceTheMinimumOfPlayersIsNotReachedSignal()
signal receivePlayerIsGameOwnerSignal(playerId)
signal receiveTriumphsConfigurationSignal(triumphs)
signal receiveCannNotPlayCardBecauseTumboIsBeingDecidedSignal()
signal receiveCannNotCallVidoBecauseTumboIsBeingDecidedSignal()
signal receiveTeam1IsOnTumboSignal()
signal receiveTeam2IsOnTumboSignal()
signal receiveCannNotTakeThisDecisionIfNotInWaitingForTumboSignal()
signal receiveTumboIsAcceptedSignal()
signal receiveTumboIsRejectedSignal()
signal receiveCanNotMakeTheActionAfterTheGameEndedSignal()
signal receivedGameAssignedSignal(gameId: String)

var sessions := {} 
var playerToGame := {} 

func getSessionByPeer(peerId):
	var gameId = playerToGame.get(peerId, null)
	if not gameId or not sessions.has(gameId):
		print("❌ Partida no encontrada para jugador ", peerId)
		return null
	return sessions[gameId]

func getPlayersFromGameId(gameId: String) -> GamePlayers:
	return sessions[gameId].gamePlayers

func sendToAllPlayers(gameId: String, rpcMethod: String, args := []):
	var session: GameSession = sessions[gameId]
	if not session: return
	for peerIdString in session.gamePlayers.playerIds:
		var peerId = int(peerIdString)
		if args.size() == 0:
			rpc_id(peerId, rpcMethod)
		elif args.size() == 1:
			rpc_id(peerId, rpcMethod, args[0])
		elif args.size() == 2:
			rpc_id(peerId, rpcMethod, args[0], args[1])
		elif args.size() == 3:
			rpc_id(peerId, rpcMethod, args[0], args[1], args[2])
		elif args.size() == 4:
			rpc_id(peerId, rpcMethod, args[0], args[1], args[2], args[3])
		elif args.size() == 5:
			rpc_id(peerId, rpcMethod, args[0], args[1], args[2], args[3], args[4])
		elif args.size() == 6:
			rpc_id(peerId, rpcMethod, args[0], args[1], args[2], args[3], args[4])
		else:
			push_error("❌ call_rpc_id: Demasiados argumentos.")


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

func connectPlayerInteractorSignals(interactor: PlayerInteractor):
	interactor.connect("sendPlayersAndTeamsSignal", Callable(self, "onReceivedPlayersAndTeams", ))
	interactor.connect("sendPlayerAddedSignal", Callable(self, "onPlayerAdded", ))
	interactor.connect("dealHandToPlayerSignal", Callable(self, "onDealtHand", ))
	interactor.connect("dealVirado", Callable(self, "onDealtVirado", ))
	interactor.connect("sendCurrentPlayerTurnSignal", Callable(self, "onPlayerTurn"))
	interactor.connect("sendPlayerPlayedCardSignal", Callable(self, "onPlayedCard"))
	interactor.connect("sendPlayerCouldNotPlayCardBecauseItsNotTurnSignal", Callable(self, "onPlayerCouldNotPlayCardBecauseItsNotTurn"))
	interactor.connect("sendPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHandSignal", Callable(self, "onPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHand"))
	interactor.connect("sendPlayerCouldNotPlayCardBecauseItsPlayedAlreadySignal", Callable(self, "onPlayerCouldNotPlayCardBecauseItsPlayedAlready"))
	interactor.connect("sendPlayerRoundWinnerSignal", Callable(self, "onPlayerRoundWinner"))
	interactor.connect("sendTeamWonPiedrasSignal", Callable(self, "onTeamWonPiedras"))
	interactor.connect("sendTeamWonChicoSignal", Callable(self, "onTeamWonChico"))
	interactor.connect("sendTeamWonSignal", Callable(self, "onTeamWon"))
	interactor.connect("informDealerSignal", Callable(self, "onGotDealer"))
	interactor.connect("informPlayerFromSameTeamCanNotTakeDecisionSignal", Callable(self, "onPlayerFromSameTeamCanNotTakeDecision"))
	interactor.connect("informOnlyLeaderCanTakeThisDecisionSignal", Callable(self, "onOnlyLeaderCanTakeThisDecision"))
	interactor.connect("sendPlayerCalledVidoSignal", Callable(self, "onPlayerCalledVido"))
	interactor.connect("sendPlayerRefusedVidoSignal", Callable(self, "onPlayerRefusedVido"))
	interactor.connect("sendVidoRaisedFor7PiedrasSignal", Callable(self, "onVidoRaisedFor7Piedras"))
	interactor.connect("sendVidoRaisedFor9PiedrasSignal", Callable(self, "onVidoRaisedFor9Piedras"))
	interactor.connect("sendVidoRaisedForChicoSignal", Callable(self, "onVidoRaisedForChico"))
	interactor.connect("sendVidoRaisedForGameSignal", Callable(self, "onVidoRaisedForGame"))
	interactor.connect("informVidoCanOnlyBeCalledOnYourTurnSignal", Callable(self, "onVidoCanOnlyBeCalledOnYourTurn"))
	interactor.connect("sendPlayerAcceptedVidoSignal", Callable(self, "onPlayerAcceptedVido"))
	interactor.connect("informPlayerCantBeAddedSinceMaxIsReachedSignal", Callable(self, "onInformPlayerCantBeAddedSinceMaxIsReached"))
	interactor.connect("informGameCanNotStartSinceItsNotOwnerSignal", Callable(self, "onInformGameCanNotStartSinceItsNotOwner"))
	interactor.connect("informIsGameOwnerSignal", Callable(self, "onInformIsGameOwner"))
	interactor.connect("informGameCanNotStartSinceTheMinimumOfPlayersIsNotReachedSignal", Callable(self, "onInformGameCanNotStartSinceTheMinimumOfPlayersIsNotReached"))
	interactor.connect("informTriumphsConfigurationSignal", Callable(self, "onInformTriumphsConfiguration"))
	interactor.connect("informCannNotPlayCardBecauseTumboIsBeingDecidedSignal", Callable(self, "onInformCannNotPlayCardBecauseTumboIsBeingDecided"))
	interactor.connect("informCannNotCallVidoBecauseTumboIsBeingDecidedSignal", Callable(self, "onInformCannNotCallVidoBecauseTumboIsBeingDecided"))
	interactor.connect("informTeam1IsOnTumboSignal", Callable(self, "onInformTeam1IsOnTumbo"))
	interactor.connect("informTeam2IsOnTumboSignal", Callable(self, "onInformTeam2IsOnTumbo"))
	interactor.connect("informCannNoTakeThisDecisionIfNotInWaitingForTumboSignal", Callable(self, "onInformCannNoTakeThisDecisionIfNotInWaitingForTumbo"))
	interactor.connect("informTumboIsAcceptedSignal", Callable(self, "onInformTumboIsAccepted"))
	interactor.connect("informTumboIsRejectedSignal", Callable(self, "onInformTumboIsRejected"))
	interactor.connect("informCanNotMakeTheActionAfterTheGameEndedSignal", Callable(self, "onInformCanNotMakeTheActionAfterTheGameEnded"))

func onClientConnected(id):
	print("🟢 Client connected with id: ", id)
	rpc_id(id, "receiveClientId", str(id))

func onReceivedPlayersAndTeams(gameId: String, players: Dictionary, team1: Array[String], team2: Array[String], team1Leader: String, team2Leader: String):
	sendToAllPlayers(gameId,"receivePlayersAndTeams", [players, team1, team2, team1Leader, team2Leader])

func onPlayerAdded(gameId: String, players: Dictionary, team1: Array[String], team2: Array[String], team1Leader: String, team2Leader: String):
	sendToAllPlayers(gameId,"receivePlayerAdded", [players, team1, team2, team1Leader, team2Leader])

func onDealtHand(gameId: String, player: String, hand: ServerHand):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("Dealt hand to player ", gamePlayers.getPlayerName(player), " with cards: ", hand.to_dict())
	rpc_id(int(player),"receiveHand", hand.to_dict())

func onDealtVirado(gameId: String, card: ServerCard):
	print("Dealt virado: ", card.getCardName())
	sendToAllPlayers(gameId,"receiveVirado", [card.to_dict()])

func onPlayerTurn(gameId: String, player: String):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("Player ", gamePlayers.getPlayerName(player), " turn")
	sendToAllPlayers(gameId,"receivePlayerTurn", [player])

func onPlayerCouldNotPlayCardBecauseItsNotTurn(player: String):	
	print("can not play since its not its turn")
	rpc_id(int(player), "receivePlayerCouldNotPlayCardBecauseItsNotTurn")

func onPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHand(player: String):
	print("can not play since it has already played a card in this hand")
	rpc_id(int(player), "receivePlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHand")

func onPlayerCouldNotPlayCardBecauseItsPlayedAlready(player: String):
	print("can not play since it has already played that card")
	rpc_id(int(player), "receivePlayerCouldNotPlayCardBecauseItsPlayedAlready")

func onPlayedCard(gameId: String, player: String, card: ServerCard, playedOrder: int, cardHandIndex: int):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("Player ", gamePlayers.getPlayerName(player), " played its ", cardHandIndex, " card: ", card.getCardName(), " with order: ", playedOrder)
	sendToAllPlayers(gameId,"receiveCardPlayed", [player, card.to_dict(), cardHandIndex])

func onPlayerRoundWinner(gameId: String, player: String, roundScore: int):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("Hand winner is %s" % [gamePlayers.getPlayerName(player)])
	print("%s won the hand" % [gamePlayers.getTeam(player)])
	sendToAllPlayers(gameId,"receivePlayerRoundWinner", [player, roundScore])

func onTeamWonPiedras(gameId: String, teamName: String, piedras: int, piedrasOnPlay: int):
	print("Team " + teamName + " won " + str(piedrasOnPlay) + " piedras, summing " + str(piedras) + " piedras")
	sendToAllPlayers(gameId,"receivePlayerRoundWinner", [receiveTeamWonPiedras, piedras])

func onTeamWonChico(gameId: String, teamName: String, chicos: int):
	print("Team " + teamName + " won a chico")
	sendToAllPlayers(gameId,"receiveTeamWonChico", [teamName, chicos])

func onTeamWon(gameId: String, teamName: String):
	print("Team " + teamName + " won the game")
	sendToAllPlayers(gameId,"receiveTeamWon", [teamName])

func onGotDealer(gameId: String, dealer: String):
	sendToAllPlayers(gameId,"receiveDealer", [dealer])

func onPlayerCalledVido(gameId: String, playerId: String):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("player %s called vido" %  [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerCalledVido", [playerId])

func onVidoRaisedFor7Piedras(gameId: String, playerId):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("player %s raised vido to 7 piedras" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRaisedVidoTo7Piedras", [playerId])

func onVidoRaisedFor9Piedras(gameId: String, playerId):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("player %s raised vido to 9 piedras" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRaisedVidoTo9Piedras", [playerId])

func onVidoRaisedForChico(gameId: String, playerId):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("player %s raised vido to chico" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRaisedVidoToChico", [playerId])

func onVidoRaisedForGame(gameId: String, playerId):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("player %s raised vido to game" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRaisedVidoToGame", [playerId])

func onPlayerRefusedVido(gameId: String, playerId):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("player %s refused vido" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRefusedVido", [playerId])

func onPlayerAcceptedVido(gameId: String, playerId):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("player %s accepted vido" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerAcceptedVido", [playerId])

func onPlayerRaisedVido(gameId: String, playerId):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("player %s raised vido" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRaisedVido", [playerId])

func onPlayerFromSameTeamCanNotTakeDecision(gameId: String, playerId: String):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("Player %s can not take the decision since it is from the same team" % [gamePlayers.getPlayerName(playerId)])
	rpc_id(int(playerId), "receivePlayerFromSameTeamCanNotTakeDecision")

func onOnlyLeaderCanTakeThisDecision(gameId: String, playerId: String):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("Player %s can not take the decision since it is not the leader" % [gamePlayers.getPlayerName(playerId)])
	rpc_id(int(playerId), "receiveOnlyLeaderCanTakeThisDecision")

func onVidoCanOnlyBeCalledOnYourTurn(gameId: String, playerId: String):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("Player %s can not call the vido since its not its turn" % [gamePlayers.getPlayerName(playerId)])
	rpc_id(int(playerId), "receiveVidoCanOnlyBeCalledOnYourTurn")

func onInformPlayerCantBeAddedSinceMaxIsReached(gameId: String, playerId: String):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("Player %s can not be added since max players is reached" % [gamePlayers.getPlayerName(playerId)])
	rpc_id(int(playerId), "receivePlayerCantBeAddedSinceMaxIsReached")

func onInformGameCanNotStartSinceItsNotOwner(gameId: String, playerId: String):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("Player %s can not start the game since it is not the owner" % [gamePlayers.getPlayerName(playerId)])

func onInformIsGameOwner(gameId: String, playerId: String):
	var gamePlayers = getPlayersFromGameId(gameId)
	print("Informing that %s is the game owner" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId, "receivePlayerIsGameOwner", [playerId])

func onInformGameCanNotStartSinceTheMinimumOfPlayersIsNotReached(playerId):
	print("Game can not start since the minimum of players is not reached")
	rpc_id(int(playerId), "receiveGameCanNotStartSinceTheMinimumOfPlayersIsNotReached")

func onInformTriumphsConfiguration(gameId: String, triumphs: Array[Dictionary]):
	print("Informing current triumphs configuration")
	for triumph in triumphs:
		print(triumph)
	sendToAllPlayers(gameId, "receiveTriumphsConfiguration", [triumphs])

func onInformCannNotPlayCardBecauseTumboIsBeingDecided(playerId: String):
	rpc_id(int(playerId), "receiveCannNotPlayCardBecauseTumboIsBeingDecided")

func onInformCannNotCallVidoBecauseTumboIsBeingDecided(playerId: String):
	rpc_id(int(playerId), "receiveCannNotCallVidoBecauseTumboIsBeingDecided")

func onInformTeam1IsOnTumbo(gameId: String):
	sessions[gameId].sendToAllPlayers("receiveTeam1IsOnTumbo")

func onInformTeam2IsOnTumbo(gameId: String):
	sessions[gameId].sendToAllPlayers("receiveTeam2IsOnTumbo")

func onInformCannNoTakeThisDecisionIfNotInWaitingForTumbo(playerId: String):
	rpc_id(int(playerId), "receiveCannNotTakeThisDecisionIfNotInWaitingForTumbo")

func onInformTumboIsAccepted(gameId: String):
	sessions[gameId].sendToAllPlayers("receiveTumboIsAccepted")

func onInformTumboIsRejected(gameId: String):
	sessions[gameId].sendToAllPlayers("receiveTumboIsRejected")

func onInformCanNotMakeTheActionAfterTheGameEnded(playerId: String):
	rpc_id(int(playerId), "receiveCanNotMakeTheActionAfterTheGameEnded")

@rpc("any_peer")
func onClientPlayedCard(cardIndex):
	var sender = multiplayer.get_remote_sender_id()
	var session = getSessionByPeer(sender)
	if session and session.game:
		var playerId = str(sender)
		print("Player ", session.gamePlayers.getPlayerName(playerId), " attempted to play its ", cardIndex," card.")
		match cardIndex:
			"1": session.game.playFirstCard(playerId)
			"2": session.game.playSecondCard(playerId)
			"3": session.game.playThirdCard(playerId)


@rpc("any_peer")
func onClientChoosesName(chosenName: String):
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = getSessionByPeer(sender)
	if not session: return
	var preGame = session.preGame
	var playerId = str(sender)
	if preGame.gamePlayers.playerExists(playerId): return
	preGame.addPlayer(str(sender), chosenName)
	print("Player ", playerId, " chose name: ", chosenName)


@rpc("any_peer")
func onClientCalledVido():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = getSessionByPeer(sender)
	if not session: return
	var gamePlayers = session.gamePlayers
	var playerId = str(sender)
	var game = session.game
	print("player %s attempts to call vido" % [gamePlayers.getPlayerName(playerId)])
	game.callVido(playerId)

@rpc("any_peer")
func onClientAcceptedVido():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = getSessionByPeer(sender)
	if not session: return
	var gamePlayers = session.gamePlayers
	var playerId = str(sender)
	var game = session.game
	print("player %s attempts to accepts the vido" % [gamePlayers.getPlayerName(playerId)])
	game.acceptVido(playerId)

@rpc("any_peer")
func onClientRejectedVido():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = getSessionByPeer(sender)
	if not session: return
	var gamePlayers = session.gamePlayers
	var playerId = str(sender)
	var game = session.game
	print("player %s attempts to reject the vido" % [gamePlayers.getPlayerName(playerId)])
	game.rejectVido(playerId)

@rpc("any_peer")
func onClientRaisedVido():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = getSessionByPeer(sender)
	if not session: return
	var gamePlayers = session.gamePlayers
	var playerId = str(sender)
	var game = session.game
	print("player %s attempts to raise the vido" % [gamePlayers.getPlayerName(playerId)])
	game.raiseVido(playerId)

@rpc("any_peer")
func onClientStartedGame():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = getSessionByPeer(sender)
	if not session: return
	var playerId = str(sender)
	var game = session.preGame.start(playerId)
	if game is Game:
		game.newGame()
		sessions[session.gameId]["game"] = game
		sendToAllPlayers(session.gameId, "gameStarted")

@rpc("any_peer")
func onClientTumbar():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = getSessionByPeer(sender)
	if not session: return
	var playerId = str(sender)
	var game = session.game
	game.takeTumbo(playerId)

@rpc("any_peer")
func onClientAchicarse():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = getSessionByPeer(sender)
	if not session: return
	var playerId = str(sender)
	var game = session.game
	game.achicarse(playerId)

@rpc("any_peer")
func onClientRequestsCreateGame():
	var sender = multiplayer.get_remote_sender_id()
	var gameId = str("game_" + str(sessions.size()))

	var interactor = RealPlayerInteractor.new(gameId)	
	connectPlayerInteractorSignals(interactor)
	var session = GameSession.new(gameId, interactor)
	sessions[gameId] = session
	add_child(session)
	playerToGame[sender] = gameId

	print("✅ Nueva partida creada con ID:", gameId)
	print("🟢 Jugador ", sender, " creó y se unió a la partida ",gameId)
	rpc_id(sender, "receiveGameAssigned", gameId) 

@rpc("any_peer")
func onClientRequestsJoinGame(gameId):
	var sender = multiplayer.get_remote_sender_id()
	if not sessions.has(gameId):
		print("❌ Partida no encontrada:", gameId)
		rpc_id(sender, "receiveGameJoinFailed", "No existe esa partida.")
		return

	playerToGame[sender] = gameId

	print("🟢 Jugador ", sender, " se unió a la partida ", gameId)
	rpc_id(sender, "receiveGameAssigned", gameId)
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
func receiveClientId(playerId: String):
	receiveClientIdSignal.emit(playerId)

@rpc("authority")
func receivePlayersAndTeams(players: Dictionary, team1: Array[String], team2: Array[String], team1Leader: String, team2Leader: String):
	receivedPlayersAndTeamsSignal.emit(players, team1, team2, team1Leader, team2Leader)

@rpc("authority")
func receivePlayerAdded(players: Dictionary, team1: Array[String], team2: Array[String], team1Leader: String, team2Leader: String):
	receivedPlayerAddedSignal.emit(players, team1, team2, team1Leader, team2Leader)
	
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
func receiveTeamWonPiedras(teamName: String, piedras: int):
	receiveTeamWonPiedrasSignal.emit(teamName, piedras)

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
func receivePlayerCouldNotPlayCardBecauseItsNotTurn():
	receivePlayerCouldNotPlayCardBecauseItsNotTurnSignal.emit()

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
func receivePlayerAcceptedVido(playerId):
	receivePlayerAcceptedVidoSignal.emit(playerId)

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
func receivePlayerFromSameTeamCanNotTakeDecision(playerId: String):
	receivePlayerFromSameTeamCanNotTakeDecisionSignal.emit(playerId)

@rpc("authority")
func receiveOnlyLeaderCanTakeThisDecision():
	receiveOnlyLeaderCanTakeThisDecisionSignal.emit()

@rpc("authority")
func receiveVidoCanOnlyBeCalledOnYourTurn():
	receiveVidoCanOnlyBeCalledOnYourTurnSignal.emit()

@rpc("authority")
func receivePlayerCantBeAddedSinceMaxIsReached():
	receivePlayerCantBeAddedSinceMaxIsReachedSignal.emit()

@rpc("authority")
func receivePlayerIsGameOwner(playerId: String):
	receivePlayerIsGameOwnerSignal.emit(playerId)

@rpc("authority")
func receiveGameCanNotStartSinceTheMinimumOfPlayersIsNotReached():
	receiveGameCanNotStartSinceTheMinimumOfPlayersIsNotReachedSignal.emit()

@rpc("authority")
func receiveTriumphsConfiguration(triumphs: Array[Dictionary]):
	receiveTriumphsConfigurationSignal.emit(triumphs)

@rpc("authority")
func receiveCannNotPlayCardBecauseTumboIsBeingDecided():
	receiveCannNotPlayCardBecauseTumboIsBeingDecidedSignal.emit()

@rpc("authority")
func receiveCannNotCallVidoBecauseTumboIsBeingDecided():
	receiveCannNotCallVidoBecauseTumboIsBeingDecidedSignal.emit()

@rpc("authority")
func receiveTeam1IsOnTumbo():
	receiveTeam1IsOnTumboSignal.emit()

@rpc("authority")
func receiveTeam2IsOnTumbo():
	receiveTeam2IsOnTumboSignal.emit()

@rpc("authority")
func receiveCannNotTakeThisDecisionIfNotInWaitingForTumbo():
	receiveCannNotTakeThisDecisionIfNotInWaitingForTumboSignal.emit()

@rpc("authority")
func receiveTumboIsAccepted():
	receiveTumboIsAcceptedSignal.emit()

@rpc("authority")
func receiveTumboIsRejected():
	receiveTumboIsRejectedSignal.emit()

@rpc("authority")
func receiveCanNotMakeTheActionAfterTheGameEnded():
	receiveCanNotMakeTheActionAfterTheGameEndedSignal.emit()

@rpc("authority")
func receiveGameAssigned(gameId: String):
	receivedGameAssignedSignal.emit(gameId)


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

func startGame() -> void:
	rpc_id(1, "onClientStartedGame")

func tumbar() -> void:
	rpc_id(1, "onClientTumbar")

func achicarse() -> void:
	rpc_id(1, "onClientAchicarse")

func clientRequestsCreateGame() -> void:
	rpc_id(1, "onClientRequestsCreateGame")

func clientRequestsJoinGame(gameId: String) -> void:
	rpc_id(1, "onClientRequestsJoinGame", gameId)
