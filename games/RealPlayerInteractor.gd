class_name RealPlayerInteractor extends PlayerInteractor

signal sendPlayersAndTeamsSignal(players: Dictionary, team1: String, team2: String)
signal dealHandToPlayerSignal(player: String, hand: ServerHand)
signal dealViradoToPlayerSignal(player: String, card: ServerCard)
signal sendCurrentPlayerTurnSignal(player: String)
signal sendPlayerPlayedCardSignal(player: Dictionary, card: ServerCard, playedOrder: int)
signal sendPlayerRoundWinnerSignal(player: String, roundScore: int)
signal sendTeamWonChicoPointsSignal(team: String, chicoPoints: int)
signal sendTeamWonChicoSignal(team: String, chicos: int)
signal sendTeamWonSignal(team: String)



func informPlayersAndTeams(players: Dictionary, team1: Array[String], team2: Array[String]) -> void:
	sendPlayersAndTeamsSignal.emit(players, team1, team2)

func dealHandToPlayer(player: String, hand: ServerHand) -> void:
	dealHandToPlayerSignal.emit(player, hand)

func informViradoToPlayer(card: ServerCard) -> void:
	dealViradoToPlayerSignal.emit(card)

func informPlayerTurn(player: String) -> void:
	sendCurrentPlayerTurnSignal.emit(player)

func informPlayerPlayedCard(player: Dictionary, card: ServerCard, playedOrder: int) -> void:
	sendPlayerPlayedCardSignal.emit(player, card, playedOrder)

func informPlayerRoundWinner(player: String, roundScore: int) -> void:
	sendPlayerRoundWinnerSignal.emit(player, roundScore)

func informTeamWonChicoPoints(teamName: String, chicoPoints: int) -> void:
	sendTeamWonChicoPointsSignal.emit(teamName, chicoPoints)

func informTeamWonChico(teamName: String, chicos: int)-> void:
	sendTeamWonChicoSignal.emit(teamName, chicos)

func informTeamWon(teamName)-> void:
	sendTeamWonSignal.emit(teamName,)
