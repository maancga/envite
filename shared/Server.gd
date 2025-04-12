extends Node

class_name Server

const DeckScript = preload("res://decks/Deck.gd")

var players = []
var playersIdsMap = {}
var deck
var hands := {}
var dealHandToPlayer
var informViradoToPlayer

func startServer(port = 9000):
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(port)
	if err != OK:
		push_error("❌ Could not start server!")
		return
	multiplayer.multiplayer_peer = peer
	print("🟢 Server running on port", port)

func onClientConnected(id):
	if playersIdsMap.has(id):
		print("⚠️ Peer already registered:", id)
		return
	players.append(id)
	var playerIndex = players.size() - 1
	playersIdsMap[id] = players.size() - 1
	print("🎮 Player connected with id: ", id, " as player ", playerIndex)
	if(players.size() > 1):
		startGame()

func _ready():
	multiplayer.peer_connected.connect(onClientConnected)
	
func deal():
	for player in players:
		var hand = {1: deck.getTopCard().to_dict(), 2:  deck.getTopCard().to_dict(), 3:  deck.getTopCard().to_dict() }
		hands[player] = hand
		if dealHandToPlayer:
			dealHandToPlayer.call(player, hand)
	var virado = deck.getTopCard().to_dict()
	for player in players:
		informViradoToPlayer.call(player, virado)

func startGame():
	print("game started!")
	deck = DeckScript.new()
	deck.createAndShuffle()
	deal()
