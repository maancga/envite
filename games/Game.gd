class_name Game

const DeckScript = preload("res://decks/Deck.gd")

var deck
var players = []
var hands := {}
var dealHandToPlayer
var informViradoToPlayer
var playersIdsMap = {}
var startedGame = false

func _ready():
	deck = DeckScript.new()
	deck.createAndShuffle()
	deal()

func addPlayer(id:String ):
	players.append(id)
	var playerIndex = players.size() - 1
	playersIdsMap[id] = playerIndex

func start():
	startedGame = true

func hasPlayers(amount: int):
	return players.size() == amount


func deal():
	for player in players:
		var hand = {1: deck.getTopCard().to_dict(), 2:  deck.getTopCard().to_dict(), 3:  deck.getTopCard().to_dict() }
		hands[player] = hand
		if dealHandToPlayer:
			dealHandToPlayer.call(player, hand)
	var virado = deck.getTopCard().to_dict()
	for player in players:
		informViradoToPlayer.call(player, virado)
