extends LobbyControllersInterface

class_name ServerLobbyController

var gameSessions: GameSessions

func sendToAllPlayers(gameId: String, rpcMethod: String, args := []):
	var session: GameSession = gameSessions.sessions[gameId]
	if not session: return
	for peerIdString in session.peerIds:
		var peerId = int(peerIdString)
		if args.size() == 0:
			rpc_id(peerId, rpcMethod)
		elif args.size() == 1:
			rpc_id(peerId, rpcMethod, args[0])
		elif args.size() == 2:
			rpc_id(peerId, rpcMethod, args[0], args[1])
		elif args.size() == 3:
			rpc_id(peerId, rpcMethod, args[0], args[1], args[2])
		elif args.size() == 4:
			rpc_id(peerId, rpcMethod, args[0], args[1], args[2], args[3])
		elif args.size() == 5:
			rpc_id(peerId, rpcMethod, args[0], args[1], args[2], args[3], args[4])
		elif args.size() == 6:
			rpc_id(peerId, rpcMethod, args[0], args[1], args[2], args[3], args[4], args[5])
		else:
			push_error("❌ call_rpc_id: Demasiados argumentos.")

func _init(_gameSessions: GameSessions) -> void:
	gameSessions = _gameSessions

func connectPlayerInteractorSignals(interactor: PlayerInteractor):
	interactor.connect("sendPlayerAddedSignal", onPlayerAdded)
	interactor.connect("informIsGameOwnerSignal", onInformIsGameOwner)
	interactor.connect("informTriumphsConfigurationSignal", onInformTriumphsConfiguration)


func onPlayerAdded(gameId: String, players: Dictionary, team1: Array[String], team2: Array[String], team1Leader: String, team2Leader: String):
	var session: GameSession = gameSessions.sessions[gameId]
	for peerIdString in session.peerIds:
		rpc_id(int(peerIdString), "receivePlayerAdded", peerIdString, players, team1, team2, team1Leader, team2Leader)

func onInformTriumphsConfiguration(gameId: String, triumphs: Array[Dictionary]):
	print("Informing current triumphs configuration")
	for triumph in triumphs:
		print(triumph)
	sendToAllPlayers(gameId, "receiveTriumphsConfiguration", [triumphs])

func onInformIsGameOwner(gameId: String, playerId: String):
	var gamePlayers = gameSessions.getPlayersFromGameId(gameId)
	print("Informing that %s is the game owner" % [gamePlayers.getPlayerName(playerId)])
	sendToAllPlayers(gameId, "receivePlayerIsGameOwner", [playerId])

@rpc("any_peer")
func onClientChoosesName(chosenName: String):
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = gameSessions.getSessionByPeer(sender)
	if (not session.lobbySignalsConnected): 
		connectPlayerInteractorSignals(session.interactor)
		session.markLobbySignalsAsConnected()
	if not session: return
	var preGame = session.preGame
	var playerId = str(sender)
	if preGame.gamePlayers.playerExists(playerId): return
	preGame.addPlayer(str(sender), chosenName)
	print("Player ", playerId, " chose name: ", chosenName)

@rpc("any_peer")
func onClientCallsStartGame():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = gameSessions.getSessionByPeer(sender)
	if not session: return
	var playerId = str(sender)
	var game = session.preGame.start(playerId)
	if game is Game:
		gameSessions.sessions[session.gameId]["game"] = game
		var players = game.gamePlayers.toDictionary()
		var team1Array: Array[String] = []
		for id in players.team1.players:
			team1Array.append(str(id))

		var team2Array: Array[String] = []
		for id in players.team2.players:
			team2Array.append(str(id))
		sendToAllPlayers(session.gameId, "gameHasStarted")

@rpc("any_peer")
func onClientGetCurrentPlayers():
	var sender = multiplayer.get_remote_sender_id()
	var session: GameSession = gameSessions.getSessionByPeer(sender)
	if not session: return
	var players = session.gamePlayers.toDictionary()
	var team1Array: Array[String] = []
	for id in players.team1.players:
		team1Array.append(str(id))

	var team2Array: Array[String] = []
	for id in players.team2.players:
		team2Array.append(str(id))

	rpc_id(sender, "receivePlayerIsGameOwner", session.preGame.gameOwner)
	rpc_id(sender, "receivePlayerAdded", str(sender), players.players, team1Array, team2Array, players.team1.leader, players.team2.leader)
