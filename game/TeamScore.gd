class_name TeamScore

var piedras: int = 0
var chicos: int = 0
var teamName: String = ""
var playerInteractor: PlayerInteractor
const PIEDRAS_FOR_TUMBO = 11
const MINIMUM_FOR_CHICO = 12

signal wonGameSignal(teamName: String)
signal wonChicoSignal()
signal teamIsOnTumboSignal()


func _init(_playerInteractor: PlayerInteractor, _teamName: String) -> void:
	playerInteractor = _playerInteractor
	teamName = _teamName

func teamIsOnTumbo():
	return piedras == PIEDRAS_FOR_TUMBO

func winsRound(piedrasOnPlay: int):
	if (teamIsOnTumbo()): 
		winsChico()
		return 
	var provisionalNewScore = piedras + piedrasOnPlay
	if provisionalNewScore > MINIMUM_FOR_CHICO:
		winsChico()
		return
	if (provisionalNewScore) == MINIMUM_FOR_CHICO: piedrasOnPlay -= 1 # To match exactly 11 piedras, which is tumbo
	piedras += piedrasOnPlay
	playerInteractor.informTeamWonPiedras(teamName, piedras, piedrasOnPlay)
	if (teamIsOnTumbo()): teamIsOnTumboSignal.emit()

func winsChico():
	chicos += 1
	piedras = 0
	playerInteractor.informTeamWonChico(teamName, chicos)
	if (chicos == 2): 
		winsGame()
		return
	wonChicoSignal.emit()

func winsGame():
	wonGameSignal.emit(teamName)
	return

func resetPiedras():
	piedras = 0

func otherTeamRejectedTumbo():
	piedras += 1
	playerInteractor.informTeamWonPiedras(teamName, piedras, 1)
