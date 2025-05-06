extends RPCInterface

const CardIndex = {
	CARD_1 = "1",
	CARD_2 = "2",
	CARD_3 = "3"
}

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
signal receivedGameJoinFailedSignal()

func sendToServer(method: String, args := []):
	const SERVER_ID = 1
	if args.size() == 0:
		rpc_id(SERVER_ID, method)
	elif args.size() == 1:
		rpc_id(SERVER_ID, method, args[0])
	elif args.size() == 2:
		rpc_id(SERVER_ID, method, args[0], args[1])
	else:
		push_error("Too many args for send_to_server")

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

@rpc("authority")
func receiveClientId(playerId: String):
	receiveClientIdSignal.emit(playerId)

@rpc("authority")
func receiveGameAssigned(gameId: String):
	receivedGameAssignedSignal.emit(gameId)

@rpc("authority")
func receiveGameJoinFailed():
	receivedGameJoinFailedSignal.emit()

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

func playCard(cardIndex: String) -> void:
	if cardIndex not in CardIndex.values():
		push_error("Invalid cardIndex: " + cardIndex)
		return
	sendToServer("onClientPlayedCard", [cardIndex])

func chooseName(playerName: String) -> void:
	sendToServer("onClientChoosesName", [playerName])

func callVido() -> void:
	sendToServer("onClientCalledVido")

func acceptVido() -> void:
	sendToServer("onClientAcceptedVido")

func rejectVido() -> void:
	sendToServer("onClientRejectedVido")

func raisedVido() -> void:
	sendToServer("onClientRaisedVido")

func startGame() -> void:
	sendToServer("onClientStartedGame")

func tumbar() -> void:
	sendToServer("onClientTumbar")

func achicarse() -> void:
	sendToServer("onClientAchicarse")

func clientRequestsCreateGame() -> void:
	sendToServer("onClientRequestsCreateGame")

func clientRequestsJoinGame(gameId: String) -> void:
	sendToServer("onClientRequestsJoinGame", [gameId])
