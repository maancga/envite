extends Node

class_name PreGame

var isGameStartable = false
var gamePlayers: GamePlayers
var interactor: PlayerInteractor

func _init(newInteractor: PlayerInteractor):
	gamePlayers = GamePlayers.new()
	interactor = newInteractor
	print("Pregame created!")

func addPlayer(id: String ):
	gamePlayers.addPlayer(id)
	if gamePlayers.amountOfPlayers() >= 4 : isGameStartable = true

func start():
	if not isGameStartable :
		print("game can not start since there is not the minimal amount of players")
		return 

	var game = Game.new(gamePlayers, interactor, NormalDeck.new())
	return game

func amountOfPlayers():
	return gamePlayers.amountOfPlayers()
