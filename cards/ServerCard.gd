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

func isSuit(comparingSuit: SuitEnum.Suit):
	return comparingSuit == suit