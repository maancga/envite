class_name RealPlayerInteractor extends PlayerInteractor

signal sendPlayersAndTeamsSignal(players: Dictionary, team1: String, team2: String)
signal dealHandToPlayerSignal(player: String, hand: ServerHand)
signal dealVirado(player: String, card: ServerCard)
signal sendCurrentPlayerTurnSignal(player: String)
signal sendPlayerPlayedCardSignal(player: Dictionary, card: ServerCard, playedOrder: int, cardHandIndex: int)
signal sendPlayerRoundWinnerSignal(player: String, roundScore: int)
signal sendTeamWonChicoPointsSignal(team: String, chicoPoints: int)
signal sendTeamWonChicoSignal(team: String, chicos: int)
signal sendTeamWonSignal(team: String)
signal informDealerSignal(dealer: String)
signal sendPlayerCouldNotPlayCardBecauseItsNotTurnSignal(player: String)
signal sendPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHandSignal(player: String)
signal sendPlayerCouldNotPlayCardBecauseItsPlayedAlreadySignal(player: String)


func informPlayersAndTeams(players: Dictionary) -> void:
	var team1Array: Array[String] = []
	for id in players.team1.players:
		team1Array.append(str(id))

	var team2Array: Array[String] = []
	for id in players.team2.players:
		team2Array.append(str(id))
	sendPlayersAndTeamsSignal.emit(players.players, team1Array, team2Array)

func dealHandToPlayer(player: String, hand: ServerHand) -> void:
	dealHandToPlayerSignal.emit(player, hand)

func informVirado(card: ServerCard) -> void:
	dealVirado.emit(card)

func informPlayerTurn(player: String) -> void:
	sendCurrentPlayerTurnSignal.emit(player)

func informPlayerPlayedCard(player: String, card: ServerHandCard, playedOrder: int) -> void:
	sendPlayerPlayedCardSignal.emit(player, card.card, playedOrder, card.cardIndexHand)

func informPlayerCouldNotPlayCardBecauseItsNotTurn(player: String) -> void:
	sendPlayerCouldNotPlayCardBecauseItsNotTurnSignal.emit(player)

func informPlayerCouldNotPlayCardBacauseHasPlayedAlreadyInCurrentHand(player: String)-> void:
	sendPlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHandSignal.emit(player)

func informPlayerCouldNotPlayCardBecauseItsPlayedAlready(player: String)-> void:
	sendPlayerCouldNotPlayCardBecauseItsPlayedAlreadySignal.emit(player)

func informPlayerRoundWinner(player: String, roundScore: int) -> void:
	sendPlayerRoundWinnerSignal.emit(player, roundScore)

func informTeamWonChicoPoints(teamName: String, chicoPoints: int) -> void:
	sendTeamWonChicoPointsSignal.emit(teamName, chicoPoints)

func informTeamWonChico(teamName: String, chicos: int)-> void:
	sendTeamWonChicoSignal.emit(teamName, chicos)

func informTeamWon(teamName)-> void:
	sendTeamWonSignal.emit(teamName)

func informDealer(dealer: String)-> void:
	informDealerSignal.emit(dealer)
