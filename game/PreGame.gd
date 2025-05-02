extends Node

class_name PreGame

var isGameStartable = false
var gamePlayers: GamePlayers
var interactor: PlayerInteractor
var gameOwner: String

func _init(newInteractor: PlayerInteractor, newGamePlayers: GamePlayers):
	gamePlayers = newGamePlayers
	interactor = newInteractor

func changeGameOwner(playerId: String):
	gameOwner = playerId
	interactor.informIsGameOwner(playerId)

func addPlayer(id: String, newName: String):
	if amountOfPlayers() == 12: 
		interactor.informPlayerCantBeAddedSinceMaxIsReached()
		return 
	gamePlayers.addPlayer(id, newName)
	if gamePlayers.amountOfPlayers() >= 4 : isGameStartable = true
	interactor.informPlayerAdded(gamePlayers.toDictionary())
	interactor.informTriumphsConfiguration(getTriumphsConfiguration())
	if amountOfPlayers() == 1: changeGameOwner(id)

func start(starterPlayer: String):
	if gameOwner != starterPlayer:
		interactor.informGameCanNotStartSinceItsNotOwner(starterPlayer)
	if amountOfPlayers() < 4:
		interactor.informGameCanNotStartSinceTheMinimumOfPlayersIsNotReached(starterPlayer)
		return 
	var triumphHierarchy = getTriumphsConfiguration()

	var game = Game.new(gamePlayers, interactor, NormalDeck.new(), triumphHierarchy)
	return game

func amountOfPlayers():
	return gamePlayers.amountOfPlayers()

func getTriumphsConfiguration() -> TriumphHierarchy:
	if (gamePlayers.amountOfPlayers() <= 4): return FourPlayersTriumphHierarchy.new()
	if (gamePlayers.amountOfPlayers() <= 6): return SixPlayersTriumphHierarchy.new()
	if (gamePlayers.amountOfPlayers() <= 8): return EightPlayersTriumphHierarchy.new()
	if (gamePlayers.amountOfPlayers() <= 10): return TenPlayersTriumphHierarchy.new()
	return TwelvePlayersTriumphHierarchy.new()