class_name VidoFor4PiedrasState extends RoundState

var playerInteractor: PlayerInteractor
var game: Game
var scoresManager: ScoresManager
var gamePlayers: GamePlayers
var callerPlayerId: String

func _init(_playerInteractor: PlayerInteractor, _game: Game, _scoresManager: ScoresManager, _callerPlayerId: String, _gamePlayers: GamePlayers) -> void:
	playerInteractor = _playerInteractor
	game = _game 
	scoresManager = _scoresManager
	callerPlayerId = _callerPlayerId
	gamePlayers = _gamePlayers


func playFirstCard(playerId: String):
	playerInteractor.informPlayerCouldNotPlayCardBecauseItsVido(playerId)
	return 

func playSecondCard(playerId: String):
	playerInteractor.informPlayerCouldNotPlayCardBecauseItsVido(playerId)
	return 

func playThirdCard(playerId: String):
	playerInteractor.informPlayerCouldNotPlayCardBecauseItsVido(playerId)
	return 

func callVido(playerId: String):
	playerInteractor.informCannNotCallVidoBecauseAlreadyCalled(playerId)
	return 

func rejectVido(playerId: String):
	var isTheOtherTeamLeader = checkIsOtherTeamLeader(playerId)
	if !isTheOtherTeamLeader: return
	scoresManager.playerRefusedVido(playerId)
	playerInteractor.informPlayerRefusedVido(playerId)
	return

func acceptVido(playerId: String):
	var isTheOtherTeamLeader = checkIsOtherTeamLeader(playerId)
	if !isTheOtherTeamLeader: return
	scoresManager.setPiedrasOnPlay(4)
	playerInteractor.informPlayerAcceptedVido(playerId)
	return

func raiseVido(playerId: String):
	var isTheOtherTeamLeader = checkIsOtherTeamLeader(playerId)
	if !isTheOtherTeamLeader: return
	scoresManager.setPiedrasOnPlay(4)
	playerInteractor.informVidoRaisedFor7Piedras(playerId)
	game.changeState(VidoFor7PiedrasState.new(playerInteractor, game, scoresManager, playerId, gamePlayers))

func checkIsOtherTeamLeader(playerId: String):
	if (gamePlayers.areSameTeam(playerId, callerPlayerId)): 
		playerInteractor.informPlayerFromSameTeamCanNotTakeDecision(playerId)
		return
	if (not gamePlayers.isLeader(playerId)): 
		playerInteractor.informOnlyLeaderCanTakeThisDecision(playerId)
		return
	return true

func takeTumbo(_playerId: String):
	playerInteractor.cannNotTakeThisDecisionIfNotInWaitingForTumbo()
	return

func notTakeTumbo(_playerId: String):
	playerInteractor.cannNotTakeThisDecisionIfNotInWaitingForTumbo()
	return

func getStateName():
	return "Vido de 4 piedras"
