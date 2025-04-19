class_name Game


var chico: int
var chicoRound: int

var roundManager: RoundManager
var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor
var cardDealer: CardDealer
var dealerManager: DealerManager
var gameState: RoundState

var team1ScoreInChico = 0
var team2ScoreInChico = 0

var team1WonChicos = 0
var team2WonChicos = 0

const DEFAULT_PIEDRAS_WINS = 2
var piedrasOnPlay = 2
var viradoForChico = false

func _init(newGamePlayers: GamePlayers, newPlayerInteractor: PlayerInteractor, deck: Deck):
	gamePlayers = newGamePlayers
	playerInteractor = newPlayerInteractor
	cardDealer = CardDealer.new(newPlayerInteractor, newGamePlayers, deck)
	dealerManager = DealerManager.new(gamePlayers, playerInteractor)

func changeState(newState: RoundState):
	gameState = newState
	
func hasPlayers(amount: int):
	return gamePlayers.hasPlayers(amount)

func setNewRound():
	roundManager = RoundManager.new(cardDealer, gamePlayers, playerInteractor,)
	roundManager.connect("team1WonRoundSignal", Callable(self, "teamOneWinsRound"))
	roundManager.connect("team2WonRoundSignal", Callable(self, "teamTwoWinsRound"))
	roundManager.deal(dealerManager.getCurrentDealer())

func newGame():
	chico = 1
	chicoRound = 1
	playerInteractor.informPlayersAndTeams(gamePlayers.toDictionary())
	setNewRound()
	gameState = PlayerTurnState.new(self, gamePlayers.getFirstPlayer(), roundManager.hands, playerInteractor, roundManager.playedCards)

func setPiedrasOnPlay(piedras: int):
	piedrasOnPlay = piedras

func playingForChico():
	viradoForChico = true

func notPlayingForChico():
	viradoForChico = false

func teamOneWinsRound():
	dealerManager.setNewDealer()
	if (viradoForChico): 
		team1WinsChico()
		return 
	if team1IsOnTumbo(): 
		team1WinsChico()
		return
	else: 
		team1ScoreInChico += piedrasOnPlay
		playerInteractor.informTeamWonChicoPoints("team1", team1ScoreInChico)
		setNewRound()

func teamTwoWinsRound():
	dealerManager.setNewDealer()
	if (viradoForChico): 
		team1WinsChico()
		return 
	if team2IsOnTumbo(): 
		team2WinsChico()
		return
	else: 
		team2ScoreInChico += piedrasOnPlay
		playerInteractor.informTeamWonChicoPoints("team2", team2ScoreInChico)
		setNewRound()

func playerRefusedVido(playerId: String):
	var playerTeam = gamePlayers.getPlayerTeam(playerId)
	if playerTeam == "team1":
		teamTwoWinsRound()
	else:
		teamOneWinsRound()

func team1IsOnTumbo():
	return false

func team2IsOnTumbo():
	return false

func team1WinsChico():
	team1WonChicos +=1
	playerInteractor.informTeamWonChico("team1", team1WonChicos)
	if (team1WonChicos == 3): team1Wins()


func team2WinsChico():
	team2WonChicos +=1
	playerInteractor.informTeamWonChico("team1", team1WonChicos)
	if (team2WonChicos == 3): team2Wins()


func team1Wins():
	print("team 1 won the game")
	playerInteractor.informTeamWon("team1")

func team2Wins():
	playerInteractor.informTeamWon("team1")
	print("team 2 won the game")

func playFirstCard(id: String):
	gameState.playFirstCard(id)
	
func playSecondCard(id: String):
	gameState.playSecondCard(id)

func playThirdCard(id: String):
	gameState.playThirdCard(id)

func callVido(id: String):
	gameState.callVido(id)

func refuseVido(id: String):
	gameState.refuseVido(id)

func acceptVido(id: String):
	gameState.acceptVido(id)

func raiseVido(id: String):
	gameState.raiseVido(id)

	