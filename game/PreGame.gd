extends Node

class_name PreGame

var isGameStartable = false
var gamePlayers: GamePlayers
var interactor: PlayerInteractor

func _init(newInteractor: PlayerInteractor, newGamePlayers: GamePlayers):
	gamePlayers = newGamePlayers
	interactor = newInteractor

func addPlayer(id: String, newName: String ):
	gamePlayers.addPlayer(id, newName)
	if gamePlayers.amountOfPlayers() >= 4 : isGameStartable = true

func start():
	if not isGameStartable :
		return 
	var game = Game.new(gamePlayers, interactor, NormalDeck.new(), SixPlayersTriumphHierarchy.new())
	return game

func amountOfPlayers():
	return gamePlayers.amountOfPlayers()
