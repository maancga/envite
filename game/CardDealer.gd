class_name CardDealer

var playerInteractor
var gamePlayers: GamePlayers
var deck: Deck

func _init(_playerInteractor: PlayerInteractor, _gamePlayers: GamePlayers, _deck: Deck) -> void:
	playerInteractor = _playerInteractor
	gamePlayers = _gamePlayers
	deck = _deck


func dealHands(dealer: String) -> RoundHands:
	playerInteractor.informDealer(dealer)
	deck.createAndShuffle()
	var dealingTo =  gamePlayers.getNextPlayer(dealer)
	var playerCount = gamePlayers.amountOfPlayers()
	var hands = RoundHands.new(playerInteractor)
	for dealingIndex in playerCount:
		var playerHand = deck.getAHand()
		hands.addHand(dealingTo, playerHand)
		dealingTo = gamePlayers.getNextPlayer(dealingTo)
	return hands

func dealVirado():
	var virado = deck.getTopCard()
	playerInteractor.informVirado(virado)
	return virado
