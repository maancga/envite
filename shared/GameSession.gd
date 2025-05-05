extends Node

class_name GameSession

var gameId: String
var game: Game
var preGame: PreGame
var gamePlayers: GamePlayers
var interactor: PlayerInteractor
var peerIds: Array = []

func _init(gameId_: String, interactor_ : PlayerInteractor):
	gameId = gameId_
	gamePlayers = GamePlayers.new()
	interactor = interactor_
	preGame = PreGame.new(interactor, gamePlayers)

func startGame(ownerId: String):
	game = preGame.start(ownerId)
	if game:
		game.newGame()
		return true
	return false
