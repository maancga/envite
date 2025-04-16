extends "res://addons/gut/test.gd"

func test_starts_a_game_with_4_players_and_deals_to_the_4_players():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	assert_true((spy.dealHandToPlayersBeenCalled(4)))
	assert_true(spy.informViradoToPlayerBeenCalled((1)))


func test_notifies_players_in_the_given_order():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

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
	assert_true(spy.calledPlayerIdsForVirado(([
		"136122084",
		"552119499",
		"780900127",
		"721778859",

	])))

	
func test_assigns_dealer_to_first_player_on_new_game():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	assert_true(game.currentRoundDealer == "721778859")

func test_assigns_first_turn_to_the_player_next_to_dealer_player_on_new_game():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	assert_true(game.currentPlayerTurn == "136122084")

func test_current_player_plays_its_first_card():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.playFirstCard("136122084")
	assert_eq(game.currentHands["136122084"].firstCard.played, true)
	assert_eq(game.currentHands["136122084"].secondCard.played, false)
	assert_eq(game.currentHands["136122084"].thirdCard.played, false)
	assert_true(game.currentPlayerTurn == "552119499")

func all_players_play_a_card_and_since_first_player_wins_it_is_his_turn_again():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var tresDeBastos = ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.BASTOS)

	deck.setTopCards([tresDeBastos])

	var game = Game.new(players, spy, deck)

	game.newGame()

	var firstTurnPlayer = game.currentPlayerTurn
	game.playFirstCard("136122084")
	var secondTurnPlayer = game.currentPlayerTurn
	game.playFirstCard("552119499")
	var thirdTurnPlayer = game.currentPlayerTurn
	game.playFirstCard("780900127")
	var fourthTurnPlayer = game.currentPlayerTurn
	game.playFirstCard("721778859")

	assert_eq(firstTurnPlayer, "136122084")
	assert_eq(game.currentHands["136122084"].firstCard.played, true)
	assert_eq(secondTurnPlayer, "552119499")
	assert_eq(game.currentHands["552119499"].firstCard.played, true)
	assert_eq(thirdTurnPlayer, "780900127")
	assert_eq(game.currentHands["780900127"].firstCard.played, true)
	assert_eq(fourthTurnPlayer, "721778859")
	assert_eq(game.currentHands["721778859"].firstCard.played, true)
	assert_eq(game.currentPlayerTurn,  "136122084")

func test_does_nothing_if_playing_player_is_not_current_turn_player():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.playFirstCard("721778859")
	assert_eq(game.currentPlayerTurn, "136122084")
	assert_eq(game.currentHands["136122084"].firstCard.played, false)

func test_current_player_plays_its_second_card():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.playSecondCard("136122084")
	assert_eq(game.currentHands["136122084"].firstCard.played, false)
	assert_eq(game.currentHands["136122084"].secondCard.played, true)
	assert_eq(game.currentHands["136122084"].thirdCard.played, false)
	assert_true(game.currentPlayerTurn == "552119499")

func test_current_player_plays_its_third_card():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	game.playThirdCard("136122084")
	assert_eq(game.currentHands["136122084"].firstCard.played, false)
	assert_eq(game.currentHands["136122084"].secondCard.played, false)
	assert_eq(game.currentHands["136122084"].thirdCard.played, true)
	assert_true(game.currentPlayerTurn == "552119499")

func test_gives_score_to_winning_team_after_every_player_has_played_a_card():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var tresDeBastos = ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.BASTOS)

	deck.setTopCards([tresDeBastos])

	var game = Game.new(players, spy, deck)

	game.newGame()

	game.playFirstCard("136122084")
	game.playFirstCard("552119499")
	game.playFirstCard("780900127")
	game.playFirstCard("721778859")

	var winner = game.calculateRoundWinner()
	assert_eq(winner, "136122084")
