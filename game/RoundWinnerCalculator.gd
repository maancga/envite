class_name RoundWinnerCalculator

var viradoCard: ServerCard
var firstPlayedCard: ServerCard

var triumphHierarchy: TriumphHierarchy

var viradoValuesHierarchy := [
	ValueEnum.Value._2,
	ValueEnum.Value.REY,
	ValueEnum.Value.CABALLO, 
	ValueEnum.Value.SOTA, 
	ValueEnum.Value.AS, 
	ValueEnum.Value._7,
	ValueEnum.Value._6, 
	ValueEnum.Value._5,
	ValueEnum.Value._4, 
	ValueEnum.Value._3
	]

var firstCardValuesHierarchy := [
	ValueEnum.Value.REY,
	ValueEnum.Value.CABALLO, 
	ValueEnum.Value.SOTA, 
	ValueEnum.Value.AS, 
	ValueEnum.Value._7,
	ValueEnum.Value._6, 
	ValueEnum.Value._5,
	ValueEnum.Value._4, 
	ValueEnum.Value._3, 
	ValueEnum.Value._2
	]

func _init(_viradoCard: ServerCard, _firstPlayedCard: ServerHandCard, _triumphHierarchy: TriumphHierarchy):
	viradoCard =_viradoCard
	firstPlayedCard = _firstPlayedCard.card
	triumphHierarchy = _triumphHierarchy

func isTriumph(card: ServerCard) -> bool:
	return triumphHierarchy.isTriumph(card)

func isBiggerTriumph(firstCard: ServerCard, secondCard: ServerCard) -> bool:
	return triumphHierarchy.isBiggerTriumph(firstCard, secondCard)

func isBiggerVirado(firstCard: ServerCard, secondCard: ServerCard):
	return viradoValuesHierarchy.find(firstCard.value) < viradoValuesHierarchy.find(secondCard.value)

func isBiggerFirstCardSuit(firstCard: ServerCard, secondCard: ServerCard):
	return firstCardValuesHierarchy.find(firstCard.value) < firstCardValuesHierarchy.find(secondCard.value)

func isBiggerCardNoSuit(firstCard: ServerCard, secondCard: ServerCard):
	return firstCardValuesHierarchy.find(firstCard.value) < firstCardValuesHierarchy.find(secondCard.value)

func isBetterThan(firstCard: ServerCard, secondCard: ServerCard) -> bool:
	var bothAreTriumphs = isTriumph(firstCard) && isTriumph(secondCard)
	if(bothAreTriumphs): return isBiggerTriumph(firstCard, secondCard)

	if(isTriumph(firstCard) and not isTriumph(secondCard)): return true
	if(not isTriumph(firstCard) and isTriumph(secondCard)): return false

	var viradoSuit = viradoCard.suit
	var bothAreViradoSuit = firstCard.isSuit(viradoSuit) and secondCard.isSuit(viradoSuit)
	if bothAreViradoSuit: return isBiggerVirado(firstCard, secondCard)

	if firstCard.isSuit(viradoSuit) and not secondCard.isSuit(viradoSuit):
		return true
	if secondCard.isSuit(viradoSuit) and not firstCard.isSuit(viradoSuit):
		return false
	
	var firstPlayedCardSuit = firstPlayedCard.suit
	var bothAreFirstCardSuit = firstCard.isSuit(firstPlayedCardSuit) and secondCard.isSuit(firstPlayedCardSuit)

	if bothAreFirstCardSuit: return isBiggerFirstCardSuit(firstCard, secondCard)

	if firstCard.isSuit(firstPlayedCardSuit) and not secondCard.isSuit(firstPlayedCardSuit):
		return true
	if not firstCard.isSuit(firstPlayedCardSuit) and secondCard.isSuit(firstPlayedCardSuit):
		return false

	return isBiggerCardNoSuit(firstCard, secondCard)

func calculateWinner(cards: Dictionary[String, ServerHandCard]) -> String:
	var playerIds = cards.keys()
	var winnerId = playerIds[0]
	var winnerCard: ServerCard = cards[winnerId].card

	for playerId in cards:
		var currentComparingCard: ServerCard = cards[playerId].card

		if winnerCard == null or isBetterThan(currentComparingCard, winnerCard,):
			winnerId = playerId
			winnerCard = currentComparingCard

	return winnerId
