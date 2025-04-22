extends Node2D

class_name UnknownHand 

@onready var card1 = $Card1
@onready var card2 = $Card2
@onready var card3 = $Card3
var UNKNWON_CARD_TEXTURE = load("res://cards/images/carta_desconocida_1.png")

@export var spacingCurve: Curve
@export var rotationCurve: Curve
@export var heightCurve: Curve

func _ready() -> void:
	movePositions()

func movePositions():
	var cards = [card1, card2, card3]
	var showingCards = cards.filter(func(card): return card.get_node("CardImage").texture != null)
	for card in showingCards:
		var index = showingCards.find(card) + 1
		var elementInDistribution: float = (float(index) / (showingCards.size() + 1))
		var spacingResult = getRelativeX(elementInDistribution)
		var heightResult = getRelativeHeight(elementInDistribution)
		card.position = Vector2(spacingResult, heightResult)
		var new_rotation = getRelativeRotation(elementInDistribution)
		card.rotation_degrees = new_rotation

func getRelativeHeight(elementInDistribution: float):
	return heightCurve.sample_baked(elementInDistribution)

func getRelativeRotation(elementInDistribution: float):
	return rotationCurve.sample_baked(elementInDistribution)

func getRelativeX(elementInDistribution: float):
	return spacingCurve.sample_baked(elementInDistribution)


func playFirstCard():
	card1.get_node("CardImage").texture = null
	movePositions()
	
func playSecondCard():
	card2.get_node("CardImage").texture = null
	movePositions()
	
func playThirdCard():
	card3.get_node("CardImage").texture = null
	movePositions()

func resetCardTextures():
	card1.get_node("CardImage").texture = UNKNWON_CARD_TEXTURE
	card2.get_node("CardImage").texture = UNKNWON_CARD_TEXTURE
	card3.get_node("CardImage").texture = UNKNWON_CARD_TEXTURE
	movePositions()
