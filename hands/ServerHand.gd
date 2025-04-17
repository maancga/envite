class_name ServerHand

var firstCard: ServerCard
var secondCard: ServerCard
var thirdCard: ServerCard

func _init(
	newFirstCard: ServerCard,
	newSecondCard: ServerCard,
	newThirdCard: ServerCard):
	firstCard = newFirstCard
	secondCard = newSecondCard
	thirdCard = newThirdCard

func to_dict() -> Dictionary:
	return {
		"firstCard": firstCard.to_dict(),
		"secondCard": secondCard.to_dict(),
		"thirdCard": thirdCard.to_dict()
	}

func hasCard(value: ValueEnum.Value, suit: SuitEnum.Suit,) -> bool:
	var comparingCard = ServerCard.new(value, suit)
	if firstCard.equals(comparingCard):
		return true
	if secondCard.equals(comparingCard):
		return true
	if thirdCard.equals(comparingCard):
		return true
	return false

func getFirstCard() -> ServerCard:
	return firstCard

func getSecondCard() -> ServerCard:
	return secondCard

func getThirdCard() -> ServerCard:
	return thirdCard
