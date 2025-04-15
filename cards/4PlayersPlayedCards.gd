extends Node2D

@onready var firstCard = $firstCard
@onready var secondCard = $secondCard
@onready var thirdCard =  $thirdCard
@onready var fourthCard = $fourthCard

func _ready() -> void:
	firstCard.card_image.texture = null
	secondCard.card_image.texture = null
	thirdCard.card_image.texture = null
	fourthCard.card_image.texture = null
