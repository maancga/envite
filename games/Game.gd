class_name Game

var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor
var chico: int
var chicoRound: int
var currentPlayerTurn: String

var currentDeck
var currentHands: Dictionary[String, ServerHand] = {}
var dealHandToPlayer
var informViradoToPlayer
var roundPlayedCards: Dictionary[String, ServerCard] = {}
var virado: ServerCard
var firstPlayerPlayedCard: ServerCard

func _init(newGamePlayers:GamePlayers, newPlayerInteractor: PlayerInteractor, deck: Deck):
	gamePlayers = newGamePlayers
	playerInteractor = newPlayerInteractor
	currentDeck = deck

	
func hasPlayers(amount: int):
	return gamePlayers.hasPlayers(amount)

func newGame():
	chico = 1
	chicoRound = 1
	currentPlayerTurn = gamePlayers.players[0]
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
		playerInteractor.informViradoToPlayer(player, virado)

func setNextPlayer():
	currentPlayerTurn = gamePlayers.getNext(currentPlayerTurn)

func playFirstCard(id: String):
	if(currentPlayerTurn != id): return
	if(roundPlayedCards.size() == 0): firstPlayerPlayedCard =  currentHands[id].firstCard
	roundPlayedCards[id] = currentHands[id].firstCard
	currentHands[id].playFirstCard()
	setNextPlayer()
	
func playSecondCard(id: String):
	if(currentPlayerTurn != id): return
	if(roundPlayedCards.size() == 0): firstPlayerPlayedCard =  currentHands[id].firstCard
	roundPlayedCards[id] = currentHands[id].secondCard
	currentHands[id].playSecondCard()
	setNextPlayer()
	
func playThirdCard(id: String):
	if(currentPlayerTurn != id): return
	if(roundPlayedCards.size() == 0): firstPlayerPlayedCard =  currentHands[id].firstCard
	roundPlayedCards[id] = currentHands[id].thirdCard
	currentHands[id].playThirdCard()
	setNextPlayer()

func calculateRoundWinner():
	return RoundWinnerCalculator.new(virado, firstPlayerPlayedCard).calculateWinner(roundPlayedCards)

	
