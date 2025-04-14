extends Node

class_name ServerManager

signal clientConnectedSignal
signal cardsReceivedSignal(cards)
signal viradoReceivedSignal(virado)
signal gameStartedSignal()

var preGame: PreGame
var playerInteractor: PlayerInteractor
var hasGameStarted = false

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
	playerInteractor = RealPlayerInteractor.new()
	playerInteractor.connect("dealHandToPlayerSignal", Callable(self, "onDealtHand", ))
	playerInteractor.connect("dealViradoToPlayerSignal", Callable(self, "onDealtVirado", ))
	playerInteractor.name = "Interactor"
	add_child(playerInteractor)
	preGame = PreGame.new(playerInteractor)
	preGame.name = "Pregame"
	add_child(preGame)



func onClientConnected(id):
	preGame.addPlayer(str(id))
	var game = preGame.start()
	if game is Game:
		game.newGame()
		for player in game.gamePlayers.players:
			rpc_id(int(player), "gameStarted")

func onDealtHand(player: String, hand: ServerHand):
	rpc_id(int(player),"receiveHand", hand.to_dict())

func onDealtVirado(player: String, card: ServerCard):
	rpc_id(int(player),"receiveVirado", card.to_dict())


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
func receiveHand(hand):
	cardsReceivedSignal.emit(hand)

@rpc("authority")
func receiveVirado(virado):
	viradoReceivedSignal.emit(virado)

@rpc("authority")
func gameStarted():
	gameStartedSignal.emit()

func playCard(cardData: CardData):
	rpc_id(1, "onClientPlayedCard", cardData.to_dict())
