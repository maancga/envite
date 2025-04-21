class_name RoundManager

var hands: RoundHands
var turn = 0
var currentPlayerTurn: String
var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor
var scoresManager: ScoresManager
var triumphHierarchy: TriumphHierarchy

var team1ScoreInRound = 0
var team2ScoreInRound = 0

var virado: ServerCard
var firstPlayerPlayedCard: ServerCard
var playedCards: PlayedCards

var cardDealer: CardDealer

func _init(_cardDealer: CardDealer, _gamePlayers: GamePlayers, _playerInteractor: PlayerInteractor, _scoresManager: ScoresManager, _triumphHierarchy: TriumphHierarchy):
	gamePlayers = _gamePlayers
	playerInteractor = _playerInteractor
	cardDealer = _cardDealer
	scoresManager = _scoresManager
	triumphHierarchy = _triumphHierarchy
	turn = 1

func deal(dealerId: String):
	playedCards = PlayedCards.new(playerInteractor, triumphHierarchy)
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
		scoresManager.teamOneWinsRound()
		return 
	if team2ScoreInRound == 2: 
		scoresManager.teamTwoWinsRound()
		return
	turn = 1
	currentPlayerTurn = handWinner
	playerInteractor.informPlayerTurn(currentPlayerTurn)

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
	playerInteractor.informPlayerPlayedCard(playerId, card, playedCards.amountOfCards())
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

	
