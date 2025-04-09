extends Node2D

@onready var hand = $MyHand
@onready var selectedCardLabel = $"Carta seleccionada"
@onready var cardShuffler=$CardShuffler
@onready var lastCard= $LastCard
@onready var viradoLabel = $Virado
var selectedCard: Card = null

func _ready() -> void:
	setup_cards()
	hand.card1.clickedCard.connect(_on_card_clicked)
	hand.card2.clickedCard.connect(_on_card_clicked)
	hand.card3.clickedCard.connect(_on_card_clicked)
	
func setup_cards():
	hand.setInitialCards(cardShuffler.getTopCard(), cardShuffler.getTopCard(), cardShuffler.getTopCard())
	var lastCardData = cardShuffler.getTopCard()
	var cardPreload = preload("res://scenes/player-cards/Card.tscn")
	var newLastCard = cardPreload.instantiate()

	var card1Position = lastCard.position
	var card1Rotation = lastCard.rotation
	
	if lastCard: lastCard.queue_free()

	# Add new cards to the scene
	add_child(newLastCard)
	move_child(newLastCard, 1)
	
	newLastCard.set_card_data(lastCardData.value,lastCardData.suit, card1Position)
	newLastCard.rotation = card1Rotation
	lastCard = newLastCard
	viradoLabel.text =  "Virado: %s" % [lastCard.getSuitName() ]


func _on_card_clicked(clickedCard: Card):
	selectedCard = clickedCard
	selectedCardLabel.text =  "Carta seleccionada: %s" % [selectedCard.getCardName() ]


func _on_play_card_button_pressed() -> void:
	if !selectedCard: return
	print("played card! " + selectedCard.getCardName())
	selectedCard = null
