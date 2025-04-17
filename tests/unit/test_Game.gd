extends "res://addons/gut/test.gd"

func test_starts_a_game_with_4_players_and_deals_to_the_4_players():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	assert_true(spy.dealHandToPlayersBeenCalled(4))
	assert_true(spy.informViradoToPlayerBeenCalled((1)))


func test_notifies_players_in_the_given_order():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")
	
	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	assert_true((spy.calledPlayerIds([
		"136122084",
		"552119499",
		"780900127",
		"721778859",
	])))

	
func test_assigns_dealer_to_first_player_on_new_game():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")
	
	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	assert_true(spy.getLastDealer() == "721778859")

func test_assigns_first_turn_to_the_player_next_to_dealer_player_on_new_game():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")
	
	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	assert_true(spy.getLastInformPlayerTurnCall() == "136122084")

func test_does_nothing_if_playing_player_is_not_current_turn_player():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")
	
	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.playFirstCard("721778859")
	assert_eq(spy.getLastInformPlayerTurnCall(), "136122084")
