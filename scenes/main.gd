extends Node2D

@onready var hand = $MyHand
@onready var label = $Label

var selectedCard: Card = null

func _ready() -> void:
	hand.card1.clickedCard.connect(_on_card_clicked)
	hand.card2.clickedCard.connect(_on_card_clicked)
	hand.card3.clickedCard.connect(_on_card_clicked)


func _on_card_clicked(clickedCard: Card):
	selectedCard = clickedCard
	label.text =  "Carta seleccionada: %s" % [selectedCard.getCardName() ]


func _on_play_card_button_pressed() -> void:
	if !selectedCard: return
	print("played card! " + selectedCard.getCardName())
	selectedCard = null
