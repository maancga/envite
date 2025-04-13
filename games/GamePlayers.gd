class_name GamePlayers

var players = []
var playersIdsMap = {}

func addPlayer(id:String ):
	var maxPlayersReached = amountOfPlayers() == 6
	if maxPlayersReached: return
	var playerExists = players.find(id) > -1
	if playerExists: return 
	players.append(id)
	var playerIndex = players.size() - 1
	playersIdsMap[id] = playerIndex 

func amountOfPlayers():
	return players.size()

func hasPlayers(amount: int):
	return amountOfPlayers() == amount
