class_name Game

var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor
var chico: int
var chicoRound: int
var currentPlayerTurn: String

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


func _init(newGamePlayers:GamePlayers, newPlayerInteractor: PlayerInteractor, deck: Deck):
	gamePlayers = newGamePlayers
	playerInteractor = newPlayerInteractor
	currentDeck = deck

	
func hasPlayers(amount: int):
	return gamePlayers.hasPlayers(amount)

func newGame():
	print("new game called!")
	chico = 1
	chicoRound = 1
	currentPlayerTurn = gamePlayers.players[0]
	playerInteractor.informPlayerTurn(currentPlayerTurn)
	currentRoundTurn = 1
	startRound()

func startRound(): 
	currentDeck.createAndShuffle()
	currentHands = {}
	deal()

func deal():
	var players = gamePlayers.players
	for player in players:
		var playerHand = ServerHand.new(currentDeck.getTopCard(), currentDeck.getTopCard(), currentDeck.getTopCard())
		currentHands[player] = playerHand
		playerInteractor.dealHandToPlayer(player, playerHand)
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
	if winnerTeam == "team1": team1ScoreInRound +=1
	if winnerTeam == "team2": team2ScoreInRound +=1
	if team1ScoreInRound == 2: teamOneWinsRound()
	if team2ScoreInRound == 2: teamTwoWinsRound()
	currentRoundTurn = 1
	currentPlayerTurn = roundWinner

func teamOneWinsRound():
	if team1IsOnTumbo(): team1WinsChico()
	else: 
		team1ScoreInChico += 1
		deal()

func team1IsOnTumbo():
	return false

func team1WinsChico():
	if (team1WonChicos == 3): team1Wins()
	team1WonChicos +=1

func team1Wins():
	print("team 1 won!")

func teamTwoWinsRound():
	if team2IsOnTumbo(): team2WinsChico()
	else: 
		team2ScoreInChico += 1
		deal()
func team2IsOnTumbo():
	return false

func team2WinsChico():
	if (team2WonChicos == 3): team2Wins()
	team2WonChicos +=1

func team2Wins():
	print("team 2 won!")

func playFirstCard(id: String):
	print("player ", gamePlayers.playersIdsMap[id], " attempted to play its first card")
	if(currentPlayerTurn != id): 
		print("can not play since its not its turn")
		return
	if(roundPlayedCards.size() == 0): firstPlayerPlayedCard =  currentHands[id].firstCard
	roundPlayedCards[id] = currentHands[id].firstCard
	currentHands[id].playFirstCard()
	nextTurn()
	
func playSecondCard(id: String):
	print("player ", gamePlayers.playersIdsMap[id], " attempted to play its second card")
	if(currentPlayerTurn != id): 
		print("can not play since its not its turn")
		return
	if(roundPlayedCards.size() == 0): firstPlayerPlayedCard =  currentHands[id].secondCard
	roundPlayedCards[id] = currentHands[id].secondCard
	currentHands[id].playSecondCard()
	nextTurn()
	
func playThirdCard(id: String):
	print("player ", gamePlayers.playersIdsMap[id], " attempted to play its third card")
	if(currentPlayerTurn != id): 
		print("can not play since its not its turn")
		return
	if(roundPlayedCards.size() == 0): firstPlayerPlayedCard =  currentHands[id].thirdCard
	roundPlayedCards[id] = currentHands[id].thirdCard
	currentHands[id].playThirdCard()
	nextTurn()

func calculateRoundWinner():
	return RoundWinnerCalculator.new(virado, firstPlayerPlayedCard).calculateWinner(roundPlayedCards)

	
