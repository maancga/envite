class_name TestPlayerInteractor extends PlayerInteractor

var countDealHandToPlayerCalls = 0
var dealHandToPlayerArgs: Array[String]
var countInformViradoCalls = 0
var informViradoArgs: Array[ServerCard]
var countInformDealerCalls = 0
var informDealerArgs: Array[String]
var countInformPlayerTurnCalls = 0
var informPlayerTurnArgs: Array[String]
var playedCardsCalls = 0
var playedCardsArgs: Array[Dictionary]



func dealHandToPlayer(player: String, _hand: ServerHand) -> void:
	countDealHandToPlayerCalls += 1
	dealHandToPlayerArgs.append(player)

func informVirado(_card: ServerCard) -> void:
	countInformViradoCalls += 1
	informViradoArgs.append(_card)

func dealHandToPlayersBeenCalled(amount: int):
	return amount == countDealHandToPlayerCalls

func calledPlayerIds(playerIds: Array[String]):
	return playerIds == dealHandToPlayerArgs

func informViradoToPlayerBeenCalled(amount: int):
	return amount == countInformViradoCalls

func calledPlayerIdsForVirado(playerIds: Array[String]):
	return playerIds == informViradoArgs

func informPlayersAndTeams(_players: Dictionary) -> void:
	pass

func informPlayerTurn(_player: String) -> void:
	countInformPlayerTurnCalls += 1
	informPlayerTurnArgs.append(_player)

func getLastInformPlayerTurnCall() -> String:
	return informPlayerTurnArgs[informPlayerTurnArgs.size() - 1]

func informPlayerPlayedCard(_player: String, _card: ServerCard, _playedOrder: int) -> void:
	playedCardsCalls += 1
	playedCardsArgs.append({"player": _player, "card": _card, "playedOrder": _playedOrder})

func informPlayerPlayedCardCalledTimes(amount: int):
	return amount == playedCardsCalls

func getInformPlayedCards():
	return playedCardsArgs

func informPlayerRoundWinner(_player: String, _roundScore: int) -> void:
	pass

func informTeamWonChicoPoints(_teamName: String, _chicoPoints: int) -> void:
	pass

func informTeamWonChico(_teamName: String, _chicos: int)-> void:
	pass

func informTeamWon(_teamName: String)-> void:
	pass

func informDealer(_dealer: String)-> void:
	informDealerArgs.append(_dealer)
	countInformDealerCalls += 1

func informDealerBeenCalled(amount: int):
	return amount == countInformDealerCalls

func getLastDealer():
	return informDealerArgs[informDealerArgs.size() - 1]

func informPlayerCouldNotPlayCardBecauseItsNotTurn(_player: String) -> void:
	pass
