extends Node2D

@onready var hand = $MyHand
@onready var selectedCardLabel = $"Carta seleccionada"
@onready var cardShuffler=$CardShuffler
@onready var lastCard= $LastCard
@onready var viradoLabel = $Virado
@onready var playerName = $PlayerName
@onready var turnLabel = $TurnLabel
var playerId : String
var currentPlayerTurnId: String

var selectedCard: Card = null
signal playedCard(card)

func _ready() -> void:
	connectClickedCards()

func connectClickedCards() -> void:
	hand.card1.clickedCard.connect(onCardClicked)
	hand.card2.clickedCard.connect(onCardClicked)
	hand.card3.clickedCard.connect(onCardClicked)
	
func setUpScene(newPlayerName: String, card1: CardData, card2: CardData, card3: CardData, viradoCard: CardData, newPlayerId: String ):
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
	playerId = newPlayerId


func onCardClicked(clickedCard: Card):
	selectedCard = clickedCard
	selectedCardLabel.text =  "Carta seleccionada: %s" % [selectedCard.getCardName() ]

func playCard():
	if selectedCard == hand.card1: playedCard.emit("1")
	if selectedCard == hand.card2: playedCard.emit("2")
	if selectedCard == hand.card3: playedCard.emit("3")


func onPlayCardButtonPressed() -> void:
	if !selectedCard: return
	if not isYourTurn(): return 
	print("played card! " + selectedCard.getCardName())
	playCard()
	hand.playCard(selectedCard)
	selectedCard = null

func isYourTurn():
	return currentPlayerTurnId == playerId
	
func setPlayerTurn(newPlayerId: String):
	print("currentPlayerTurn: ", newPlayerId)
	print("player Id", playerId)
	currentPlayerTurnId = newPlayerId
	if(isYourTurn()): turnLabel.text = "Es tu turno!" 
	else: turnLabel.text = "No es tu turno =(" 
