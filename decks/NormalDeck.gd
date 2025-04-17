class_name NormalDeck extends Deck

func createAndShuffle():
	for suit in Suits.Suit.values():
		for value in Values.Value.values():
			cards.push_back(ServerCard.new(value, suit))
	shuffle()

	
func shuffle():
	var n = cards.size()
	for i in range(n - 1, 0, -1):
		var j = randi() % (i + 1)
		var temp = cards[i]
		cards[i] = cards[j]
		cards[j] = temp
		
func getTopCard():
	return cards.pop_front()

func getAHand():
	var hand = ServerHand.new(ServerHandCard.new(cards.pop_front(), 1), ServerHandCard.new(cards.pop_front(), 2), ServerHandCard.new(cards.pop_front(), 3))
	return hand
