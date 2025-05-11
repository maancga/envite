class_name GameSessions

var sessions := {} 
var playerToGame := {} 

func getSessionByPeer(peerId):
	var gameId = playerToGame.get(peerId, null)
	if not gameId or not sessions.has(gameId):
		print("❌ Partida no encontrada para jugador ", peerId)
		return null
	return sessions[gameId]

func getPlayersFromGameId(gameId: String) -> GamePlayers:
	return sessions[gameId].gamePlayers

func eraseGame(gameId: String) -> void:
	if not sessions.has(gameId):
		print("⚠️ Intentando borrar una partida inexistente:", gameId)
		return

	var gamePlayers = getPlayersFromGameId(gameId)
	
	for playerId in gamePlayers.playerIds:
		playerToGame.erase(playerId)
		print("🔁 Jugador desvinculado de la partida:", playerId)

	sessions.erase(gameId)
	print("🗑️ Partida eliminada:", gameId)

func disconnectPlayer(playerId: String) -> void:
	print(playerToGame)
	print(sessions)
	var gameId = playerToGame.get(int(playerId), null)
	print(gameId)
	print(playerToGame.get(playerId, null))
	if not gameId or not sessions.has(gameId):
		print("⚠️ No session found for disconnected player: ", playerId)
		return

	var session = sessions[gameId]
	var gamePlayers = session.gamePlayers
	gamePlayers.removePlayer(playerId)
	playerToGame.erase(playerId)
	print("🔁 Player removed from session: ", playerId)

	if gamePlayers.playerIds.size() == 0:
		print("🗑️ Lobby is empty, destroying session: ", gameId)
		eraseGame(gameId)
	else:
		print("ℹ️ Lobby still has players: ", gamePlayers.playerIds.size())