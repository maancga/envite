extends Node

class_name StartMenuControllersInterface

# Client code

@rpc("authority")
func receiveGameAssigned(_gameId: String):
	pass

@rpc("authority")
func receiveGameJoinFailed():
	pass

# Server code

@rpc("any_peer")
func onClientRequestsCreateGame():
	pass

@rpc("any_peer")
func onClientRequestsJoinGame(_gameId):
	pass
