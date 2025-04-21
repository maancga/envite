extends Node

class_name PreGame

var isGameStartable = false
var gamePlayers: GamePlayers
var interactor: PlayerInteractor

func _init(newInteractor: PlayerInteractor, newGamePlayers: GamePlayers):
	gamePlayers = newGamePlayers
	interactor = newInteractor

func addPlayer(id: String, newName: String):
	if amountOfPlayers() == 12: 
		interactor.informPlayerCantBeAddedSinceMaxIsReached()
		return 
	gamePlayers.addPlayer(id, newName)
	if gamePlayers.amountOfPlayers() >= 4 : isGameStartable = true
	interactor.informPlayerAdded(gamePlayers.toDictionary())


func start():
	if amountOfPlayers() < 4:
		interactor.informGameCanNotStartSinceTheMinimumOfPlayersIsNotReached()
		return 
	var triumphHierarchy = null
	match gamePlayers.amountOfPlayers():
		4:
			triumphHierarchy = FourPlayersTriumphHierarchy.new()
		6:
			triumphHierarchy = SixPlayersTriumphHierarchy.new()
		8:
			triumphHierarchy = EightPlayersTriumphHierarchy.new()
		10:
			triumphHierarchy = TenPlayersTriumphHierarchy.new()
		12:
			triumphHierarchy = TwelvePlayersTriumphHierarchy.new()

	var game = Game.new(gamePlayers, interactor, NormalDeck.new(), triumphHierarchy)
	return game

func amountOfPlayers():
	return gamePlayers.amountOfPlayers()