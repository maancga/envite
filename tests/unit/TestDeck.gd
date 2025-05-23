class_name TestDeck extends Deck

var topCards : Array[ServerCard]
var _amountOfDealtCards = 0
		
func getTopCard():
	_amountOfDealtCards += 1
	if topCards.size() > 0: return topCards.pop_front()
	return cards.pop_front()

func createAndShuffle():
	for suit in Suits.Suit.values():
		for value in Values.Value.values():
			cards.push_back(ServerCard.new(value, suit))

func setTopCards(newCards: Array[ServerCard]):
	topCards = newCards

func amountOfDealtCards():
	return _amountOfDealtCards
