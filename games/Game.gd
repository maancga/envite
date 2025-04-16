class_name Game

var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor
var chico: int
var chicoRound: int
var currentPlayerTurn: String
var currentRoundDealer: String

var currentDeck
var currentHands: Dictionary[String, ServerHand] = {}
var roundPlayedCards: Dictionary[String, ServerCard] = {}
var virado: ServerCard
var firstPlayerPlayedCard: ServerCard
var currentRoundTurn = 0

var team1ScoreInRound = 0
var team2ScoreInRound = 0

var team1ScoreInChico = 0
var team2ScoreInChico = 0

var team1WonChicos = 0
var team2WonChicos = 0

const DEFAULT_PIEDRAS_WINS = 2


func _init(newGamePlayers: GamePlayers, newPlayerInteractor: PlayerInteractor, deck: Deck):
	gamePlayers = newGamePlayers
	playerInteractor = newPlayerInteractor
	currentDeck = deck

	
func hasPlayers(amount: int):
	return gamePlayers.hasPlayers(amount)

func newGame():
	print("new game called!")
	chico = 1
	chicoRound = 1
	var team1: Array[String] = []
	for id in gamePlayers.team1.players:
		team1.append(str(id))

	var team2: Array[String] = []
	for id in gamePlayers.team2.players:
		team2.append(str(id))
	playerInteractor.informPlayersAndTeams(gamePlayers.toDictionary(), team1, team2)
	currentRoundDealer = gamePlayers.playerIds[0]
	currentPlayerTurn = gamePlayers.getNext(currentRoundDealer)
	playerInteractor.informPlayerTurn(currentPlayerTurn)
	currentRoundTurn = 1
	startRound()

func startRound(): 
	currentDeck.createAndShuffle()
	currentHands = {}
	deal()

func deal():
	var players = gamePlayers.playerIds
	var dealingTo = currentPlayerTurn
	for player in players:
		var playerHand = ServerHand.new(currentDeck.getTopCard(), currentDeck.getTopCard(), currentDeck.getTopCard())
		currentHands[dealingTo] = playerHand
		playerInteractor.dealHandToPlayer(dealingTo, playerHand)
		dealingTo = gamePlayers.getNext(dealingTo)
	virado = currentDeck.getTopCard()
	for player in players:
		playerInteractor.informViradoToPlayer(virado)

func nextTurn():
	if(currentRoundTurn == gamePlayers.amountOfPlayers()): return finishRound()
	currentRoundTurn += 1
	currentPlayerTurn = gamePlayers.getNext(currentPlayerTurn)
	playerInteractor.informPlayerTurn(currentPlayerTurn)

func finishRound():
	var roundWinner = calculateRoundWinner()
	var winnerTeam = gamePlayers.getTeam(roundWinner)
	if winnerTeam == "team1": 
		team1ScoreInRound +=1
		playerInteractor.informPlayerRoundWinner(roundWinner, team1ScoreInRound)
	if winnerTeam == "team2": 
		team2ScoreInRound +=1
		playerInteractor.informPlayerRoundWinner(roundWinner, team2ScoreInRound)
	if team1ScoreInRound == 2: 
		teamOneWinsRound()
		return 
	if team2ScoreInRound == 2: 
		teamTwoWinsRound()
		return 
	currentRoundTurn = 1
	currentPlayerTurn = roundWinner
	playerInteractor.informPlayerTurn(currentPlayerTurn)

func getNextDealer():
	return gamePlayers.getNext(currentRoundDealer)

func teamOneWinsRound():
	currentRoundDealer = getNextDealer()
	currentPlayerTurn = gamePlayers.getNext(currentRoundDealer)
	if team1IsOnTumbo(): 
		team1WinsChico()
		return
	else: 
		team1ScoreInChico += DEFAULT_PIEDRAS_WINS
		playerInteractor.informTeamWonChicoPoints("team1", team1ScoreInChico)
		deal()

func teamTwoWinsRound():
	currentRoundDealer = getNextDealer()
	currentPlayerTurn = gamePlayers.getNext(currentRoundDealer)
	if team2IsOnTumbo(): 
		team2WinsChico()
		return
	else: 
		team2ScoreInChico += DEFAULT_PIEDRAS_WINS
		playerInteractor.informTeamWonChicoPoints("team2", team2ScoreInChico)
		deal()

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
	print("player ", gamePlayers.playersIdsMap[id], " attempted to play its first card")
	if(currentPlayerTurn != id): 
		print("can not play since its not its turn")
		return
	var playedCard = currentHands[id].firstCard
	if(roundPlayedCards.size() == 0): firstPlayerPlayedCard = playedCard
	roundPlayedCards[id] = playedCard
	currentHands[id].playFirstCard()
	playerInteractor.informPlayerPlayedCard(gamePlayers.playerInstances[id].toDictionary(), playedCard, currentRoundTurn)
	nextTurn()
	
func playSecondCard(id: String):
	print("player ", gamePlayers.playersIdsMap[id], " attempted to play its second card")
	if(currentPlayerTurn != id): 
		print("can not play since its not its turn")
		return
	var playedCard = currentHands[id].secondCard
	if(roundPlayedCards.size() == 0): firstPlayerPlayedCard = playedCard
	roundPlayedCards[id] = playedCard
	currentHands[id].playSecondCard()
	playerInteractor.informPlayerPlayedCard(gamePlayers.playerInstances[id].toDictionary(), playedCard, currentRoundTurn)
	nextTurn()
	
func playThirdCard(id: String):
	print("player ", gamePlayers.playersIdsMap[id], " attempted to play its third card")
	if(currentPlayerTurn != id): 
		print("can not play since its not its turn")
		return
	var playedCard = currentHands[id].thirdCard
	if(roundPlayedCards.size() == 0): firstPlayerPlayedCard = playedCard
	roundPlayedCards[id] = playedCard
	currentHands[id].playThirdCard()
	playerInteractor.informPlayerPlayedCard(gamePlayers.playerInstances[id].toDictionary(), playedCard, currentRoundTurn)
	nextTurn()

func calculateRoundWinner():
	return RoundWinnerCalculator.new(virado, firstPlayerPlayedCard).calculateWinner(roundPlayedCards)
