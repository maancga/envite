extends "res://addons/gut/test.gd"

class TestRoundManager: extends GutTest

func test_creates_a_new_round():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")

	var spy = TestPlayerInteractor.new()
	var deck = NormalDeck.new()
	var dealer = CardDealer.new(spy, players, deck)
	var scoresManager = ScoresManager.new(spy, players)
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
	var scoresManager = ScoresManager.new(spy, players)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	roundManager.playFirstCard("136122084")
	roundManager.playFirstCard("552119499")
	roundManager.playFirstCard("780900127")
	roundManager.playFirstCard("721778859")

	assert_eq(spy.informPlayerPlayedCardCalledTimes(4), true)

func getFixedTopCards() -> Array[ServerCard]:
	return [
	ServerCard.new(ValueEnum.Value.AS, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.OROS),

	ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.ESPADAS),
	ServerCard.new(ValueEnum.Value._4, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.OROS),

	ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._4, SuitEnum.Suit.OROS),

	ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.OROS),
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.OROS),
	ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.BASTOS),

	ServerCard.new(ValueEnum.Value.AS, SuitEnum.Suit.ESPADAS),
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.ESPADAS),
	ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.ESPADAS),

	ServerCard.new(ValueEnum.Value._4, SuitEnum.Suit.ESPADAS),
	ServerCard.new(ValueEnum.Value._5, SuitEnum.Suit.ESPADAS),
	ServerCard.new(ValueEnum.Value._6, SuitEnum.Suit.ESPADAS),

	ServerCard.new(ValueEnum.Value._7, SuitEnum.Suit.COPAS),
	]

func test_checks_that_arrastre_is_created():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Javi")
	players.addPlayer("409921023", "Billy")
	players.addPlayer("680459309", "Alexander")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	deck.setTopCards(getFixedTopCards())
	var dealer = CardDealer.new(spy, players, deck)
	var scoresManager = ScoresManager.new(spy, players)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	roundManager.playSecondCard("136122084")
	assert_eq(spy.playerIsArrastrandoCalls, 1)

func test_checks_player_does_not_follow_arrastre():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Javi")
	players.addPlayer("409921023", "Billy")
	players.addPlayer("680459309", "Alexander")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	deck.setTopCards(getFixedTopCards())
	var dealer = CardDealer.new(spy, players, deck)
	var scoresManager = ScoresManager.new(spy, players)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	roundManager.playSecondCard("136122084")
	roundManager.playFirstCard("552119499")

	assert_eq(spy.couldNotPlayCardBecauseNotSirviendoAlArrastreCalled, 1)

func test_checks_that_player_can_play_after_missing_the_arrastre():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Javi")
	players.addPlayer("409921023", "Billy")
	players.addPlayer("680459309", "Alexander")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	deck.setTopCards(getFixedTopCards())
	var dealer = CardDealer.new(spy, players, deck)
	var scoresManager = ScoresManager.new(spy, players)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	roundManager.playSecondCard("136122084")
	assert_eq(spy.countInformPlayerTurnCalls, 2)
	roundManager.playFirstCard("552119499")
	assert_eq(spy.countInformPlayerTurnCalls, 2)
	roundManager.playSecondCard("552119499")
	assert_eq(spy.countInformPlayerTurnCalls, 3)

func test_player_3_can_ignore_arrastre_since_has_the_biggest_triumph():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Javi")
	players.addPlayer("409921023", "Billy")
	players.addPlayer("680459309", "Alexander")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	deck.setTopCards(getFixedTopCards())
	var dealer = CardDealer.new(spy, players, deck)
	var scoresManager = ScoresManager.new(spy, players)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	roundManager.playSecondCard("136122084")
	roundManager.playSecondCard("552119499")
	roundManager.playFirstCard("780900127")
	assert_eq(spy.couldNotPlayCardBecauseNotSirviendoAlArrastreCalled, 0)

func test_player_3_can_play_the_biggest_triumph():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Javi")
	players.addPlayer("409921023", "Billy")
	players.addPlayer("680459309", "Alexander")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	deck.setTopCards(getFixedTopCards())
	var dealer = CardDealer.new(spy, players, deck)
	var scoresManager = ScoresManager.new(spy, players)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	roundManager.playSecondCard("136122084")
	roundManager.playSecondCard("552119499")
	roundManager.playSecondCard("780900127")
	assert_eq(spy.couldNotPlayCardBecauseNotSirviendoAlArrastreCalled, 0)

func test_fails_el_arrastre_if_has_triumph_and_tries_to_play_other_thing():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Javi")
	players.addPlayer("409921023", "Billy")
	players.addPlayer("680459309", "Alexander")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	deck.setTopCards(getFixedTopCards())
	var dealer = CardDealer.new(spy, players, deck)
	var scoresManager = ScoresManager.new(spy, players)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	roundManager.playSecondCard("136122084")
	roundManager.playSecondCard("552119499")
	roundManager.playFirstCard("780900127")
	roundManager.playSecondCard("409921023")
	assert_eq(spy.couldNotPlayCardBecauseNotSirviendoAlArrastreCalled, 1)

func test_since_there_is_no_card_that_can_servir_al_arrastre_can_play_any_card_case_1():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Javi")
	players.addPlayer("409921023", "Billy")
	players.addPlayer("680459309", "Alexander")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	deck.setTopCards(getFixedTopCards())
	var dealer = CardDealer.new(spy, players, deck)
	var scoresManager = ScoresManager.new(spy, players)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	roundManager.playSecondCard("136122084")
	roundManager.playSecondCard("552119499")
	roundManager.playFirstCard("780900127")
	roundManager.playFirstCard("409921023")
	roundManager.playFirstCard("680459309")
	assert_eq(spy.couldNotPlayCardBecauseNotSirviendoAlArrastreCalled, 0)

func test_since_there_is_no_card_that_can_servir_al_arrastre_can_play_any_card_case_2():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Javi")
	players.addPlayer("409921023", "Billy")
	players.addPlayer("680459309", "Alexander")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	deck.setTopCards(getFixedTopCards())
	var dealer = CardDealer.new(spy, players, deck)
	var scoresManager = ScoresManager.new(spy, players)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	roundManager.playSecondCard("136122084")
	roundManager.playSecondCard("552119499")
	roundManager.playFirstCard("780900127")
	roundManager.playFirstCard("409921023")
	roundManager.playSecondCard("680459309")
	assert_eq(spy.couldNotPlayCardBecauseNotSirviendoAlArrastreCalled, 0)

func test_since_there_is_no_card_that_can_servir_al_arrastre_can_play_any_card_case_3():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Javi")
	players.addPlayer("409921023", "Billy")
	players.addPlayer("680459309", "Alexander")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	deck.setTopCards(getFixedTopCards())
	var dealer = CardDealer.new(spy, players, deck)
	var scoresManager = ScoresManager.new(spy, players)
	var roundManager = RoundManager.new(dealer, players, spy, scoresManager, SixPlayersTriumphHierarchy.new())
	roundManager.deal("721778859")

	roundManager.playSecondCard("136122084")
	roundManager.playSecondCard("552119499")
	roundManager.playFirstCard("780900127")
	roundManager.playFirstCard("409921023")
	roundManager.playThirdCard("680459309")
	assert_eq(spy.couldNotPlayCardBecauseNotSirviendoAlArrastreCalled, 0)
