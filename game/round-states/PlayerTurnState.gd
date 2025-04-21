class_name PlayerTurnState extends RoundState

var currentPlayerTurn: String
var hands: RoundHands
var playerInteractor: PlayerInteractor
var playedCards: PlayedCards
var game: Game
var scoresManager: ScoresManager
var gamePlayers: GamePlayers

func _init(_game: Game, _currentPlayerTurn: String, _hands: RoundHands, _playerInteractor: PlayerInteractor, _playedCards: PlayedCards, _scoresManager: ScoresManager, _gamePlayers: GamePlayers) -> void:
	currentPlayerTurn = _currentPlayerTurn
	hands = _hands
	playerInteractor = _playerInteractor
	playedCards = _playedCards
	game = _game
	scoresManager = _scoresManager
	gamePlayers = _gamePlayers

func playFirstCard(playerId: String):
	game.roundManager.playFirstCard(playerId)
	game.changeState(PlayerTurnState.new(game, gamePlayers.getNextPlayer(currentPlayerTurn), hands, playerInteractor, playedCards, scoresManager, gamePlayers))

	
func playSecondCard(playerId: String):
	game.roundManager.playSecondCard(playerId)
	game.changeState(PlayerTurnState.new(game, gamePlayers.getNextPlayer(currentPlayerTurn), hands, playerInteractor, playedCards, scoresManager, gamePlayers))

func playThirdCard(playerId: String):
	game.roundManager.playThirdCard(playerId)
	game.changeState(PlayerTurnState.new(game, gamePlayers.getNextPlayer(currentPlayerTurn), hands, playerInteractor, playedCards, scoresManager, gamePlayers))


func callVido(playerId: String):
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
