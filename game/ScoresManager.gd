class_name ScoresManager

signal teamWonGame(teamName: String)

var team1Score: TeamScore
var team2Score: TeamScore
const DEFAULT_PIEDRAS_WINS = 2
var piedrasOnPlay = DEFAULT_PIEDRAS_WINS
var viradoForChico = false
var viradoForGame = false
var game: Game
var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor

func _init(_playerInteractor: PlayerInteractor, _gamePlayers: GamePlayers, _game: Game) -> void:
	team1Score = TeamScore.new(_playerInteractor, "team1")
	team2Score = TeamScore.new(_playerInteractor, "team2")
	team1Score.connect("wonGame", Callable(self, "onTeamWonGame"))
	gamePlayers = _gamePlayers
	game = _game
	playerInteractor = _playerInteractor

func teamOneWinsRound():
	var team = team1Score
	teamWinsRound(team)

func teamTwoWinsRound():
	var team = team2Score
	teamWinsRound(team)

func resetsVidos():
	viradoForChico = false
	viradoForGame = false
	piedrasOnPlay = DEFAULT_PIEDRAS_WINS

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
	team.winsRound(piedrasOnPlay)
	game.setNewRound()

func onTeamWonGame(teamName: String) -> void:
	teamWonGame.emit(teamName)

func setPiedrasOnPlay(piedras: int):
	piedrasOnPlay = piedras

func playingForChico():
	viradoForChico = true

func playingForGame():
	viradoForGame = true
