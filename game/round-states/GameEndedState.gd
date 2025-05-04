class_name GameEndedState extends RoundState

var playerInteractor: PlayerInteractor

func _init(_playerInteractor: PlayerInteractor) -> void:
	playerInteractor = _playerInteractor


func playFirstCard(playerId: String):
	playerInteractor.canNotMakeTheActionAfterTheGameEnded(playerId)
	return

func playSecondCard(playerId: String):
	playerInteractor.canNotMakeTheActionAfterTheGameEnded(playerId)
	return

func playThirdCard(playerId: String):
	playerInteractor.canNotMakeTheActionAfterTheGameEnded(playerId)
	return

func callVido(playerId: String):
	playerInteractor.canNotMakeTheActionAfterTheGameEnded(playerId)
	return

func rejectVido(playerId: String):
	playerInteractor.canNotMakeTheActionAfterTheGameEnded(playerId)
	return

func acceptVido(playerId: String):
	playerInteractor.canNotMakeTheActionAfterTheGameEnded(playerId)
	return

func raiseVido(playerId: String):
	playerInteractor.canNotMakeTheActionAfterTheGameEnded(playerId)
	return

func takeTumbo(playerId: String):
	playerInteractor.canNotMakeTheActionAfterTheGameEnded(playerId)
	return

func achicarse(playerId: String):
	playerInteractor.canNotMakeTheActionAfterTheGameEnded(playerId)
	return

func getStateName():
	return "Game ended"
