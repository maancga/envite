class_name Team

var players = []
var playersIdsMap = {}
var teamName = ""

func addPlayer(id: String ):
	var playerExists = players.find(id) > -1
	if playerExists: return 
	players.append(id)
	var playerIndex = players.size() - 1
	playersIdsMap[id] = playerIndex 
	print("🎮 Player with id: ", id, " added to team ", teamName)
	print("Current Team players players:", amountOfPlayers())

func amountOfPlayers():
	return players.size()
