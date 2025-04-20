class_name VidoForChico extends RoundState

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
	scoresManager.playingForChico()
	return

func raiseVido(playerId: String):
	playerInteractor.informVidoRaisedForGame(playerId)
	scoresManager.playingForChico()
	game.changeState(VidoForGame.new(playerInteractor, game, scoresManager))