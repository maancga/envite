extends "res://addons/gut/test.gd"

class TestRoundManager: extends GutTest

func test_creates_a_new_round():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")

	var spy = TestPlayerInteractor.new()
	var deck = NormalDeck.new()
	var dealer = CardDealer.new(spy, players, deck)
	var game = Game.new(players, spy, deck, SixPlayersTriumphHierarchy.new())
	var scoresManager = ScoresManager.new(spy, players, game)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	assert_eq(spy.getLastInformPlayerTurnCall(), "721778859")

func test_every_player_plays_cards():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Javi")

	var spy = TestPlayerInteractor.new()
	var deck = NormalDeck.new()
	var dealer = CardDealer.new(spy, players, deck)
	var game = Game.new(players, spy, deck, SixPlayersTriumphHierarchy.new())
	var scoresManager = ScoresManager.new(spy, players, game)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	roundManager.playFirstCard("136122084")
	roundManager.playFirstCard("552119499")
	roundManager.playFirstCard("780900127")
	roundManager.playFirstCard("721778859")

	assert_eq(spy.informPlayerPlayedCardCalledTimes(4), true)
