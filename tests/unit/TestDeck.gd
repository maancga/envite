class_name TestDeck extends Deck

var topCards : Array[ServerCard]
		
func getTopCard():
	if topCards.size() > 0: topCards.pop_front()
	return cards.pop_front()

func createAndShuffle():
	for suit in Suits.Suit.values():
		for value in Values.Value.values():
			cards.push_back(ServerCard.new(value, suit))
	# NoShuffle

func setTopCards(newCards: Array[ServerCard]):
	topCards = newCards
