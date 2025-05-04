class_name ScoresManager

signal teamWonGame(teamName: String)
signal wonRoundSignal()
signal wonChicoSignal()
signal team1IsOnTumboSignal()
signal team2IsOnTumboSignal()


var team1Score: TeamScore
var team2Score: TeamScore
const DEFAULT_PIEDRAS_WINS = 2
var piedrasOnPlay = DEFAULT_PIEDRAS_WINS
var viradoForChico = false
var viradoForGame = false
var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor

func _init(_playerInteractor: PlayerInteractor, _gamePlayers: GamePlayers) -> void:
	team1Score = TeamScore.new(_playerInteractor, "team1")
	team2Score = TeamScore.new(_playerInteractor, "team2")
	team1Score.connect("wonGameSignal", onTeamWonGame)
	team1Score.connect("wonChicoSignal", onTeamWonChico)
	team1Score.connect("teamIsOnTumboSignal", onTeam1IsOnTumbo)
	team2Score.connect("wonGameSignal", onTeamWonGame)
	team2Score.connect("wonChicoSignal", onTeamWonChico)
	team2Score.connect("teamIsOnTumboSignal", onTeam2IsOnTumbo)
	
	gamePlayers = _gamePlayers
	playerInteractor = _playerInteractor

func teamOneWinsRound():
	var team = team1Score
	teamWinsRound(team)

func teamTwoWinsRound():
	var team = team2Score
	teamWinsRound(team)

func teamOneRejectsTumbo():
	if (not team1IsOnTumbo()):
		print("Can not reject tumbo since its not on tumbo")
		return
	team2Score.otherTeamRejectedTumbo()
	wonRoundSignal.emit()

func teamTwoRejectsTumbo():
	if (not team2IsOnTumbo()):
		print("Can not reject tumbo since its not on tumbo")
		return
	team1Score.otherTeamRejectedTumbo()
	wonRoundSignal.emit()

func resetsVidos():
	viradoForChico = false
	viradoForGame = false
	setPiedrasOnPlay(DEFAULT_PIEDRAS_WINS)

func playerRefusedVido(playerId: String):
	var team = gamePlayers.getTeam(playerId)
	if (team == "team1"): teamTwoWinsRound()
	if (team == "team2"): teamOneWinsRound()

func teamWinsRound(team: TeamScore):
	if (viradoForGame): 
		team.winsGame()
		resetsVidos()
		return
	if (viradoForChico): 
		team.winsChico()
		resetsVidos()
		return
	if team1Score.teamIsOnTumbo() || team2Score.teamIsOnTumbo(): setPiedrasOnPlay(3)
	team.winsRound(piedrasOnPlay)
	resetsVidos()
	wonRoundSignal.emit()

func onTeamWonGame(teamName: String) -> void:
	teamWonGame.emit(teamName)

func onTeamWonChico() -> void:
	team1Score.resetPiedras()
	team2Score.resetPiedras()
	resetsVidos()
	wonChicoSignal.emit()

func onTeam1IsOnTumbo() -> void:
	team1IsOnTumboSignal.emit()

func onTeam2IsOnTumbo() -> void:
	team2IsOnTumboSignal.emit()

func setPiedrasOnPlay(piedras: int):
	piedrasOnPlay = piedras

func playingForChico():
	viradoForChico = true

func playingForGame():
	viradoForGame = true

func team1HasPiedras(piedras: int):
	return team1Score.piedras == piedras

func team2HasPiedras(piedras: int):
	return team2Score.piedras == piedras

func team1HasChicos(chicos: int):
	return team1Score.chicos == chicos

func team2HasChicos(chicos: int):
	return team2Score.chicos == chicos

func team1IsOnTumbo():
	return team1Score.teamIsOnTumbo()

func team2IsOnTumbo():
	return team2Score.teamIsOnTumbo()