class_name RelativeHandsDistance

var players: Array[String]
var currentPlayerId: String

func _init(_players: Array[String], _currentPlayerId: String) -> void:
	players = _players
	currentPlayerId = _currentPlayerId

func calculateDistance(playerId: String) -> int:
	var currentPlayerIndex = players.find(currentPlayerId)
	var playerIndex = players.find(playerId)
	var difference = (playerIndex - currentPlayerIndex + players.size()) % players.size()

	return difference