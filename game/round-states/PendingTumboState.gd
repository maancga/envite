class_name PendingTumboState extends RoundState

var currentPlayerTurn: String
var hands: RoundHands
var playerInteractor: PlayerInteractor
var playedCards: PlayedCards
var game: Game
var scoresManager: ScoresManager
var gamePlayers: GamePlayers
var team1IsOnTumbo
var team2IsOnTumbo

func _init(_game: Game, _currentPlayerTurn: String, _hands: RoundHands, _playerInteractor: PlayerInteractor, _playedCards: PlayedCards, _scoresManager: ScoresManager, _gamePlayers: GamePlayers, _team1IsOnTumbo: bool, _team2IsOnTumbo: bool) -> void:
	currentPlayerTurn = _currentPlayerTurn
	hands = _hands
	playerInteractor = _playerInteractor
	playedCards = _playedCards
	game = _game
	scoresManager = _scoresManager
	gamePlayers = _gamePlayers
	team1IsOnTumbo = _team1IsOnTumbo
	team2IsOnTumbo = _team2IsOnTumbo

func playFirstCard(playerId: String):
	playerInteractor.informCannNotPlayCardBecauseTumboIsBeingDecided(playerId)
	return 

func playSecondCard(playerId: String):
	playerInteractor.informCannNotPlayCardBecauseTumboIsBeingDecided(playerId)
	return 

func playThirdCard(playerId: String):
	playerInteractor.informCannNotPlayCardBecauseTumboIsBeingDecided(playerId)
	return 

func callVido(playerId: String):
	playerInteractor.informCannNotCallVidoBecauseTumboIsBeingDecided(playerId)
	return 

func rejectVido(playerId: String):
	playerInteractor.cannotRefuseVidoBecauseThereIsNoVidoCalled(playerId)
	return

func acceptVido(playerId: String):
	playerInteractor.cannotAcceptVidoBecauseThereIsNoVidoCalled(playerId)
	return

func raiseVido(playerId: String):
	playerInteractor.cannotRaiseVidoBecauseThereIsNoVidoCalled(playerId)
	return

func takeTumbo(playerId: String):
	if not gamePlayers.isLeader(playerId): playerInteractor.informOnlyLeaderCanTakeThisDecision(playerId)

	if team1IsOnTumbo && gamePlayers.getTeam(playerId) == "team1":
		game.changeState(PlayerTurnState.new(game, hands, playerInteractor, playedCards, scoresManager, gamePlayers))
		playerInteractor.informTumboIsAccepted()
	if team2IsOnTumbo && gamePlayers.getTeam(playerId) == "team2":
		game.changeState(PlayerTurnState.new(game, hands, playerInteractor, playedCards, scoresManager, gamePlayers))
		playerInteractor.informTumboIsAccepted()

func achicarse(playerId: String):
	if not gamePlayers.isLeader(playerId): playerInteractor.informOnlyLeaderCanTakeThisDecision(playerId)
	if team1IsOnTumbo && gamePlayers.getTeam(playerId) == "team1":
		scoresManager.teamOneRejectsTumbo()
		playerInteractor.informTumboIsRejected()
	if team2IsOnTumbo && gamePlayers.getTeam(playerId) == "team2":
		scoresManager.teamTwoRejectsTumbo()
		playerInteractor.informTumboIsRejected()

func getStateName():
	return "Pending tumbo"
