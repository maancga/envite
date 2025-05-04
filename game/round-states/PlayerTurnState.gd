class_name PlayerTurnState extends RoundState

var hands: RoundHands
var playerInteractor: PlayerInteractor
var playedCards: PlayedCards
var game: Game
var scoresManager: ScoresManager
var gamePlayers: GamePlayers

func _init(_game: Game, _hands: RoundHands, _playerInteractor: PlayerInteractor, _playedCards: PlayedCards, _scoresManager: ScoresManager, _gamePlayers: GamePlayers) -> void:
	hands = _hands
	playerInteractor = _playerInteractor
	playedCards = _playedCards
	game = _game
	scoresManager = _scoresManager
	gamePlayers = _gamePlayers

func playFirstCard(playerId: String):
	game.roundManager.playFirstCard(playerId)

func playSecondCard(playerId: String):
	game.roundManager.playSecondCard(playerId)

func playThirdCard(playerId: String):
	game.roundManager.playThirdCard(playerId)

func callVido(playerId: String):
	if(playerId != game.roundManager.currentPlayerTurn):
		playerInteractor.informVidoCanOnlyBeCalledOnYourTurn(playerId)
		return 
	game.changeState(VidoFor4PiedrasState.new(playerInteractor, game, scoresManager, playerId, gamePlayers ))
	playerInteractor.informPlayerCalledVido(playerId)

func rejectVido(playerId: String):
	playerInteractor.cannotRefuseVidoBecauseThereIsNoVidoCalled(playerId)
	return

func acceptVido(playerId: String):
	playerInteractor.cannotAcceptVidoBecauseThereIsNoVidoCalled(playerId)
	return

func raiseVido(playerId: String):
	playerInteractor.cannotRaiseVidoBecauseThereIsNoVidoCalled(playerId)
	return

func takeTumbo(_playerId: String):
	playerInteractor.cannNotTakeThisDecisionIfNotInWaitingForTumbo(_playerId)
	return

func notTakeTumbo(_playerId: String):
	playerInteractor.cannNotTakeThisDecisionIfNotInWaitingForTumbo(_playerId)
	return

func getStateName():
	return "Player turn"
