class_name VidoFor9PiedrasState extends RoundState

var playerInteractor: PlayerInteractor
var game: Game

func _init(_playerInteractor: PlayerInteractor, _game: Game) -> void:
	playerInteractor = _playerInteractor
	game = _game 

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
	return

func acceptVido(playerId: String):
	playerInteractor.informPlayerAcceptedVido(playerId)
	return

func raiseVido(playerId: String):
	playerInteractor.informVidoRaisedForChico(playerId)
	game.changeState(VidoForChico.new(playerInteractor, game))