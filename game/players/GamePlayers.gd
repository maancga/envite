class_name GamePlayers

var playerIds = []
var playersIdsMap = {}
var playerInstances = {}
var team1: Team
var team2: Team

const MAX_AMOUNT_OF_PLAYERS = 6

func _init():
	team1 = Team.new("Equipo 1")
	team2 = Team.new("Equipo 2")

func maxPlayersReached():
	return amountOfPlayers() == MAX_AMOUNT_OF_PLAYERS

func addPlayer(id: String, name: String):
	if maxPlayersReached(): return
	if playerExists(id): return 

	createPlayerInstances(id, name)
	assignTeam(id)
	

func createPlayerInstances(id: String, name: String ):
	playerIds.append(id)
	var playerIndex = playerIds.size() - 1
	playersIdsMap[id] = playerIndex 
	var player = ServerPlayer.new(id, name)
	playerInstances[id] = player

func assignTeam(id: String):
	var comparisonIndex = playerIds.size() -1
	if (comparisonIndex % 2 == 0): 
		team1.addPlayer(id)
		return
	if (comparisonIndex % 2 == 1): 
		team2.addPlayer(id)
		return

func amountOfPlayers():
	return playerIds.size()

func playerExists(id: String):
	return playerIds.find(id) > -1

func hasPlayers(amount: int):
	return amountOfPlayers() == amount

func getNextPlayer(currentPlayer: String):
	var currentPlayerIndex = playersIdsMap[currentPlayer]
	if (currentPlayerIndex == playerIds.size() - 1): return playerIds[0]
	return playerIds[currentPlayerIndex + 1]

func getTeam(id: String):
	if team1.players.find(id) > -1: return "team1"
	if team2.players.find(id) > -1: return "team2"
	return "none"

func toDictionary():
	var players = {}
	for playerId in playerIds:
		var player = playerInstances[playerId]
		players[playerId] = player.toDictionary()
	return {
		"players": players,
		"team1": team1.toDictionary(),
		"team2": team2.toDictionary()
	}


func getPlayerName(id: String):
	if playerExists(id): return playerInstances[id].name
	return "Player not found"

func getFirstPlayer():
	if playerIds.size() > 0: return playerIds[0]