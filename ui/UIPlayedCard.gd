extends Node2D

class_name UIPlayedCard
@onready var card: Card = $Card
@onready var playerNameLabel: Label = $PlayerNameLabel

var cardYPosition = 200
var playerNameYPosition = 50

func setCardData(newValue, givenSuit):
	card.setCardData(newValue, givenSuit)
	card.update_texture()

func setPlayerName(playerName: String):
	playerNameLabel.text = playerName
	playerNameLabel.show()

func setXPosition(xPosition: float):
	card.setPosition(Vector2(xPosition, cardYPosition))
	playerNameLabel.position = Vector2(xPosition, playerNameYPosition)
