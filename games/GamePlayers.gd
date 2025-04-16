class_name GamePlayers

var playerIds = []
var playersIdsMap = {}
var playerInstances = {}
var team1: Team
var team2: Team

func _init():
	team1 = Team.new()
	team2 = Team.new()
	team1.teamName = "Equipo 1"
	team2.teamName = "Equipo 2"

func addPlayer(id: String, name: String =  ""):
	var maxPlayersReached = amountOfPlayers() == 6
	if maxPlayersReached: return
	var playerExists = playerIds.find(id) > -1
	if playerExists: return 

	playerIds.append(id)
	var playerIndex = playerIds.size() - 1
	playersIdsMap[id] = playerIndex 

	var player = ServerPlayer.new(id, name)
	playerInstances[id] = player

	print("🎮 Player connected with id: ", id, " as player ", playerIndex)
	print("Current Connected playerIds:", amountOfPlayers())
	assignTeam(id)

func setPlayerName(id: String, name: String):
	var player = playerInstances[id]
	if player == null: return
	player.changeName(name)
	print("Player ", id, " changed its name to ", name)

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

func hasPlayers(amount: int):
	print(amountOfPlayers(), " == ", amount)
	return amountOfPlayers() == amount

func getNext(currentPlayer: String):
	var currentPlayerIndex = playersIdsMap[currentPlayer]
	if (currentPlayerIndex == playerIds.size() - 1): return playerIds[0]
	return playerIds[currentPlayerIndex + 1]

func getTeam(id: String):
	if team1.players.find(id) > -1: return "team1"
	if team2.players.find(id) > -1: return "team2"
	return "none"

func everyPlayerIsReady():
	for playerId in playerIds:
		var player = playerInstances[playerId]
		if not player.isReady(): return false
	return true

func toDictionary():
	var players = {}
	for playerId in playerIds:
		var player = playerInstances[playerId]
		players[playerId] = player.toDictionary()
	return players