extends Node 

class_name RPCInterface

# Server functions
@rpc("any_peer")
func onClientPlayedCard(_cardIndex): pass

@rpc("any_peer")
func onClientChoosesName(_chosenName: String): pass

@rpc("any_peer")
func onClientCalledVido(): pass

@rpc("any_peer")
func onClientAcceptedVido(): pass

@rpc("any_peer")
func onClientRejectedVido(): pass

@rpc("any_peer")
func onClientRaisedVido(): pass

@rpc("any_peer")
func onClientStartedGame(): pass

@rpc("any_peer")
func onClientTumbar(): pass

@rpc("any_peer")
func onClientAchicarse(): pass

@rpc("any_peer")
func onClientRequestsCreateGame(): pass

@rpc("any_peer")
func onClientRequestsJoinGame(_gameId): pass


#Client functions
@rpc("authority")
func receiveClientId(_playerId: String): pass

@rpc("authority")
func receivePlayersAndTeams(_players: Dictionary, _team1: Array[String], _team2: Array[String], _team1Leader: String, _team2Leader: String): pass

@rpc("authority")
func receivePlayerAdded(_players: Dictionary, _team1: Array[String], _team2: Array[String], _team1Leader: String, _team2Leader: String): pass

@rpc("authority")
func receiveHand(_hand: Dictionary): pass

@rpc("authority")
func receiveVirado(_virado: Dictionary): pass

@rpc("authority")
func gameStarted(): pass

@rpc("authority")
func receivePlayerTurn(_player: String):pass

@rpc("authority")
func receiveCardPlayed(_player: String, _card: Dictionary, _cardHandIndex: int): pass

@rpc("authority")
func receivePlayerRoundWinner(_player: String, _roundScore: int): pass

@rpc("authority")
func receiveTeamWonPiedras(_teamName: String, _piedras: int): pass

@rpc("authority")
func receiveTeamWonChico(_teamName : String, _chicos: int): pass

@rpc("authority")
func receiveTeamWon(_teamName: String): pass

@rpc("authority")
func receiveDealer(_dealer: String): pass

@rpc("authority")
func receivePlayerCouldNotPlayCardBecauseItsNotTurn(): pass

@rpc("authority")
func receivePlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHand(_player: String): pass

@rpc("authority")
func receivePlayerCouldNotPlayCardBecauseItsPlayedAlready(_player: String): pass

@rpc("authority")
func receivePlayerCalledVido(_playerId : String): pass

@rpc("authority")
func receivePlayerRefusedVido(_playerId : String): pass

@rpc("authority")
func receivePlayerAcceptedVido(_playerId: String): pass

@rpc("authority")
func receivePlayerRaisedVidoTo7Piedras(_playerId : String): pass

@rpc("authority")
func receivePlayerRaisedVidoTo9Piedras(_playerId : String): pass

@rpc("authority")
func receivePlayerRaisedVidoToChico(_playerId : String): pass

@rpc("authority")
func receivePlayerRaisedVidoToGame(_playerId : String): pass

@rpc("authority")
func receivePlayerFromSameTeamCanNotTakeDecision(_playerId: String): pass

@rpc("authority")
func receiveOnlyLeaderCanTakeThisDecision(): pass

@rpc("authority")
func receiveVidoCanOnlyBeCalledOnYourTurn(): pass

@rpc("authority")
func receivePlayerCantBeAddedSinceMaxIsReached(): pass

@rpc("authority")
func receivePlayerIsGameOwner(_playerId: String): pass

@rpc("authority")
func receiveGameCanNotStartSinceTheMinimumOfPlayersIsNotReached(): pass

@rpc("authority")
func receiveTriumphsConfiguration(_triumphs: Array[Dictionary]): pass

@rpc("authority")
func receiveCannNotPlayCardBecauseTumboIsBeingDecided(): pass

@rpc("authority")
func receiveCannNotCallVidoBecauseTumboIsBeingDecided(): pass

@rpc("authority")
func receiveTeam1IsOnTumbo(): pass

@rpc("authority")
func receiveTeam2IsOnTumbo(): pass

@rpc("authority")
func receiveCannNotTakeThisDecisionIfNotInWaitingForTumbo(): pass

@rpc("authority")
func receiveTumboIsAccepted(): pass

@rpc("authority")
func receiveTumboIsRejected(): pass

@rpc("authority")
func receiveCanNotMakeTheActionAfterTheGameEnded(): pass

@rpc("authority")
func receiveGameAssigned(_gameId: String): pass

@rpc("authority")
func receiveGameJoinFailed(): pass
