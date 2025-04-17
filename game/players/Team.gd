class_name Team

var players = []
var playersIdsMap = {}
var teamName = ""

func _init(_teamName: String):
	players = []
	playersIdsMap = {}
	teamName = _teamName

func addPlayer(id: String ):
	var playerExists = players.find(id) > -1
	if playerExists: return 
	players.append(id)
	var playerIndex = players.size() - 1
	playersIdsMap[id] = playerIndex 

func toDictionary():
	var playersDict = {}
	for playerId in players:
		playersDict[playerId] = playersIdsMap[playerId]
	return {
		"teamName": teamName,
		"players": playersDict,
	}