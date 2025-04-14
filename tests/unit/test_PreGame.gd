extends "res://addons/gut/test.gd"

func test_creates_a_game_with_4_players():
	var preGame = PreGame.new(TestPlayerInteractor.new())
	preGame.addPlayer("721778859")
	preGame.addPlayer("136122084")
	preGame.addPlayer("552119499")
	preGame.addPlayer("780900127")

	assert_eq(preGame.amountOfPlayers(), 4)
	
func test_starts_a_game_with_4_players():
	var preGame = PreGame.new(TestPlayerInteractor.new())
	preGame.addPlayer("721778859")
	preGame.addPlayer("136122084")
	preGame.addPlayer("552119499")
	preGame.addPlayer("780900127")

	assert_eq(preGame.isGameStartable, true)

func test_fails_if_there_are_not_any_players():
	var preGame = PreGame.new(TestPlayerInteractor.new())

	assert_eq(preGame.isGameStartable, false)

func test_fails_if_there_are_less_than_4_players():
	var preGame = PreGame.new(TestPlayerInteractor.new())

	preGame.addPlayer("721778859")
	preGame.addPlayer("136122084")
	preGame.addPlayer("552119499")

	assert_eq(preGame.isGameStartable, false)

func test_returns_a_game():
	var preGame = PreGame.new(TestPlayerInteractor.new())

	preGame.addPlayer("721778859")
	preGame.addPlayer("136122084")
	preGame.addPlayer("552119499")
	preGame.addPlayer("780900127")

	var game = preGame.start()

	assert_not_null(game)
	assert_true(game is Game) 

func test_does_not_return_a_game_if_there_are_not_enough_players():
	var preGame = PreGame.new(TestPlayerInteractor.new())

	preGame.addPlayer("721778859")
	preGame.addPlayer("136122084")
	preGame.addPlayer("552119499")

	var game = preGame.start()

	assert_null(game)

func test_returns_a_game_with_4_players():
	var preGame = PreGame.new(TestPlayerInteractor.new())

	preGame.addPlayer("721778859")
	preGame.addPlayer("136122084")
	preGame.addPlayer("552119499")
	preGame.addPlayer("780900127")

	var game = preGame.start()

	assert_true(game.hasPlayers(4))

func test_returns_a_game_with_5_players():
	var preGame = PreGame.new(TestPlayerInteractor.new())

	preGame.addPlayer("721778859")
	preGame.addPlayer("136122084")
	preGame.addPlayer("552119499")
	preGame.addPlayer("780900127")
	preGame.addPlayer("2035371348")

	var game = preGame.start()

	assert_true(game.hasPlayers(5))

func test_returns_a_game_with_6_players():
	var preGame = PreGame.new(TestPlayerInteractor.new())

	preGame.addPlayer("721778859")
	preGame.addPlayer("136122084")
	preGame.addPlayer("552119499")
	preGame.addPlayer("780900127")
	preGame.addPlayer("2035371348")
	preGame.addPlayer("111111111")

	var game = preGame.start()

	assert_true(game.hasPlayers(6))

func test_doesnt_allow_more_than_6_players():
	var preGame = PreGame.new(TestPlayerInteractor.new())
	preGame.addPlayer("721778859")
	preGame.addPlayer("136122084")
	preGame.addPlayer("552119499")
	preGame.addPlayer("780900127")
	preGame.addPlayer("2035371348")
	preGame.addPlayer("111111111")
	preGame.addPlayer("222222222")

	assert_eq(preGame.amountOfPlayers(), 6)

func test_doesnt_allow_the_same_player_twice():
	var preGame = PreGame.new(TestPlayerInteractor.new())
	preGame.addPlayer("721778859")
	preGame.addPlayer("721778859")

	assert_eq(preGame.amountOfPlayers(), 1)
