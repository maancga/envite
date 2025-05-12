class_name RealPlayerInteractor extends PlayerInteractor

signal sendPlayersAndTeamsSignal(players: Dictionary, team1: String, team2: String, team1Leader: String, team2Leader: String)
signal sendPlayerAddedSignal(gameId: String, players: Dictionary, team1: String, team2: String, team1Leader: String, team2Leader: String)
signal dealHandToPlayerSignal(player: String, hand: ServerHand)
signal dealVirado(player: String, card: ServerCard)
signal sendCurrentPlayerTurnSignal(player: String)
signal sendPlayerPlayedCardSignal(player: Dictionary, card: ServerCard, playedOrder: int, cardHandIndex: int)
signal sendPlayerRoundWinnerSignal(player: String, roundScore: int)
signal sendTeamWonPiedrasSignal(team: String, piedras: int, piedrasOnPlay: int)
signal sendTeamWonChicoSignal(team: String, chicos: int)
signal sendTeamWonSignal(team: String)
signal informDealerSignal(dealer: String)
signal sendPlayerCouldNotPlayCardBecauseItsNotTurnSignal(player: String)
signal sendPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHandSignal(player: String)
signal sendPlayerCouldNotPlayCardBecauseItsPlayedAlreadySignal(player: String)
signal sendPlayerCouldNotPlayCardBecauseItsVidoSignal(player: String)
signal sendPlayerRefusedVidoSignal(player: String)
signal sendPlayerAcceptedVidoSignal(player: String)
signal sendVidoRaisedFor7PiedrasSignal(player: String)
signal sendVidoRaisedFor9PiedrasSignal(player: String)
signal sendVidoRaisedForChicoSignal(player: String)
signal sendVidoRaisedForGameSignal(player: String)
signal sendCanNotRaiseVidoMoreThanGameSignal(player: String)
signal sendVidoCannotBeAcceptedBecauseThereIsNoVidoCalledSignal(player: String)
signal sendVidoCannotBeRefusedBecauseThereIsNoVidoCalledSignal(player: String)
signal sendVidoCannotBeRaisedBecauseThereIsNoVidoCalledSignal(player: String)
signal sendPlayerCalledVidoSignal(playerId: String)
signal informPlayerFromSameTeamCanNotTakeDecisionSignal(playerId: String)
signal informOnlyLeaderCanTakeThisDecisionSignal(playerId: String)
signal informVidoCanOnlyBeCalledOnYourTurnSignal(playerId: String)
signal informPlayerCantBeAddedSinceMaxIsReachedSignal()
signal informGameCanNotStartSinceItsNotOwnerSignal(playerId: String)
signal informIsGameOwnerSignal(playerId: String)
signal informGameCanNotStartSinceTheMinimumOfPlayersIsNotReachedSignal()
signal informTriumphsConfigurationSignal(triumphs: Array[Dictionary])
signal informCannNotPlayCardBecauseTumboIsBeingDecidedSignal(_playerId: String)
signal informCannNotCallVidoBecauseTumboIsBeingDecidedSignal(_playerId: String)
signal informTeam1IsOnTumboSignal()
signal informTeam2IsOnTumboSignal()
signal informCannNoTakeThisDecisionIfNotInWaitingForTumboSignal(_playerId: String)
signal informTumboIsAcceptedSignal()
signal informTumboIsRejectedSignal()
signal informCanNotMakeTheActionAfterTheGameEndedSignal(playerId: String)
signal informVidoCalledThisRoundAlreadySignal(playerId: String)

var gameId: String

func _init(_gameId: String) -> void:
	gameId = _gameId

func informPlayersAndTeams(players: Dictionary) -> void:
	var team1Array: Array[String] = []
	for id in players.team1.players:
		team1Array.append(str(id))

	var team2Array: Array[String] = []
	for id in players.team2.players:
		team2Array.append(str(id))
	sendPlayersAndTeamsSignal.emit(gameId, players.players, team1Array, team2Array, players.team1.leader, players.team2.leader)

func informPlayerAdded(players: Dictionary) -> void:
	var team1Array: Array[String] = []
	for id in players.team1.players:
		team1Array.append(str(id))

	var team2Array: Array[String] = []
	for id in players.team2.players:
		team2Array.append(str(id))
	sendPlayerAddedSignal.emit(gameId, players.players, team1Array, team2Array, players.team1.leader, players.team2.leader)

func informTriumphsConfiguration(triumph: TriumphHierarchy) -> void:
	informTriumphsConfigurationSignal.emit(gameId, triumph.getTriumphHierarchy())

func informPlayerCantBeAddedSinceMaxIsReached():
	informPlayerCantBeAddedSinceMaxIsReachedSignal.emit(gameId)

func informGameCanNotStartSinceItsNotOwner(player: String):
	informGameCanNotStartSinceItsNotOwnerSignal.emit(gameId, player)

func informGameCanNotStartSinceTheMinimumOfPlayersIsNotReached(playerId: String):
	informGameCanNotStartSinceTheMinimumOfPlayersIsNotReachedSignal.emit(playerId)

func informIsGameOwner(playerId: String):
	informIsGameOwnerSignal.emit(gameId, playerId)

func dealHandToPlayer(player: String, hand: ServerHand) -> void:
	dealHandToPlayerSignal.emit(gameId, player, hand)

func informVirado(card: ServerCard) -> void:
	dealVirado.emit(gameId, card)

func informPlayerTurn(player: String) -> void:
	sendCurrentPlayerTurnSignal.emit(gameId, player)

func informPlayerPlayedCard(player: String, card: ServerHandCard, playedOrder: int) -> void:
	sendPlayerPlayedCardSignal.emit(gameId, player, card.card, playedOrder, card.cardIndexHand)

func informPlayerCouldNotPlayCardBecauseItsNotTurn(player: String) -> void:
	sendPlayerCouldNotPlayCardBecauseItsNotTurnSignal.emit(player)

func informPlayerCouldNotPlayCardBacauseHasPlayedAlreadyInCurrentHand(player: String)-> void:
	sendPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHandSignal.emit(player)

func informPlayerCouldNotPlayCardBecauseItsPlayedAlready(player: String)-> void:
	sendPlayerCouldNotPlayCardBecauseItsPlayedAlreadySignal.emit(player)

func informPlayerRoundWinner(player: String, roundScore: int) -> void:
	sendPlayerRoundWinnerSignal.emit(gameId, player, roundScore)

func informTeamWonPiedras(teamName: String, piedras: int, piedrasOnPlay: int) -> void:
	sendTeamWonPiedrasSignal.emit(gameId, teamName, piedras, piedrasOnPlay)

func informTeamWonChico(teamName: String, chicos: int)-> void:
	sendTeamWonChicoSignal.emit(gameId, teamName, chicos)

func informTeamWon(teamName)-> void:
	print("%s won the game" % [teamName])
	sendTeamWonSignal.emit(gameId, teamName)

func informDealer(dealer: String)-> void:
	informDealerSignal.emit(gameId, dealer)

func informPlayerCouldNotPlayCardBecauseItsVido(_player: String)-> void:
	sendPlayerCouldNotPlayCardBecauseItsVidoSignal.emit(_player)
	
func informPlayerRefusedVido(_player: String) -> void:
	sendPlayerRefusedVidoSignal.emit(gameId,_player)

func informPlayerAcceptedVido(_player: String) -> void:
	sendPlayerAcceptedVidoSignal.emit(gameId, _player)

func informVidoRaisedFor7Piedras(_player: String) -> void:
	sendVidoRaisedFor7PiedrasSignal.emit(gameId, _player)
	
func informVidoRaisedFor9Piedras(_player: String) -> void:
	sendVidoRaisedFor9PiedrasSignal.emit(gameId, _player)

func informVidoRaisedForChico(_player: String) -> void:
	sendVidoRaisedForChicoSignal.emit(gameId, _player)

func informVidoRaisedForGame(_player: String) -> void:
	sendVidoRaisedForGameSignal.emit(gameId, _player)

func informCanNotRaiseVidoMoreThanGame(_player: String) -> void:
	sendCanNotRaiseVidoMoreThanGameSignal.emit(_player)

func cannotRefuseVidoBecauseThereIsNoVidoCalled(_player: String):
	sendVidoCannotBeRefusedBecauseThereIsNoVidoCalledSignal.emit(_player)

func cannotAcceptVidoBecauseThereIsNoVidoCalled(_player: String):
	sendVidoCannotBeAcceptedBecauseThereIsNoVidoCalledSignal.emit(_player)

func cannotRaiseVidoBecauseThereIsNoVidoCalled(_player: String):
	sendVidoCannotBeRaisedBecauseThereIsNoVidoCalledSignal.emit(_player)

func informPlayerFromSameTeamCanNotTakeDecision(_player: String):
	informPlayerFromSameTeamCanNotTakeDecisionSignal.emit(gameId,_player)

func informOnlyLeaderCanTakeThisDecision(_player: String):
	informOnlyLeaderCanTakeThisDecisionSignal.emit(gameId,_player)

func informPlayerCalledVido(_playerId: String):
	sendPlayerCalledVidoSignal.emit(gameId, _playerId)

func informVidoCanOnlyBeCalledOnYourTurn(_playerId: String):
	informVidoCanOnlyBeCalledOnYourTurnSignal.emit(gameId, _playerId)

func informCannNotPlayCardBecauseTumboIsBeingDecided(_playerId: String):
	informCannNotPlayCardBecauseTumboIsBeingDecidedSignal.emit(_playerId)

func informTeam1IsOnTumbo():
	informTeam1IsOnTumboSignal.emit(gameId)

func informTeam2IsOnTumbo():
	informTeam2IsOnTumboSignal.emit(gameId)

func cannNotTakeThisDecisionIfNotInWaitingForTumbo(_playerId: String):
	informCannNoTakeThisDecisionIfNotInWaitingForTumboSignal.emit(_playerId)

func informTumboIsAccepted():
	informTumboIsAcceptedSignal.emit(gameId)

func informTumboIsRejected():
	informTumboIsRejectedSignal.emit(gameId)

func informCannNotCallVidoBecauseTumboIsBeingDecided(playerId: String):
	informCannNotCallVidoBecauseTumboIsBeingDecidedSignal.emit(playerId)

func canNotMakeTheActionAfterTheGameEnded(playerId: String):
	informCanNotMakeTheActionAfterTheGameEndedSignal.emit(playerId)

func vidoCalledThisRoundAlready(_playerId: String):
	informVidoCalledThisRoundAlreadySignal.emit(_playerId)