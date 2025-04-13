extends Node

class_name ServerManager

signal clientConnectedSignal
signal cardsReceivedSignal(cards)
signal viradoReceivedSignal(virado)

var server
var client

func _ready() -> void:
	print("ServerManager path:", get_path())

func start_server():
	server = preload("res://shared/Server.gd").new()
	server.dealHandToPlayer = func(player_id, hand):
		rpc_id(player_id, "receive_hand", hand)
	server.informViradoToPlayer = func(player_id, virado):
		rpc_id(player_id, "receiveVirado", virado)
	add_child(server)
	server.startServer()

func start_client():
	client = preload("res://shared/Client.gd").new()
	add_child(client)
	client.connectClient()
	emit_signal("clientConnectedSignal")
	
func startGame():
	server.startGame()
	
@rpc("authority")
func receive_hand(cards):
	emit_signal("cardsReceivedSignal", cards)

@rpc("authority")
func receiveVirado(virado):
	emit_signal("viradoReceivedSignal", virado)
	
@rpc("any_peer")
func onClientPlayedCard(cardData):
	var sender = multiplayer.get_remote_sender_id()
	var card = CardData.new(cardData.value, cardData.suit)
	server.onClientPlayedCard(sender,card)
	
func playCard(cardData: CardData):
	rpc_id(1, "onClientPlayedCard", cardData.to_dict())
