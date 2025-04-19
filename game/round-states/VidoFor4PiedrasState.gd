class_name VidoFor4PiedrasState extends RoundState

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
	game.setPiedrasOnPlay(4)
	return

func raiseVido(playerId: String):
	playerInteractor.informVidoRaisedFor7Piedras(playerId)
	game.setPiedrasOnPlay(4)
	game.changeState(VidoFor7PiedrasState.new(playerInteractor, game))

