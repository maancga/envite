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
var vidoRefusedCalls = 0
var vidoAcceptedCalls = 0
var vidoRaisedTo7calls = 0
var vidoRaisedTo9calls = 0
var vidoRaisedToChicoCalls = 0
var vidoRaisedToGameCalls = 0
var countInformPlayerCouldNotPlayCardBecauseItsNotTurnCalls = 0
var informPlayerCouldNotPlayCardBecauseItsNotTurnCalls: Array[String]
var informGameIsOnTumboCalls = 0
var team1PiedrasLastUpdate = 0
var team2PiedrasLastUpdate = 0
var team1ChicosLastUpdate = 0
var team2ChicosLastUpdate = 0


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

func informPlayerPlayedCard(_player: String, _card: ServerHandCard, _playedOrder: int) -> void:
	playedCardsCalls += 1
	playedCardsArgs.append({"player": _player, "card": _card.getCardName(), "playedOrder": _playedOrder})

func informPlayerPlayedCardCalledTimes(amount: int):
	return amount == playedCardsCalls

func informPlayerRoundWinner(_player: String, _roundScore: int) -> void:
	pass

func informTeamWonPiedras(_teamName: String, _piedras: int, _piedrasOnPlay: int) -> void:
	if (_teamName == "team1"): team1PiedrasLastUpdate = _piedras
	if (_teamName == "team2"): team2PiedrasLastUpdate = _piedras


func informTeamWonChico(_teamName: String, _chicos: int)-> void:
	if (_teamName == "team1"): 
		team1ChicosLastUpdate = _chicos
		team1PiedrasLastUpdate = 0
	if (_teamName == "team2"): 
		team2ChicosLastUpdate = _chicos
		team2PiedrasLastUpdate = 0

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
	countInformPlayerCouldNotPlayCardBecauseItsNotTurnCalls += 1
	informPlayerCouldNotPlayCardBecauseItsNotTurnCalls.push_back(_player)

func informPlayerCouldNotPlayCardBacauseHasPlayedAlreadyInCurrentHand(_player: String)-> void:
	pass

func informPlayerCouldNotPlayCardBecauseItsVido(_player: String)-> void:
	pass

func informPlayerRefusedVido(_player: String) -> void:
	vidoRefusedCalls += 1

func vidoRefusedCalledTimes(amount: int):
	return amount == vidoRefusedCalls

func informPlayerAcceptedVido(_player: String) -> void:
	vidoAcceptedCalls += 1

func vidoAcceptedCalledTimes(amount: int):
	return amount == vidoAcceptedCalls

func informVidoRaisedFor7Piedras(_player: String) -> void:
	vidoRaisedTo7calls += 1

func vidoRaisedFor7PiedrasCalledTimes(amount: int):
	return amount == vidoRaisedTo7calls
	
func informVidoRaisedFor9Piedras(_player: String) -> void:
	vidoRaisedTo9calls += 1

func vidoRaisedFor9PiedrasCalledTimes(amount: int):
	return amount == vidoRaisedTo9calls

func informVidoRaisedForChico(_player: String) -> void:
	vidoRaisedToChicoCalls += 1

func vidoRaisedForChicoCalledTimes(amount: int):
	return amount == vidoRaisedToChicoCalls

func informVidoRaisedForGame(_player: String) -> void:
	vidoRaisedToGameCalls += 1

func vidoRaisedForGameCalledTimes(amount: int):
	return amount == vidoRaisedToGameCalls

func cannotRefuseVidoBecauseThereIsNoVidoCalled(_player: String):
	pass

func cannotAcceptVidoBecauseThereIsNoVidoCalled(_player: String):
	pass

func cannotRaiseVidoBecauseThereIsNoVidoCalled(_player: String):
	pass

func informPlayerCalledVido(_playerId: String):
	pass

func informPlayerAdded(_players: Dictionary):
	pass

func informTriumphsConfiguration(_triumph: TriumphHierarchy):
	pass

func informPlayerCantBeAddedSinceMaxIsReached():
	pass

func informGameCanNotStartSinceTheMinimumOfPlayersIsNotReached(_playerId: String):
	pass

func informGameCanNotStartSinceItsNotOwner(_player: String):
	pass

func informIsGameOwner(_playerId: String):
	pass

func informPlayerCouldNotPlayCardBecauseItsPlayedAlready(_player: String)-> void:
	pass

func informCanNotRaiseVidoMoreThanGame(_player: String) -> void:
	pass

func informPlayerFromSameTeamCanNotTakeDecision(_player: String):
	pass

func informVidoCanOnlyBeCalledOnYourTurn(_playerId: String):
	pass

func informOnlyLeaderCanTakeThisDecision(_player: String):
	pass

func cannNotTakeThisDecisionIfNotInWaitingForTumbo():
	pass

func informGameIsOnTumbo():
	informGameIsOnTumboCalls += 1

func informTumboIsAccepted():
	pass

func informTumboIsRejected():
	pass