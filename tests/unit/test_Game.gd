extends "res://addons/gut/test.gd"

func test_creates_a_game_with_4_players():
	var game = Game.new()
	game.addPlayer("721778859")
	game.addPlayer("136122084")
	game.addPlayer("552119499")
	game.addPlayer("780900127")

	assert_eq(game.hasPlayers(4), true)
	
func test_starts_a_game_with_4_players():
	var game = Game.new()
	game.addPlayer("721778859")
	game.addPlayer("136122084")
	game.addPlayer("552119499")
	game.addPlayer("780900127")

	game.start()

	assert_eq(game.startedGame, true)
