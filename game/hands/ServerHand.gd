class_name ServerHand

var firstCard: ServerHandCard
var secondCard: ServerHandCard
var thirdCard: ServerHandCard

func _init(
	newFirstCard: ServerHandCard,
	newSecondCard: ServerHandCard,
	newThirdCard: ServerHandCard):
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
	var comparingCard = ServerHandCard.new(ServerCard.new(value, suit), 0)
	if firstCard.equals(comparingCard):
		return true
	if secondCard.equals(comparingCard):
		return true
	if thirdCard.equals(comparingCard):
		return true
	return false

func getFirstCard() -> ServerHandCard:
	return firstCard

func getSecondCard() -> ServerHandCard:
	return secondCard

func getThirdCard() -> ServerHandCard:
	return thirdCard

func getCardsArray() -> Array[ServerHandCard]:
	return [firstCard, secondCard, thirdCard]