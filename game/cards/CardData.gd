class_name CardData

var value: ValueEnum.Value
var suit: SuitEnum.Suit

func _init(newValue, newSuit):
	value = newValue
	suit = newSuit
	
func to_dict():
	return {
		"value": value,
		"suit": suit
	}

func getCardName():
	return  ValueEnum.VALUES_TRANSLATIONS[value] + " de " + getSuitName()
	
func getSuitName():
	return str(SuitEnum.SUIT_NAMES[suit])
