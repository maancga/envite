extends "res://addons/gut/test.gd"

	
func test_raises_vido_until_game():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.callVido("136122084")
	game.raiseVido("721778859")
	game.raiseVido("136122084")
	game.raiseVido("721778859")
	game.raiseVido("136122084")
	game.acceptVido("721778859")
	assert_eq(spy.vidoRaisedFor7PiedrasCalledTimes(1), true)
	assert_eq(spy.vidoRaisedFor9PiedrasCalledTimes(1), true)
	assert_eq(spy.vidoRaisedForChicoCalledTimes(1), true)
	assert_eq(spy.vidoRaisedForGameCalledTimes(1), true)
	assert_eq(spy.vidoAcceptedCalledTimes(1), true)
	assert_eq(game.scoresManager.viradoForGame, true)

func test_calls_vido():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.callVido("136122084")
	assert_eq(game.gameState is VidoFor4PiedrasState, true)
	
func test_refuses_vido():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.callVido("136122084")
	game.refuseVido("721778859")
	assert_eq(game.scoresManager.team1Score.scoreInChico, 0)
	assert_eq(game.scoresManager.team2Score.scoreInChico, 2)
	assert_eq(game.gameState is PlayerTurnState, true)

func test_raises_vido_to_7():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.callVido("136122084")
	game.raiseVido("721778859")
	assert_eq(game.gameState is VidoFor7PiedrasState, true)

func test_raises_vido_to_9():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.callVido("136122084")
	game.raiseVido("721778859")
	game.raiseVido("136122084")
	assert_eq(game.gameState is VidoFor9PiedrasState, true)


func test_raises_vido_to_chico():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.callVido("136122084")
	game.raiseVido("721778859")
	game.raiseVido("136122084")
	game.raiseVido("721778859")
	assert_eq(game.gameState is VidoForChico, true)

func test_raises_vido_to_game():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.callVido("136122084")
	game.raiseVido("721778859")
	game.raiseVido("136122084")
	game.raiseVido("721778859")
	game.raiseVido("136122084")
	assert_eq(game.gameState is VidoForGame, true)


func test_refuses_vido_to_game_so_the_other_team_wins_chico():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.callVido("136122084")
	game.raiseVido("721778859")
	game.raiseVido("136122084")
	game.raiseVido("721778859")
	game.raiseVido("136122084")
	game.refuseVido("721778859")

	assert_eq(game.scoresManager.team1Score.wonChicos, 0)
	assert_eq(game.scoresManager.team2Score.wonChicos, 1)
