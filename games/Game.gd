class_name Game

const DeckScript = preload("res://decks/Deck.gd")

var deck
var gamePlayers: GamePlayers
var hands := {}
var dealHandToPlayer
var informViradoToPlayer

func _ready():
	deck = DeckScript.new()
	deck.createAndShuffle()
	deal()

func setPlayers(newGamePlayers:GamePlayers ):
	gamePlayers = newGamePlayers

func hasPlayers(amount: int):
	return gamePlayers.hasPlayers(amount)

func deal():
	var players = gamePlayers.players
	for player in players:
		var hand = {1: deck.getTopCard().to_dict(), 2:  deck.getTopCard().to_dict(), 3:  deck.getTopCard().to_dict() }
		hands[player] = hand
		if dealHandToPlayer:
			dealHandToPlayer.call(player, hand)
	var virado = deck.getTopCard().to_dict()
	for player in players:
		informViradoToPlayer.call(player, virado)
