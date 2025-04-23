extends "res://addons/gut/test.gd"

func test_creates_a_game_with_4_players():
	var preGame = PreGame.new(TestPlayerInteractor.new(), GamePlayers.new())
	preGame.addPlayer("721778859", "Chico")
	preGame.addPlayer("136122084", "Pablo")
	preGame.addPlayer("552119499", "Javier")
	preGame.addPlayer("780900127", "Javi")


	assert_eq(preGame.amountOfPlayers(), 4)
	
func test_starts_a_game_with_4_players():
	var preGame = PreGame.new(TestPlayerInteractor.new(), GamePlayers.new())
	preGame.addPlayer("721778859", "Chico")
	preGame.addPlayer("136122084", "Pablo")
	preGame.addPlayer("552119499", "Javier")
	preGame.addPlayer("780900127", "Javi")

	assert_eq(preGame.isGameStartable, true)

func test_fails_if_there_are_not_any_players():
	var preGame = PreGame.new(TestPlayerInteractor.new(), GamePlayers.new())

	assert_eq(preGame.isGameStartable, false)

func test_fails_if_there_are_less_than_4_players():
	var preGame = PreGame.new(TestPlayerInteractor.new(), GamePlayers.new())

	preGame.addPlayer("721778859", "Chico")
	preGame.addPlayer("136122084", "Pablo")
	preGame.addPlayer("552119499", "Javier")


	assert_eq(preGame.isGameStartable, false)

func test_returns_a_game():
	var preGame = PreGame.new(TestPlayerInteractor.new(), GamePlayers.new())

	preGame.addPlayer("721778859", "Chico")
	preGame.addPlayer("136122084", "Pablo")
	preGame.addPlayer("552119499", "Javier")
	preGame.addPlayer("780900127", "Javi")

	var game = preGame.start("721778859")

	assert_not_null(game)
	assert_true(game is Game) 

func test_does_not_return_a_game_if_there_are_not_enough_players():
	var preGame = PreGame.new(TestPlayerInteractor.new(), GamePlayers.new())

	preGame.addPlayer("721778859", "Chico")
	preGame.addPlayer("136122084", "Pablo")
	preGame.addPlayer("552119499", "Javier")
	
	var game = preGame.start("721778859")

	assert_null(game)

func test_returns_a_game_with_4_players():
	var preGame = PreGame.new(TestPlayerInteractor.new(), GamePlayers.new())

	preGame.addPlayer("721778859", "Chico")
	preGame.addPlayer("136122084", "Pablo")
	preGame.addPlayer("552119499", "Javier")
	preGame.addPlayer("780900127", "Javi")

	var game = preGame.start("721778859")

	assert_true(game.hasPlayers(4))

func test_returns_a_game_with_5_players():
	var preGame = PreGame.new(TestPlayerInteractor.new(), GamePlayers.new())

	preGame.addPlayer("721778859", "Chico")
	preGame.addPlayer("136122084", "Pablo")
	preGame.addPlayer("552119499", "Javier")
	preGame.addPlayer("780900127", "Javi")
	preGame.addPlayer("2035371348", "Javi")

	var game = preGame.start("721778859")

	assert_true(game.hasPlayers(5))

func test_returns_a_game_with_6_players():
	var preGame = PreGame.new(TestPlayerInteractor.new(), GamePlayers.new())

	preGame.addPlayer("721778859", "Chico")
	preGame.addPlayer("136122084", "Pablo")
	preGame.addPlayer("552119499", "Javier")
	preGame.addPlayer("780900127", "Javi")
	preGame.addPlayer("2035371348", "Javi")
	preGame.addPlayer("111111111", "Javi")

	var game = preGame.start("721778859")

	assert_true(game.hasPlayers(6))

func test_doesnt_allow_more_than_12_players():
	var preGame = PreGame.new(TestPlayerInteractor.new(), GamePlayers.new())
	preGame.addPlayer("721778859", "Chico")
	preGame.addPlayer("136122084", "Pablo")
	preGame.addPlayer("552119499", "Javier")
	preGame.addPlayer("780900127", "Javi")
	preGame.addPlayer("2035371348", "Javi")
	preGame.addPlayer("111111111", "Javi")
	preGame.addPlayer("222222222", "Javi")
	preGame.addPlayer("222222223", "Javi")
	preGame.addPlayer("222222224", "Javi")
	preGame.addPlayer("222222225", "Javi")
	preGame.addPlayer("222222226", "Javi")	
	preGame.addPlayer("222222227", "Javi")
	preGame.addPlayer("222222229", "Javi")
	preGame.addPlayer("222222210", "Javi")

	assert_eq(preGame.amountOfPlayers(), 12)

func test_doesnt_allow_the_same_player_twice():
	var preGame = PreGame.new(TestPlayerInteractor.new(), GamePlayers.new())
	preGame.addPlayer("721778859", "Chico")
	preGame.addPlayer("721778859", "Chico")

	assert_eq(preGame.amountOfPlayers(), 1)
