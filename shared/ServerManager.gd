extends Node

class_name ServerManager

signal clientConnectedSignal
signal cardsReceivedSignal(cards)
signal viradoReceivedSignal(virado)
signal gameStartedSignal()

var preGame: PreGame

############## SERVER

func startServer(port = 9000):
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(port)
	if err != OK:
		push_error("❌ Could not start server!")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(onClientConnected)
	print("🟢 Server running on port", port)
	preGame = PreGame.new()


func onClientConnected(id):
	preGame.addPlayer(str(id))
	var game = preGame.start()
	if game is Game:
		for player in game.gamePlayers.players:
			game.newGame()
			get_tree().get_root().print_tree_pretty()
			rpc_id(player, "gameStarted")

@rpc("any_peer")
func onClientPlayedCard(cardData):
	var sender = multiplayer.get_remote_sender_id()
	var card = CardData.new(cardData.value, cardData.suit)
	print("el jugador ", sender, " jugó la carta: " , card.getCardName())

################ CLIENT

func connectClient(ip = "127.0.0.1", port = 9000):
	if multiplayer.has_multiplayer_peer() and not multiplayer.is_server():
		print("⚠️ Already connected — ignoring request.")
		return
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip, port)
	if err != OK:
		push_error("❌ Could not connect to server!")
		return
	multiplayer.multiplayer_peer = peer
	print("🟡 Connecting to server at", ip, ":", port)
	clientConnectedSignal.emit()
	
@rpc("authority")
func receiveHand(cards):
	cardsReceivedSignal.emit(cards)

@rpc("authority")
func receiveVirado(virado):
	viradoReceivedSignal.emit(virado)

@rpc("authority")
func gameStarted():
	print("✅ gameStarted() was called")
	gameStartedSignal.emit()

func playCard(cardData: CardData):
	rpc_id(1, "onClientPlayedCard", cardData.to_dict())
