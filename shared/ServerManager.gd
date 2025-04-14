extends Node

class_name ServerManager

const CardIndex = {
	CARD_1 = "1",
	CARD_2 = "2",
	CARD_3 = "3"
}

signal clientConnectedSignal
signal cardsReceivedSignal(cards)
signal viradoReceivedSignal(virado)
signal gameStartedSignal()
signal receivedPlayedTurn(playerId)

var preGame: PreGame
var game: Game
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
	playerInteractor.connect("sendCurrentPlayerTurnSignal", Callable(self, "onPlayerTurn"))
	playerInteractor.name = "Interactor"
	add_child(playerInteractor)
	preGame = PreGame.new(playerInteractor)
	preGame.name = "Pregame"
	add_child(preGame)

func onClientConnected(id):
	preGame.addPlayer(str(id))
	game = preGame.start()
	if game is Game:
		game.newGame()
		for player in game.gamePlayers.players:
			rpc_id(int(player), "gameStarted")

func onDealtHand(player: String, hand: ServerHand):
	rpc_id(int(player),"receiveHand", hand.to_dict())

func onDealtVirado(card: ServerCard):
	rpc("receiveVirado", card.to_dict())

func onPlayerTurn(player: String):
	rpc("receivePlayerTurn", player)


@rpc("any_peer")
func onClientPlayedCard(cardIndex):
	var sender = multiplayer.get_remote_sender_id()
	if cardIndex == "1": game.playFirstCard(str(sender))
	if cardIndex == "2": game.playSecondCard(str(sender))
	if cardIndex == "3": game.playThirdCard(str(sender))

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

@rpc("authority")
func receivePlayerTurn(player: String):
	receivedPlayedTurn.emit(player)

func playCard(cardIndex: String) -> void:
	if cardIndex not in CardIndex.values():
		push_error("Invalid cardIndex: " + cardIndex)
		return

	rpc_id(1, "onClientPlayedCard", cardIndex)
