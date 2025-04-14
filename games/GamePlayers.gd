class_name GamePlayers

var players = []
var playersIdsMap = {}
var team1: Team
var team2: Team

func _init():
	team1= Team.new()
	team2= Team.new()
	team1.teamName = "Equipo 1"
	team2.teamName = "Equipo 2"

func addPlayer(id: String ):
	var maxPlayersReached = amountOfPlayers() == 6
	if maxPlayersReached: return
	var playerExists = players.find(id) > -1
	if playerExists: return 
	players.append(id)
	var playerIndex = players.size() - 1
	playersIdsMap[id] = playerIndex 
	print("🎮 Player connected with id: ", id, " as player ", playerIndex)
	print("Current Connected players:", amountOfPlayers())
	assignTeam(id)

func assignTeam(id: String):
	var comparisonIndex = players.size() -1
	if (comparisonIndex % 2 == 0): 
		team1.addPlayer(id)
		return
	if (comparisonIndex % 2 == 1): 
		team2.addPlayer(id)
		return

func amountOfPlayers():
	return players.size()

func hasPlayers(amount: int):
	return amountOfPlayers() == amount

func getNext(currentPlayer: String):
	var currentPlayerIndex = playersIdsMap[currentPlayer]
	if (currentPlayerIndex == players.size() -1): return players[0]
	return players[currentPlayerIndex + 1]

func getTeam(id: String):
	if team1.players.find(id) > -1: return "team1"
	if team2.players.find(id) > -1: return "team2"
	return "none"
