extends GameControllerInterface

class_name ServerGameController

var gameSessions: GameSessions

func _init(_gameSessions: GameSessions) -> void:
	gameSessions = _gameSessions

func sendToAllPlayers(gameId: String, rpcMethod: String, args := []):
	var session: GameSession = gameSessions.sessions[gameId]
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

func connectPlayerInteractorSignals(interactor: PlayerInteractor):
	interactor.connect("sendPlayersAndTeamsSignal", Callable(self, "onReceivedPlayersAndTeams", ))
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
	interactor.connect("informGameCanNotStartSinceTheMinimumOfPlayersIsNotReachedSignal", Callable(self, "onInformGameCanNotStartSinceTheMinimumOfPlayersIsNotReached"))
	interactor.connect("informCannNotPlayCardBecauseTumboIsBeingDecidedSignal", Callable(self, "onInformCannNotPlayCardBecauseTumboIsBeingDecided"))
	interactor.connect("informCannNotCallVidoBecauseTumboIsBeingDecidedSignal", Callable(self, "onInformCannNotCallVidoBecauseTumboIsBeingDecided"))
	interactor.connect("informTeam1IsOnTumboSignal", Callable(self, "onInformTeam1IsOnTumbo"))
	interactor.connect("informTeam2IsOnTumboSignal", Callable(self, "onInformTeam2IsOnTumbo"))
	interactor.connect("informCannNoTakeThisDecisionIfNotInWaitingForTumboSignal", Callable(self, "onInformCannNoTakeThisDecisionIfNotInWaitingForTumbo"))
	interactor.connect("informTumboIsAcceptedSignal", Callable(self, "onInformTumboIsAccepted"))
	interactor.connect("informTumboIsRejectedSignal", Callable(self, "onInformTumboIsRejected"))
	interactor.connect("informCanNotMakeTheActionAfterTheGameEndedSignal", Callable(self, "onInformCanNotMakeTheActionAfterTheGameEnded"))

func onReceivedPlayersAndTeams(gameId: String, players: Dictionary, team1: Array[String], team2: Array[String], team1Leader: String, team2Leader: String):
	sendToAllPlayers(gameId,"receivePlayersAndTeams", [players, team1, team2, team1Leader, team2Leader])

func onDealtHand(gameId: String, player: String, hand: ServerHand):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("Dealt hand to player ", gamePlayers.getPlayerName(player), " with cards: ", hand.to_dict())
	rpc_id(int(player),"receiveHand", hand.to_dict())

func onDealtVirado(gameId: String, card: ServerCard):
	print("Dealt virado: ", card.getCardName())
	sendToAllPlayers(gameId,"receiveVirado", [card.to_dict()])

func onPlayerTurn(gameId: String, player: String):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
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
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("Player ", gamePlayers.getPlayerName(player), " played its ", cardHandIndex, " card: ", card.getCardName(), " with order: ", playedOrder)
	sendToAllPlayers(gameId,"receiveCardPlayed", [player, card.to_dict(), cardHandIndex])

func onPlayerRoundWinner(gameId: String, player: String, roundScore: int):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("Hand winner is %s" % [gamePlayers.getPlayerName(player)])
	print("%s won the hand" % [gamePlayers.getTeam(player)])
	sendToAllPlayers(gameId,"receivePlayerRoundWinner", [player, roundScore])

func onTeamWonPiedras(gameId: String, teamName: String, piedras: int, piedrasOnPlay: int):
	print("Team " + teamName + " won " + str(piedrasOnPlay) + " piedras, summing " + str(piedras) + " piedras")
	sendToAllPlayers(gameId,"receiveTeamWonPiedras", [teamName, piedras])

func onTeamWonChico(gameId: String, teamName: String, chicos: int):
	print("Team " + teamName + " won a chico")
	sendToAllPlayers(gameId,"receiveTeamWonChico", [teamName, chicos])

func onTeamWon(gameId: String, teamName: String):
	print("Team " + teamName + " won the game")
	sendToAllPlayers(gameId,"receiveTeamWon", [teamName])

func onGotDealer(gameId: String, dealer: String):
	sendToAllPlayers(gameId, "receiveDealer", [dealer])

func onPlayerCalledVido(gameId: String, playerId: String):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("player %s called vido" %  [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerCalledVido", [playerId])

func onVidoRaisedFor7Piedras(gameId: String, playerId):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("player %s raised vido to 7 piedras" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRaisedVidoTo7Piedras", [playerId])

func onVidoRaisedFor9Piedras(gameId: String, playerId):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("player %s raised vido to 9 piedras" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRaisedVidoTo9Piedras", [playerId])

func onVidoRaisedForChico(gameId: String, playerId):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("player %s raised vido to chico" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRaisedVidoToChico", [playerId])

func onVidoRaisedForGame(gameId: String, playerId):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("player %s raised vido to game" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRaisedVidoToGame", [playerId])

func onPlayerRefusedVido(gameId: String, playerId):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("player %s refused vido" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRefusedVido", [playerId])

func onPlayerAcceptedVido(gameId: String, playerId):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("player %s accepted vido" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerAcceptedVido", [playerId])

func onPlayerRaisedVido(gameId: String, playerId):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("player %s raised vido" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId,"receivePlayerRaisedVido", [playerId])

func onPlayerFromSameTeamCanNotTakeDecision(gameId: String, playerId: String):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("Player %s can not take the decision since it is from the same team" % [gamePlayers.getPlayerName(playerId)])
	rpc_id(int(playerId), "receivePlayerFromSameTeamCanNotTakeDecision")

func onOnlyLeaderCanTakeThisDecision(gameId: String, playerId: String):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("Player %s can not take the decision since it is not the leader" % [gamePlayers.getPlayerName(playerId)])
	rpc_id(int(playerId), "receiveOnlyLeaderCanTakeThisDecision")

func onVidoCanOnlyBeCalledOnYourTurn(gameId: String, playerId: String):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("Player %s can not call the vido since its not its turn" % [gamePlayers.getPlayerName(playerId)])
	rpc_id(int(playerId), "receiveVidoCanOnlyBeCalledOnYourTurn")

func onInformPlayerCantBeAddedSinceMaxIsReached(gameId: String, playerId: String):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("Player %s can not be added since max players is reached" % [gamePlayers.getPlayerName(playerId)])
	rpc_id(int(playerId), "receivePlayerCantBeAddedSinceMaxIsReached")

func onInformGameCanNotStartSinceItsNotOwner(gameId: String, playerId: String):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("Player %s can not start the game since it is not the owner" % [gamePlayers.getPlayerName(playerId)])

func onInformGameCanNotStartSinceTheMinimumOfPlayersIsNotReached(playerId):
	print("Game can not start since the minimum of players is not reached")
	rpc_id(int(playerId), "receiveGameCanNotStartSinceTheMinimumOfPlayersIsNotReached")

func onInformCannNotPlayCardBecauseTumboIsBeingDecided(playerId: String):
	rpc_id(int(playerId), "receiveCannNotPlayCardBecauseTumboIsBeingDecided")

func onInformCannNotCallVidoBecauseTumboIsBeingDecided(playerId: String):
	rpc_id(int(playerId), "receiveCannNotCallVidoBecauseTumboIsBeingDecided")

func onInformTeam1IsOnTumbo(gameId: String):
	gameSessions.sessions[gameId].sendToAllPlayers("receiveTeam1IsOnTumbo")

func onInformTeam2IsOnTumbo(gameId: String):
	gameSessions.sessions[gameId].sendToAllPlayers("receiveTeam2IsOnTumbo")

func onInformCannNoTakeThisDecisionIfNotInWaitingForTumbo(playerId: String):
	rpc_id(int(playerId), "receiveCannNotTakeThisDecisionIfNotInWaitingForTumbo")

func onInformTumboIsAccepted(gameId: String):
	gameSessions.sessions[gameId].sendToAllPlayers("receiveTumboIsAccepted")

func onInformTumboIsRejected(gameId: String):
	gameSessions.sessions[gameId].sendToAllPlayers("receiveTumboIsRejected")

func onInformCanNotMakeTheActionAfterTheGameEnded(playerId: String):
	rpc_id(int(playerId), "receiveCanNotMakeTheActionAfterTheGameEnded")

@rpc("any_peer")
func onClientNotifiesItJoinedGame():
	var sender = multiplayer.get_remote_sender_id()
	var session = gameSessions.getSessionByPeer(sender)
	session.addPlayerToJoinedPlayers(str(sender))
	if session.allPlayersHaveJoined(): 
		connectPlayerInteractorSignals(session.interactor)
		session.startGame() 

@rpc("any_peer")
func onClientPlayedCard(cardIndex):
	var sender = multiplayer.get_remote_sender_id()
	var session = gameSessions.getSessionByPeer(sender)
	if session and session.game:
		var playerId = str(sender)
		print("Player ", session.gamePlayers.getPlayerName(playerId), " attempted to play its ", cardIndex," card.")
		match cardIndex:
			"1": session.game.playFirstCard(playerId)
			"2": session.game.playSecondCard(playerId)
			"3": session.game.playThirdCard(playerId)

@rpc("any_peer")
func onClientCalledVido():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = gameSessions.getSessionByPeer(sender)
	if not session: return
	var gamePlayers = session.gamePlayers
	var playerId = str(sender)
	var game = session.game
	print("player %s attempts to call vido" % [gamePlayers.getPlayerName(playerId)])
	game.callVido(playerId)

@rpc("any_peer")
func onClientAcceptedVido():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = gameSessions.getSessionByPeer(sender)
	if not session: return
	var gamePlayers = session.gamePlayers
	var playerId = str(sender)
	var game = session.game
	print("player %s attempts to accepts the vido" % [gamePlayers.getPlayerName(playerId)])
	game.acceptVido(playerId)

@rpc("any_peer")
func onClientRejectedVido():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = gameSessions.getSessionByPeer(sender)
	if not session: return
	var gamePlayers = session.gamePlayers
	var playerId = str(sender)
	var game = session.game
	print("player %s attempts to reject the vido" % [gamePlayers.getPlayerName(playerId)])
	game.rejectVido(playerId)

@rpc("any_peer")
func onClientRaisedVido():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = gameSessions.getSessionByPeer(sender)
	if not session: return
	var gamePlayers = session.gamePlayers
	var playerId = str(sender)
	var game = session.game
	print("player %s attempts to raise the vido" % [gamePlayers.getPlayerName(playerId)])
	game.raiseVido(playerId)

@rpc("any_peer")
func onClientTumbar():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = gameSessions.getSessionByPeer(sender)
	if not session: return
	var playerId = str(sender)
	var game = session.game
	game.takeTumbo(playerId)

@rpc("any_peer")
func onClientAchicarse():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = gameSessions.getSessionByPeer(sender)
	if not session: return
	var playerId = str(sender)
	var game = session.game
	game.achicarse(playerId)
