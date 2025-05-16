class_name TriumphHierarchy

func getTriumphHierarchy():
	return []

func isTriumph(card: ServerCard) -> bool:
	for triumph in getTriumphHierarchy():
		if card.value == triumph.value and card.suit == triumph.suit:
			return true
	return false

func isBiggerTriumph(firstCard: ServerCard, secondCard: ServerCard) -> bool:
	for triumph in getTriumphHierarchy():
		if firstCard.value == triumph.value and firstCard.suit == triumph.suit:
			return true
		if secondCard.value == triumph.value and secondCard.suit == triumph.suit:
			return false
	return false

func getBiggestTriumph():
	if getTriumphHierarchy().size() == 0: return false
	return getTriumphHierarchy()[0]

func isBiggestTriumph(card: ServerCard):
	var biggestTriumph = getBiggestTriumph() 
	if not biggestTriumph : return false
	return biggestTriumph.value == card.value and biggestTriumph.suit == card.suit
