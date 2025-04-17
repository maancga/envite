class_name ServerCard

var value: ValueEnum.Value
var suit: SuitEnum.Suit
var played: bool

func _init(newValue, newSuit):
	value = newValue
	suit = newSuit
	played = false

func play():
	played = true

func equals(card: ServerCard) -> bool:
	return isValue(card.value) and isSuit(card.suit)

func isSuit(comparingSuit: SuitEnum.Suit):
	return comparingSuit == suit

func isValue(comparingValue: ValueEnum.Value):
	return comparingValue == value

func getCardName():
	return  ValueEnum.VALUES_TRANSLATIONS[value] + " de " + getSuitName()
	
func getSuitName():
	return str(SuitEnum.SUIT_NAMES[suit])
	
func to_dict() -> Dictionary:
	return {
		"value": value,
		"suit": suit
	}
	
