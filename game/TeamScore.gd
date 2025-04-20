class_name TeamScore

var scoreInChico: int = 0
var wonChicos: int = 0
var teamName: String = ""
var playerInteractor: PlayerInteractor

signal wonGame(teamName: String)

func _init(_playerInteractor: PlayerInteractor, _teamName: String) -> void:
	playerInteractor = _playerInteractor
	teamName = _teamName

func teamIsOnTumbo():
	return false

func winsRound(piedrasOnPlay: int):
	if (teamIsOnTumbo()): 
		winsChico()
		return 
	else: 
		scoreInChico += piedrasOnPlay
		playerInteractor.informTeamWonChicoPoints(teamName, scoreInChico)

func winsChico():
	wonChicos += 1
	playerInteractor.informTeamWonChico(teamName, wonChicos)
	if (wonChicos == 2): winsGame()

func winsGame():
	wonGame.emit(teamName)
	return
