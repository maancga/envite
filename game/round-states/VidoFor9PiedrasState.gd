class_name VidoFor9PiedrasState extends RoundState

var playerInteractor: PlayerInteractor
var game: Game
var scoresManager: ScoresManager

func _init(_playerInteractor: PlayerInteractor, _game: Game, _scoresManager: ScoresManager) -> void:
	playerInteractor = _playerInteractor
	game = _game 
	scoresManager = _scoresManager

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

func refuseVido(playerId: String):
	playerInteractor.informPlayerRefusedVido(playerId)
	scoresManager.playerRefusedVido(playerId)
	return

func acceptVido(playerId: String):
	playerInteractor.informPlayerAcceptedVido(playerId)
	scoresManager.setPiedrasOnPlay(9)
	return

func raiseVido(playerId: String):
	playerInteractor.informVidoRaisedForChico(playerId)
	scoresManager.setPiedrasOnPlay(9)
	game.changeState(VidoForChico.new(playerInteractor, game, scoresManager))
