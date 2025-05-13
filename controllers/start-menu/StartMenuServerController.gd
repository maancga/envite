extends StartMenuControllersInterface

class_name StartMenuServerController

var gameSessions: GameSessions

func _init(_gameSessions: GameSessions) -> void:
	gameSessions = _gameSessions

func connectPlayerInteractorSignals(_interactor: PlayerInteractor):
	pass

@rpc("any_peer")
func onClientRequestsCreateGame():
	var sender = multiplayer.get_remote_sender_id()
	var gameId = str("game_" + str(gameSessions.sessions.size()))

	var interactor = RealPlayerInteractor.new(gameId)	
	connectPlayerInteractorSignals(interactor)
	var session = GameSession.new(gameId, interactor)
	gameSessions.sessions[gameId] = session
	add_child(session)
	gameSessions.playerToGame[sender] = gameId
	session.peerIds.push_back(str(sender))

	print("✅ Nueva partida creada con ID:", gameId)
	print("🟢 Jugador ", sender, " creó y se unió a la partida ",gameId)
	rpc_id(sender, "receiveGameAssigned", gameId) 

@rpc("any_peer")
func onClientRequestsJoinGame(gameId):
	var sender = multiplayer.get_remote_sender_id()
	if not gameSessions.sessions.has(gameId):
		print("❌ Partida no encontrada:", gameId)
		rpc_id(sender, "receiveGameJoinFailed")
		return

	gameSessions.playerToGame[sender] = gameId
	var session = gameSessions.sessions[gameId]
	session.peerIds.push_back(str(sender))

	print("🟢 Jugador ", sender, " se unió a la partida ", gameId)
	rpc_id(sender, "receiveGameAssigned", gameId)
