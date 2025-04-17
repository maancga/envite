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
	if(turn == gamePlayers.amountOfPlayers()): return finishHand()
	turn += 1
	currentPlayerTurn = gamePlayers.getNextPlayer(currentPlayerTurn)
	playerInteractor.informPlayerTurn(currentPlayerTurn)

func finishHand():
	var handWinner = calculateHandWinner()
	var handWinnerTeam = gamePlayers.getTeam(handWinner)
	playedCards.cleanCards()
	if handWinnerTeam == "team1": 
		team1ScoreInRound +=1
		playerInteractor.informPlayerRoundWinner(handWinner, team1ScoreInRound)
	if handWinnerTeam == "team2": 
		team2ScoreInRound +=1
		playerInteractor.informPlayerRoundWinner(handWinner, team2ScoreInRound)
	if team1ScoreInRound == 2: 
		informTeamOneWonRound()
		return 
	if team2ScoreInRound == 2: 
		informTeamTwoWonRound()
		return
	turn = 1
	currentPlayerTurn = handWinner
	playerInteractor.informPlayerTurn(currentPlayerTurn)

	
func informTeamOneWonRound():
	team1WonRoundSignal.emit()

func informTeamTwoWonRound():
	team2WonRoundSignal.emit()

func calculateHandWinner():
	return playedCards.calculateWinner(virado)

func playCard(playerId: String, card: ServerHandCard):
	if(currentPlayerTurn != playerId): 
		playerInteractor.informPlayerCouldNotPlayCardBecauseItsNotTurn(playerId)
		return
	if playedCards.playerHasPlayedAlready(playerId): 
		playerInteractor.informPlayerCouldNotPlayCardBacauseHasPlayedAlreadyInCurrentHand(playerId)
		return
	if card.isPlayed():
		playerInteractor.informPlayerCouldNotPlayCardBecauseItsPlayedAlready(playerId)
		return
	card.play()
	playedCards.addCard(playerId, card)
	nextTurn()

func playFirstCard(playerId: String):
	var playedCard = hands.getFirstCard(playerId)
	playCard(playerId, playedCard)
	
func playSecondCard(playerId: String):
	var playedCard = hands.getSecondCard(playerId)
	playCard(playerId, playedCard)

func playThirdCard(playerId: String):
	var playedCard = hands.getThirdCard(playerId)
	playCard(playerId, playedCard)
