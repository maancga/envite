extends Node2D

const Suits = preload("res://enums/SuitEnum.gd")
const Values = preload("res://enums/ValueEnum.gd")

var cards = []

const xOffset = 70
const yOffset = 100
const card_width = 140
const card_height = 95

func _ready():
	for suit in Suits.Suit.values():
		for value in Values.Value.values():
			var card = Card.new()
			var xAxis = (int(value) * card_height) + xOffset
			var yAxis = (int(suit) * card_width) + yOffset
			card.scale = Vector2(0.7, 0.7)
			add_child(card)
			card.call_deferred("set_card_data", value, suit, Vector2(xAxis,yAxis))
			cards.push_back(card)
