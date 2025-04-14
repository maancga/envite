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
	assert_true(spy.informViradoToPlayerBeenCalled((4)))


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
		"721778859",
		"136122084",
		"552119499",
		"780900127"
	])))
	assert_true(spy.calledPlayerIdsForVirado(([
		"721778859",
		"136122084",
		"552119499",
		"780900127"
	])))

	
func test_assigns_player_turn_to_first_player_on_new_game():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	assert_true(game.currentPlayerTurn == "721778859")

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

	game.playFirstCard("721778859")
	assert_eq(game.currentHands["721778859"].firstCard.played, true)
	assert_eq(game.currentHands["721778859"].secondCard.played, false)
	assert_eq(game.currentHands["721778859"].thirdCard.played, false)
	assert_true(game.currentPlayerTurn == "136122084")

func test_all_players_play_a_turn_so_its_first_player_turn_again():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	game.newGame()

	var firstTurnPlayer = game.currentPlayerTurn
	game.playFirstCard("721778859")
	var secondTurnPlayer = game.currentPlayerTurn
	game.playFirstCard("136122084")
	var thirdTurnPlayer = game.currentPlayerTurn
	game.playFirstCard("552119499")
	var fourthTurnPlayer = game.currentPlayerTurn
	game.playFirstCard("780900127")

	assert_eq(firstTurnPlayer, "721778859")
	assert_eq(game.currentHands["721778859"].firstCard.played, true)
	assert_eq(secondTurnPlayer, "136122084")
	assert_eq(game.currentHands["136122084"].firstCard.played, true)
	assert_eq(thirdTurnPlayer, "552119499")
	assert_eq(game.currentHands["552119499"].firstCard.played, true)
	assert_eq(fourthTurnPlayer, "780900127")
	assert_eq(game.currentHands["780900127"].firstCard.played, true)
	assert_eq(game.currentPlayerTurn,  "721778859")

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

	game.playFirstCard("136122084")
	assert_eq(game.currentPlayerTurn, "721778859")
	assert_eq(game.currentHands["721778859"].firstCard.played, false)

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

	game.playSecondCard("721778859")
	assert_eq(game.currentHands["721778859"].firstCard.played, false)
	assert_eq(game.currentHands["721778859"].secondCard.played, true)
	assert_eq(game.currentHands["721778859"].thirdCard.played, false)
	assert_true(game.currentPlayerTurn == "136122084")

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

	game.playThirdCard("721778859")
	assert_eq(game.currentHands["721778859"].firstCard.played, false)
	assert_eq(game.currentHands["721778859"].secondCard.played, false)
	assert_eq(game.currentHands["721778859"].thirdCard.played, true)
	assert_true(game.currentPlayerTurn == "136122084")

func test_gives_score_to_winning_team_after_every_player_has_played_a_card():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck)

	var tresDeBastos = ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.BASTOS)
	var onceDeBastos = ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.BASTOS)
	var diezDeOros = ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.OROS)
	var dosDeCopas = ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS)
	deck.setTopCards([tresDeBastos, onceDeBastos, diezDeOros, dosDeCopas])
	game.newGame()

	game.playFirstCard("721778859")
	game.playFirstCard("136122084")
	game.playFirstCard("552119499")
	game.playFirstCard("780900127")

	var winner = game.calculateRoundWinner()
	assert_eq(winner, "721778859")
