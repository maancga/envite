extends Node2D

class_name MyHand
const HandCardScene = preload("res://scenes/game/cards/HandCard.tscn")

@export var spacingCurve: Curve
@export var rotationCurve: Curve
@export var heightCurve: Curve
var cards: Array[HandCard]

func setHand(card1: CardData, card2: CardData, card3: CardData):
	cleanHand()
	var firstHandCard = HandCardScene.instantiate()
	addCard(firstHandCard)
	firstHandCard.setCardData(card1.value, card1.suit)
	firstHandCard.setHandIndex("1")
	var secondHandCard = HandCardScene.instantiate()
	addCard(secondHandCard)
	secondHandCard.setCardData(card2.value, card2.suit)
	secondHandCard.setHandIndex("2")	
	var thirdHandCard = HandCardScene.instantiate()
	addCard(thirdHandCard)
	thirdHandCard.setCardData(card3.value, card3.suit)
	thirdHandCard.setHandIndex("3")

func addCard(card: HandCard):
	cards.push_back(card)
	self.add_child(card)
	movePositions()
	
func eraseCard(card: HandCard):
	card.hideCard()
	movePositions()
	
func playFirstCard():
	print("playing first card!")
	eraseCard(cards[0])

func playSecondCard():
	print("playing second card!")
	eraseCard(cards[1])

func playThirdCard():
	print("cards:", cards)
	print("size:", cards.size())

	print("playing third card!")
	eraseCard(cards[2])

func movePositions():
	var showingCards = cards.filter(func(card): return !card.isHiden)

	for card in showingCards:
		var index = showingCards.find(card) + 1
		var elementInDistribution: float = (float(index) / (showingCards.size() + 1))
		var spacingResult = getRelativeX(elementInDistribution)
		var heightResult = getRelativeHeight(elementInDistribution)
		card.setPositionWithTransition(Vector2(spacingResult, heightResult))
		var new_rotation = getRelativeRotation(elementInDistribution)
		card.setRotation(new_rotation)
		card.setZIndex(index)

func getRelativeHeight(elementInDistribution: float):
	return heightCurve.sample_baked(elementInDistribution)

func getRelativeRotation(elementInDistribution: float):
	return rotationCurve.sample_baked(elementInDistribution)

func getRelativeX(elementInDistribution: float):
	return spacingCurve.sample_baked(elementInDistribution)

func cleanHand():
	for card in cards:
		card.queue_free()
	cards.clear()