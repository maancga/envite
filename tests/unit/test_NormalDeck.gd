extends "res://addons/gut/test.gd"

func test_creates_and_shuffle_40_cards():
  var deck = NormalDeck.new()

  deck.createAndShuffle()

  assert_eq(deck.cards.size(), 40)

func test_after_dealing_a_hand_there_are_37_cards_remaining():
  var deck = NormalDeck.new()

  deck.createAndShuffle()
  deck.getAHand()

  assert_eq(deck.cards.size(), 37)

func test_after_dealing_a_hand_and_the_virado_there_are_36_cards_remaining():
  var deck = NormalDeck.new()

  deck.createAndShuffle()
  deck.getAHand()
  deck.getTopCard()

  assert_eq(deck.cards.size(), 36)

func test_after_the_second_shuffle_there_are_40_cards_again():
  var deck = NormalDeck.new()

  deck.createAndShuffle()
  deck.getAHand()
  deck.getTopCard()
  deck.createAndShuffle()

  assert_eq(deck.cards.size(), 40)