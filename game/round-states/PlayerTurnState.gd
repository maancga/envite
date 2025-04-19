class_name PlayerTurnState extends RoundState

var currentPlayerTurn: String
var hands: RoundHands
var playerInteractor: PlayerInteractor
var playedCards: PlayedCards
var game: Game

func _init(_game: Game, _currentPlayerTurn: String, _hands: RoundHands, _playerInteractor: PlayerInteractor, _playedCards: PlayedCards, ) -> void:
	currentPlayerTurn = _currentPlayerTurn
	hands = _hands
	playerInteractor = _playerInteractor
	playedCards = _playedCards
	game = _game

func playFirstCard(playerId: String):
	game.roundManager.playFirstCard(playerId)
	
func playSecondCard(playerId: String):
	game.roundManager.playSecondCard(playerId)

func playThirdCard(playerId: String):
	game.roundManager.playThirdCard(playerId)

func callVido(_id: String):
	game.changeState(VidoFor4PiedrasState.new(playerInteractor, game))

func refuseVido(playerId: String):
	playerInteractor.cannotRefuseVidoBecauseThereIsNoVidoCalled(playerId)
	return

func acceptVido(playerId: String):
	playerInteractor.cannotAcceptVidoBecauseThereIsNoVidoCalled(playerId)
	return

func raiseVido(playerId: String):
	playerInteractor.cannotRaiseVidoBecauseThereIsNoVidoCalled(playerId)
	return