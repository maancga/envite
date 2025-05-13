extends Node

class_name LobbyControllersInterface

# Server code

@rpc("any_peer")
func onClientChoosesName(_chosenName: String):
	pass

@rpc("any_peer")
func onClientCallsStartGame():
	pass

@rpc("any_peer")
func onClientGetCurrentPlayers():
	pass

# Client code

@rpc("authority")
func receivePlayerAdded(_playerId: String, _players: Dictionary, _team1: Array[String], _team2: Array[String], _team1Leader: String, _team2Leader: String):
	pass

@rpc("authority")
func clientCallsStartGame():
	pass

@rpc("authority")
func receivePlayerCantBeAddedSinceMaxIsReached():
	pass

@rpc("authority")
func receivePlayerIsGameOwner(_playerId: String):
	pass

@rpc("authority")
func receiveGameCanNotStartSinceTheMinimumOfPlayersIsNotReached():
	pass

@rpc("authority")
func receiveTriumphsConfiguration(_triumphs: Array[Dictionary]):
	pass

@rpc("authority")
func gameHasStarted():
	pass
