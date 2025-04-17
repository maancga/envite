class_name Game


var chico: int
var chicoRound: int

var roundManager: RoundManager
var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor
var cardDealer: CardDealer
var dealerManager: DealerManager

var team1ScoreInChico = 0
var team2ScoreInChico = 0

var team1WonChicos = 0
var team2WonChicos = 0

const DEFAULT_PIEDRAS_WINS = 2

func _init(newGamePlayers: GamePlayers, newPlayerInteractor: PlayerInteractor, deck: Deck):
	gamePlayers = newGamePlayers
	playerInteractor = newPlayerInteractor
	cardDealer = CardDealer.new(newPlayerInteractor, newGamePlayers, deck)
	dealerManager = DealerManager.new(gamePlayers, playerInteractor)
	
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

func getFirstDealer():
	return gamePlayers.playerIds[0]


func teamOneWinsRound():
	dealerManager.setNewDealer()
	if team1IsOnTumbo(): 
		team1WinsChico()
		return
	else: 
		team1ScoreInChico += DEFAULT_PIEDRAS_WINS
		playerInteractor.informTeamWonChicoPoints("team1", team1ScoreInChico)
		setNewRound()

func teamTwoWinsRound():
	dealerManager.setNewDealer()
	if team2IsOnTumbo(): 
		team2WinsChico()
		return
	else: 
		team2ScoreInChico += DEFAULT_PIEDRAS_WINS
		playerInteractor.informTeamWonChicoPoints("team2", team2ScoreInChico)
		setNewRound()

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
	roundManager.playFirstCard(id)
	
func playSecondCard(id: String):
	roundManager.playSecondCard(id)

func playThirdCard(id: String):
	roundManager.playThirdCard(id)
