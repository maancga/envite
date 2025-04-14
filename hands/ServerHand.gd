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

func playFirstCard():
	firstCard.play()

func playSecondCard():
	secondCard.play()

func playThirdCard():
	thirdCard.play()

func to_dict() -> Dictionary:
	return {
		"firstCard": firstCard.to_dict(),
		"secondCard": secondCard.to_dict(),
		"thirdCard": thirdCard.to_dict()
	}
