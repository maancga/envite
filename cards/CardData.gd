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
