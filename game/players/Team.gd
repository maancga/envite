class_name Team

var players = []
var playersIdsMap = {}
var teamName = ""
var leader: String

func _init(_teamName: String):
	players = []
	playersIdsMap = {}
	teamName = _teamName

func addPlayer(id: String ):
	var isLeader = true if players.size() == 0 else false
	var playerExists = players.find(id) > -1
	if playerExists: return 
	players.append(id)
	var playerIndex = players.size() - 1
	playersIdsMap[id] = playerIndex 
	if (isLeader): leader = id

func isTheLeader(playerId: String):
	return playerId == leader

func toDictionary():
	var playersDict = {}
	for playerId in players:
		playersDict[playerId] = playersIdsMap[playerId]
	return {
		"teamName": teamName,
		"players": playersDict,
		"leader": leader
	}