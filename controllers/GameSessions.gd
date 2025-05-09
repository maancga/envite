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