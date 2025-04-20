class_name Game

var roundManager: RoundManager
var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor
var cardDealer: CardDealer
var dealerManager: DealerManager
var gameState: RoundState
var lastPlayerState: RoundState
var scoresManager: ScoresManager

const DEFAULT_PIEDRAS_WINS = 2
var piedrasOnPlay = 2
var viradoForChico = false
var viradoForGame = false

func _init(newGamePlayers: GamePlayers, newPlayerInteractor: PlayerInteractor, deck: Deck):
	gamePlayers = newGamePlayers
	playerInteractor = newPlayerInteractor
	cardDealer = CardDealer.new(newPlayerInteractor, newGamePlayers, deck)
	dealerManager = DealerManager.new(gamePlayers, playerInteractor)
	scoresManager = ScoresManager.new(playerInteractor, gamePlayers, self)
	scoresManager.connect("teamWonGame", Callable(self, "teamWins"))

func changeState(newState: RoundState):
	gameState = newState
	
func hasPlayers(amount: int):
	return gamePlayers.hasPlayers(amount)

func setNewRound():
	dealerManager.setNewDealer()
	startRound()

func startRound():
	roundManager = RoundManager.new(cardDealer, gamePlayers, playerInteractor, scoresManager)
	roundManager.deal(dealerManager.getCurrentDealer())
	gameState = PlayerTurnState.new(self, gamePlayers.getNextPlayer(dealerManager.getCurrentDealer()), roundManager.hands, playerInteractor, roundManager.playedCards, scoresManager, gamePlayers)

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

func refuseVido(id: String):
	gameState.refuseVido(id)
	gameState = lastPlayerState
	lastPlayerState = null

func acceptVido(id: String):
	gameState.acceptVido(id)
	gameState = lastPlayerState
	lastPlayerState = null

func raiseVido(id: String):
	gameState.raiseVido(id)

	
