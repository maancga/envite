extends Node2D

const Suits = preload("res://enums/SuitEnum.gd")
const Values = preload("res://enums/ValueEnum.gd")

var cards = []

func _ready():
	for suit in Suits.Suit.values():
		for value in Values.Value.values():
			cards.push_back(CardData.new(value, suit))
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
