class_name Game

var roundManager: RoundManager
var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor
var cardDealer: CardDealer
var dealerManager: DealerManager
var gameState: RoundState
var lastPlayerState: RoundState
var scoresManager: ScoresManager
var triumphHierarchy: TriumphHierarchy
var team1IsOnTumbo = false
var team2IsOnTumbo = false


func _init(newGamePlayers: GamePlayers, newPlayerInteractor: PlayerInteractor, deck: Deck, _triumphHierarchy: TriumphHierarchy):
	gamePlayers = newGamePlayers
	playerInteractor = newPlayerInteractor
	cardDealer = CardDealer.new(newPlayerInteractor, newGamePlayers, deck)
	dealerManager = DealerManager.new(gamePlayers, playerInteractor)
	scoresManager = ScoresManager.new(playerInteractor, gamePlayers)
	scoresManager.connect("teamWonGame", Callable(self, "teamWins"))
	scoresManager.connect("wonRoundSignal", Callable(self, "setNewRound"))
	scoresManager.connect("wonChicoSignal", Callable(self, "onChicoWon"))
	scoresManager.connect("team1IsOnTumboSignal", Callable(self, "onTeam1IsOnTumbo"))
	scoresManager.connect("team2IsOnTumboSignal", Callable(self, "onTeam2IsOnTumbo"))

	triumphHierarchy = _triumphHierarchy

func changeState(newState: RoundState):
	gameState = newState
	
func hasPlayers(amount: int):
	return gamePlayers.hasPlayers(amount)

func onChicoWon():
	team1IsOnTumbo = false
	team2IsOnTumbo = false
	setNewRound()

func setNewRound():
	dealerManager.setNewDealer()
	startRound()

func startRound():
	roundManager = RoundManager.new(cardDealer, gamePlayers, playerInteractor, scoresManager, triumphHierarchy)
	roundManager.deal(dealerManager.getCurrentDealer())
	if (not gameIsOnTumbo()):
		gameState = PlayerTurnState.new(self, roundManager.hands, playerInteractor, roundManager.playedCards, scoresManager, gamePlayers)
	else:
		playerInteractor.informGameIsOnTumbo()
		gameState = PendingTumboState.new(self, gamePlayers.getNextPlayer(dealerManager.getCurrentDealer()), roundManager.hands, playerInteractor, roundManager.playedCards, scoresManager, gamePlayers, team1IsOnTumbo, team2IsOnTumbo)

func newGame():
	playerInteractor.informPlayersAndTeams(gamePlayers.toDictionary())
	startRound()

func teamWins(teamName: String):
	playerInteractor.informTeamWon(teamName)

func playFirstCard(id: String):
	gameState.playFirstCard(id)
	
func playSecondCard(id: String):
	gameState.playSecondCard(id)

func playThirdCard(id: String):
	gameState.playThirdCard(id)

func callVido(id: String):
	lastPlayerState = gameState
	gameState.callVido(id)

func rejectVido(id: String):
	gameState.rejectVido(id)
	lastPlayerState = null

func acceptVido(id: String):
	gameState.acceptVido(id)
	gameState = lastPlayerState
	lastPlayerState = null

func raiseVido(id: String):
	gameState.raiseVido(id)

func takeTumbo(id: String):
	gameState.takeTumbo(id)

func notTakeTumbo(id: String):
	gameState.notTakeTumbo(id)

func onTeam1IsOnTumbo():
	team1IsOnTumbo = true

func onTeam2IsOnTumbo():
	team2IsOnTumbo = true

func gameIsOnTumbo():
	return team1IsOnTumbo || team2IsOnTumbo


	
