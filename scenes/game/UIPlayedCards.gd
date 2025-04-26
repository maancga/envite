extends Node2D

class_name UIPlayedCards

@export var spacingCurve: Curve
var cards = []
var amountOfPlayers: int = 0
var cardOverDropArea = false
var overAreaReference
var cardOver = null

func setAmountOfPlayers(_amountOfPlayers: int):
	amountOfPlayers = _amountOfPlayers

func addCard(namePlayer: String, newValue: ValueEnum.Value, givenSuit: SuitEnum.Suit):
	var card = preload("res://scenes/game/UIPlayedCard.tscn").instantiate()
	add_child(card)
	card.setCardData(newValue, givenSuit)
	cards.append(card)
	var index = cards.find(card) + 1
	var elementInDistribution: float = (float(index) / (amountOfPlayers + 1))
	var spacingResult = spacingCurve.sample(elementInDistribution)
	card.setXPosition(spacingResult)
	card.setPlayerName(namePlayer)

func cleanPlayedCards():
	for card in cards:
		card.queue_free()
	cards.clear()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if $Area2D.get_overlapping_areas().has(area):
		var parent = area.get_parent()
		if (parent is Card):
			cardOverDropArea = true
			overAreaReference = area
			cardOver = parent
			cardOver.cardIsOverDropArea()



func _on_area_2d_area_exited(area: Area2D) -> void:
	if(overAreaReference == area):
		overAreaReference = null
		cardOverDropArea = false
		cardOver.cardNotOverDropArea()
		cardOver = null
