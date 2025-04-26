extends Node2D

class_name NewMyHand

@export var spacingCurve: Curve
@export var rotationCurve: Curve
@export var heightCurve: Curve
var cards: Array[HandCard]

func addCard(card: HandCard):
	cards.push_front(card)
	self.add_child(card)
	movePositions()
	
func eraseCard(card: HandCard):
	cards.erase(card)
	self.remove_child(card)
	movePositions()
	
func movePositions():
	var showingCards = cards.filter(func(card): return card.cardImage.texture != null)

	for card in showingCards:
		var index = showingCards.find(card) + 1
		var elementInDistribution: float = (float(index) / (showingCards.size() + 1))
		var spacingResult = getRelativeX(elementInDistribution)
		var heightResult = getRelativeHeight(elementInDistribution)
		card.setPosition(Vector2(spacingResult, heightResult))
		var new_rotation = getRelativeRotation(elementInDistribution)
		card.setRotation(new_rotation)
		card.setZIndex(index)

func getRelativeHeight(elementInDistribution: float):
	return heightCurve.sample_baked(elementInDistribution)

func getRelativeRotation(elementInDistribution: float):
	return rotationCurve.sample_baked(elementInDistribution)

func getRelativeX(elementInDistribution: float):
	return spacingCurve.sample_baked(elementInDistribution)
