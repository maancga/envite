extends Node2D

class_name UIPlayedCards

@export var spacingCurve: Curve
var cards = []
var amountOfPlayers: int = 0

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
