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
signal receivedPlayedTurnSignal(playerId)
signal receiveCardPlayedSignal(playerId, card, playedOrder)
signal receivePlayerRoundWinnerSignal(playerId, card, playedOrder)
signal receivedPlayersAndTeamsSignal(players, team1, team2)
signal receiveTeamWonChicoPointsSignal(teamName, chicoPoints)
signal receiveTeamWonChicoSignal(teamName, chicos)
signal receiveTeamWonSignal(teamName)
signal informGotDealerSignal(dealer)
signal receivePlayerCouldNotPlayCardBecauseItsNotTurnSignal(playerId)

var preGame: PreGame
var game: Game
var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor
var hasGameStarted = false

func _init() -> void:
	gamePlayers = GamePlayers.new()

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
	playerInteractor.connect("sendPlayersAndTeamsSignal", Callable(self, "onReceivedPlayersAndTeams", ))
	playerInteractor.connect("dealHandToPlayerSignal", Callable(self, "onDealtHand", ))
	playerInteractor.connect("dealVirado", Callable(self, "onDealtVirado", ))
	playerInteractor.connect("sendCurrentPlayerTurnSignal", Callable(self, "onPlayerTurn"))
	playerInteractor.connect("sendPlayerPlayedCardSignal", Callable(self, "onPlayedCard"))
	playerInteractor.connect("sendPlayerCouldNotPlayCardBecauseItsNotTurnSignal", Callable(self, "onPlayerCouldNotPlayCardBecauseItsNotTurn"))
	playerInteractor.connect("sendPlayerRoundWinnerSignal", Callable(self, "onPlayerRoundWinner"))
	playerInteractor.connect("sendTeamWonChicoPointsSignal", Callable(self, "onTeamWonChicoPoints"))
	playerInteractor.connect("sendTeamWonChicoSignal", Callable(self, "onTeamWonChico"))
	playerInteractor.connect("sendTeamWonSignal", Callable(self, "onTeamWon"))
	playerInteractor.connect("informDealerSignal", Callable(self, "onGotDealer"))

	playerInteractor.name = "Interactor"
	add_child(playerInteractor)
	preGame = PreGame.new(playerInteractor, gamePlayers)
	preGame.name = "Pregame"
	add_child(preGame)

func onClientConnected(id):
	print("🟢 Client connected with id: ", id)

func onReceivedPlayersAndTeams(players: Dictionary, team1: Array[String], team2: Array[String]):
	rpc("receivePlayersAndTeams", players, team1, team2)

func onDealtHand(player: String, hand: ServerHand):
	rpc_id(int(player),"receiveHand", hand.to_dict())

func onDealtVirado(card: ServerCard):
	rpc("receiveVirado", card.to_dict())

func onPlayerTurn(player: String):
	rpc("receivePlayerTurn", player)

func onPlayerCouldNotPlayCardBecauseItsNotTurn(player: String):	
	print("can not play since its not its turn")
	rpc_id(int(player), "receivePlayerCouldNotPlayCardBecauseItsNotTurn")

func onPlayedCard(player: String, card: ServerCard, playedOrder: int):
	rpc("receiveCardPlayed", player, card.to_dict(), playedOrder)

func onPlayerRoundWinner(player: String, roundScore: int):
	rpc("receivePlayerRoundWinner", player, roundScore)

func onTeamWonChicoPoints(teamName: String, chicoPoints: int):
	rpc("receiveTeamWonChicoPoints", teamName, chicoPoints)

func onTeamWonChico(teamName: String, chicos: int):
	rpc("receiveTeamWonChico", teamName, chicos)

func onTeamWon(teamName: String):
	rpc("receiveTeamWon", teamName)

func onGotDealer(dealer: String):
	rpc("receiveDealer", dealer)


@rpc("any_peer")
func onClientPlayedCard(cardIndex):
	var sender = multiplayer.get_remote_sender_id()
	var playerId = str(sender)
	print("Player ", gamePlayers.getPlayerName(playerId), " attempted to play its ", cardIndex," card.")
	if cardIndex == "1": game.playFirstCard(playerId)
	if cardIndex == "2": game.playSecondCard(playerId)
	if cardIndex == "3": game.playThirdCard(playerId)

@rpc("any_peer")
func onClientChoosesName(chosenName: String):
	var sender = multiplayer.get_remote_sender_id()
	preGame.addPlayer(str(sender), chosenName)
	game = preGame.start()
	if game is Game:
		game.newGame()
		for player in gamePlayers.playerIds:
			rpc_id(int(player), "gameStarted")

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
func receivePlayersAndTeams(players: Dictionary, team1: Array[String], team2: Array[String]):
	receivedPlayersAndTeamsSignal.emit(players, team1, team2)
	
@rpc("authority")
func receiveHand(hand: Dictionary):
	cardsReceivedSignal.emit(hand)

@rpc("authority")
func receiveVirado(virado: Dictionary):
	viradoReceivedSignal.emit(virado)

@rpc("authority")
func gameStarted():
	gameStartedSignal.emit()

@rpc("authority")
func receivePlayerTurn(player: String):
	receivedPlayedTurnSignal.emit(player)

@rpc("authority")
func receiveCardPlayed(player: String, card: Dictionary, playedOrder: int):
	receiveCardPlayedSignal.emit(player, card, playedOrder)

@rpc("authority")
func receivePlayerRoundWinner(player: String, roundScore: int):
	receivePlayerRoundWinnerSignal.emit(player, roundScore)

@rpc("authority")
func receiveTeamWonChicoPoints(teamName: String, chicoPoints: int):
	receiveTeamWonChicoPointsSignal.emit(teamName, chicoPoints)

@rpc("authority")
func receiveTeamWonChico(teamName: String, chicos: int):
	receiveTeamWonChicoSignal.emit(teamName, chicos)

@rpc("authority")
func receiveTeamWon(teamName: String):
	receiveTeamWonSignal.emit(teamName)

@rpc("authority")
func receiveDealer(dealer: String):
	informGotDealerSignal.emit(dealer)

@rpc("authority")
func receivePlayerCouldNotPlayCardBecauseItsNotTurn(player: String):
	print("Player ", gamePlayers.getPlayerName(player), " could not play card since it is not its turn.")
	receivePlayerCouldNotPlayCardBecauseItsNotTurnSignal.emit(player)

func playCard(cardIndex: String) -> void:
	if cardIndex not in CardIndex.values():
		push_error("Invalid cardIndex: " + cardIndex)
		return

	rpc_id(1, "onClientPlayedCard", cardIndex)

func chooseName(playerName: String) -> void:
	rpc_id(1, "onClientChoosesName", playerName)
