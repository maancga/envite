extends StartMenuControllersInterface

class_name StartMenuClientController

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

@rpc("authority")
func receiveGameAssigned(gameId: String):
	receivedGameAssignedSignal.emit(gameId)

@rpc("authority")
func receiveGameJoinFailed():
	receivedGameJoinFailedSignal.emit()

func clientRequestsCreateGame() -> void:
	sendToServer("onClientRequestsCreateGame")

func clientRequestsJoinGame(gameId: String) -> void:
	sendToServer("onClientRequestsJoinGame", [gameId])
