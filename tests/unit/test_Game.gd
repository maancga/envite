extends "res://addons/gut/test.gd"

func test_creates_a_game_with_4_players():
	var gamePlayers = GamePlayers.new()
	gamePlayers.addPlayer("721778859")
	gamePlayers.addPlayer("136122084")
	gamePlayers.addPlayer("552119499")
	gamePlayers.addPlayer("780900127")
	var game = Game.new()
	game.setPlayers(gamePlayers)

	assert_eq(game.hasPlayers(4), true)
	
