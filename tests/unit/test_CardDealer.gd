extends "res://addons/gut/test.gd"

class TestCardDealer: extends GutTest

func test_deals_hand_to_a_player():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var firstCard = ServerCard.new(ValueEnum.Value.AS, SuitEnum.Suit.BASTOS)
	var secondCard = ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS)
	var thirdCard = ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.OROS)
	var fourthCard = ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.ESPADAS)
	deck.setTopCards([firstCard, secondCard, thirdCard, fourthCard])

	var dealer = CardDealer.new(spy, players, deck)

	var hands = dealer.dealHands("721778859")
	var virado = dealer.dealVirado()

	assert_true(hands.amountOfHands() == 1)
	assert_true(hands.hasCard("721778859", ValueEnum.Value.AS , SuitEnum.Suit.BASTOS,))
	assert_true(hands.hasCard("721778859", ValueEnum.Value._2, SuitEnum.Suit.COPAS, ))
	assert_true(hands.hasCard("721778859",  ValueEnum.Value.CABALLO, SuitEnum.Suit.OROS))
	assert_true(virado.isSuit(SuitEnum.Suit.ESPADAS))
	assert_true(virado.isValue(ValueEnum.Value.SOTA))
	assert_true(spy.dealHandToPlayersBeenCalled(1))
	assert_true(spy.informViradoToPlayerBeenCalled(1))
	assert_true(spy.informDealerBeenCalled(1))
	assert_true(deck.amountOfDealtCards() == 4)

func test_deals_hands_to_two_players():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("271878859", "Alexis")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var firstCard = ServerCard.new(ValueEnum.Value.AS, SuitEnum.Suit.BASTOS)
	var secondCard = ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS)
	var thirdCard = ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.OROS)
	var fourthCard = ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.ESPADAS)
	var fifthCard = ServerCard.new(ValueEnum.Value._4, SuitEnum.Suit.COPAS)
	var sixthCard = ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.OROS)
	var seventhCard = ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.BASTOS)
	deck.setTopCards([firstCard, secondCard, thirdCard, fourthCard, fifthCard, sixthCard, seventhCard])

	var dealer = CardDealer.new(spy, players, deck)

	var hands = dealer.dealHands("721778859")
	var virado = dealer.dealVirado()

	assert_true(hands.amountOfHands() == 2)
	assert_true(hands.hasCard("271878859", ValueEnum.Value.AS , SuitEnum.Suit.BASTOS,))
	assert_true(hands.hasCard("271878859", ValueEnum.Value._2, SuitEnum.Suit.COPAS, ))
	assert_true(hands.hasCard("271878859",  ValueEnum.Value.CABALLO, SuitEnum.Suit.OROS))
	assert_true(hands.hasCard("721778859", ValueEnum.Value.SOTA , SuitEnum.Suit.ESPADAS,))
	assert_true(hands.hasCard("721778859", ValueEnum.Value._4, SuitEnum.Suit.COPAS, ))
	assert_true(hands.hasCard("721778859",  ValueEnum.Value.REY, SuitEnum.Suit.OROS))
	assert_true(virado.isSuit(SuitEnum.Suit.BASTOS))
	assert_true(virado.isValue(ValueEnum.Value.SOTA))
	assert_true(spy.dealHandToPlayersBeenCalled(2))
	assert_true(spy.informViradoToPlayerBeenCalled((1)))
	assert_true(deck.amountOfDealtCards() == 7)
