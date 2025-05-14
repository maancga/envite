extends Node

class_name GameSession

var gameId: String
var game: Game
var preGame: PreGame
var gamePlayers: GamePlayers
var interactor: PlayerInteractor
var peerIds: Array = []
var lobbySignalsConnected = false
var playersJoinedToGame = []

func _init(gameId_: String, interactor_ : PlayerInteractor):
	gameId = gameId_
	gamePlayers = GamePlayers.new()
	interactor = interactor_
	preGame = PreGame.new(interactor, gamePlayers)

func createGameFromPregame(ownerId: String):
	game = preGame.start(ownerId)
	if game:
		return true
	return false

func startGame():
	print("Partida empezada!")
	game.newGame()

func markLobbySignalsAsConnected():
	lobbySignalsConnected = true

func addPlayerToJoinedPlayers(playerId: String):
	if (gamePlayers.playerExists(playerId)): playersJoinedToGame.push_back(playerId)


func allPlayersHaveJoined():
	return gamePlayers.playerIds.size() == playersJoinedToGame.size()
