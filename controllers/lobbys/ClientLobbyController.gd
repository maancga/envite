extends LobbyControllersInterface

class_name ClientLobbyController

var chooseNameScene: ChooseName

signal gameHasStartedSignal()

func _init(_chooseName) -> void:
	chooseNameScene = _chooseName
	chooseNameScene.connect("nameChosenSignal", chooseName)
	chooseNameScene.connect("startGameSignal", clientCallsStartGame)

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
func receivePlayerAdded(playerId: String, players: Dictionary, team1: Array[String], team2: Array[String], team1Leader: String, team2Leader: String):
	chooseNameScene.updateList(playerId, players, team1, team2, team1Leader, team2Leader)

func clientCallsStartGame():
	sendToServer("onClientCallsStartGame")

@rpc("authority")
func receivePlayerCantBeAddedSinceMaxIsReached():
	print("max reached")

@rpc("authority")
func receivePlayerIsGameOwner(playerId: String):
	chooseNameScene.addPlayerOwner(playerId)

@rpc("authority")
func receiveGameCanNotStartSinceTheMinimumOfPlayersIsNotReached():
	print("minnnnnn")

@rpc("authority")
func receiveTriumphsConfiguration(triumphs: Array[Dictionary]):
	chooseNameScene.configureTriumphs(triumphs)

@rpc("authority")
func gameHasStarted():
	gameHasStartedSignal.emit()

func chooseName(playerName: String) -> void:
	sendToServer("onClientChoosesName", [playerName])
