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