extends Node2D

@onready var hand = $MyHand
@onready var selectedCardLabel = $"Carta seleccionada"
@onready var cardShuffler=$CardShuffler
@onready var lastCard= $LastCard
@onready var viradoLabel = $Virado
@onready var playerName = $PlayerName
var selectedCard: Card = null
signal playedCard(card)

func _ready() -> void:
	connectClickedCards()

func connectClickedCards() -> void:
	hand.card1.clickedCard.connect(_on_card_clicked)
	hand.card2.clickedCard.connect(_on_card_clicked)
	hand.card3.clickedCard.connect(_on_card_clicked)
	
func setUpScene(newPlayerName: String, card1: CardData, card2: CardData, card3: CardData, viradoCard: CardData ):
	hand.setInitialCards(card1, card2, card3)
	connectClickedCards()
	playerName.text = newPlayerName
	var cardPreload = preload("res://cards/Card.tscn")
	var newLastCard = cardPreload.instantiate()

	var viradoCardPosition = lastCard.position
	var viradoCardRotation = lastCard.rotation
	
	if lastCard: lastCard.queue_free()

	add_child(newLastCard)
	move_child(newLastCard, 1)
	
	newLastCard.set_card_data(viradoCard.value,viradoCard.suit, viradoCardPosition)
	newLastCard.rotation = viradoCardRotation
	lastCard = newLastCard
	viradoLabel.text =  "Virado: %s" % [lastCard.getSuitName() ]


func _on_card_clicked(clickedCard: Card):
	selectedCard = clickedCard
	selectedCardLabel.text =  "Carta seleccionada: %s" % [selectedCard.getCardName() ]


func _on_play_card_button_pressed() -> void:
	if !selectedCard: return
	print("played card! " + selectedCard.getCardName())
	var cardData = CardData.new(selectedCard.value, selectedCard.suit)
	print(cardData.to_dict())
	playedCard.emit(cardData.to_dict())
	hand.playCard(selectedCard)
	selectedCard = null
	
