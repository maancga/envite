class_name RoundManager

var hands: RoundHands
var turn = 0
var currentPlayerTurn: String
var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor

var team1ScoreInRound = 0
var team2ScoreInRound = 0

var virado: ServerCard
var firstPlayerPlayedCard: ServerCard
var playedCards: PlayedCards

var cardDealer: CardDealer

signal team1WonRoundSignal()
signal team2WonRoundSignal()

func _init(_cardDealer: CardDealer, _gamePlayers: GamePlayers, _playerInteractor: PlayerInteractor):
	gamePlayers = _gamePlayers
	playerInteractor = _playerInteractor
	cardDealer = _cardDealer
	turn = 1

func deal(dealerId: String):
	playedCards = PlayedCards.new(playerInteractor)
	currentPlayerTurn = gamePlayers.getNextPlayer(dealerId)
	playerInteractor.informPlayerTurn(currentPlayerTurn)
	hands = cardDealer.dealHands(dealerId)
	virado = cardDealer.dealVirado() 

func nextTurn():
	if(turn == gamePlayers.amountOfPlayers()): return finishRound()
	turn += 1
	currentPlayerTurn = gamePlayers.getNextPlayer(currentPlayerTurn)
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
		informTeamOneWonRound()
		return 
	if team2ScoreInRound == 2: 
		informTeamTwoWonRound()
		return
	turn = 1
	currentPlayerTurn = roundWinner
	playerInteractor.informPlayerTurn(currentPlayerTurn)

	
func informTeamOneWonRound():
	team1WonRoundSignal.emit()

func informTeamTwoWonRound():
	team2WonRoundSignal.emit()

func calculateRoundWinner():
	return playedCards.calculateWinner(virado)

func playFirstCard(id: String):
	if(currentPlayerTurn != id): 
		playerInteractor.informPlayerCouldNotPlayCardBecauseItsNotTurn(id)
		return
	var playedCard = hands.getFirstCard(id)
	playedCard.play()
	playedCards.addCard(id, playedCard, turn)
	nextTurn()
	
func playSecondCard(id: String):
	if(currentPlayerTurn != id): 
		playerInteractor.informPlayerCouldNotPlayCardBecauseItsNotTurn(id)
		return
	var playedCard = hands.getSecondCard(id)
	playedCard.play()
	playedCards.addCard(id, playedCard, turn)
	nextTurn()
	
func playThirdCard(id: String):
	if(currentPlayerTurn != id): 
		playerInteractor.informPlayerCouldNotPlayCardBecauseItsNotTurn(id)
		return
	var playedCard = hands.getThirdCard(id)
	playedCard.play()
	playedCards.addCard(id, playedCard, turn)
	nextTurn()
