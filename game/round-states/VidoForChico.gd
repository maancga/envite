class_name VidoForChico extends RoundState

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
	playerInteractor.informPlayerRefusedVido(playerId)
	scoresManager.playerRefusedVido(playerId)
	return

func acceptVido(playerId: String):
	playerInteractor.informPlayerAcceptedVido(playerId)
	scoresManager.playingForChico()
	return

func raiseVido(playerId: String):
	playerInteractor.informVidoRaisedForGame(playerId)
	scoresManager.playingForChico()
	game.changeState(VidoForGame.new(playerInteractor, game, scoresManager, playerId, gamePlayers))

func checkIsOtherTeamLeader(playerId: String):
	if (gamePlayers.areSameTeam(playerId, callerPlayerId)): 
		playerInteractor.informPlayerFromSameTeamCanNotTakeDecision(playerId)
		return
	if (gamePlayers.isLeader(playerId)): 
		playerInteractor.informOnlyLeaderCanTakeThisDecision(playerId)
		return
	return true

func takeTumbo(_playerId: String):
	playerInteractor.cannNotTakeThisDecisionIfNotInWaitingForTumbo(_playerId)
	return

func achicarse(_playerId: String):
	playerInteractor.cannNotTakeThisDecisionIfNotInWaitingForTumbo(_playerId)
	return

func getStateName():
	return "Vido por chico"