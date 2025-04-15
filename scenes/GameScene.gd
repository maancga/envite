extends Node2D

@onready var hand = $MyHand
@onready var selectedCardLabel = $"Carta seleccionada"
@onready var cardShuffler=$CardShuffler
@onready var lastCard= $Virado/Card
@onready var viradoLabel = $Virado/ViradoLabel
@onready var playerName = $PlayerName
@onready var turnLabel = $TurnLabel
@onready var playedCards = $"4PlayersPlayedCards"

var playerId : String
var currentPlayerTurnId: String

var selectedCard: Card = null
signal playedCard(card)

func _ready() -> void:
	connectClickedCards()
	cleanCards()

func cleanCards():
	playedCards.get_node("firstCard/PlayerNameLabel").text = ""
	playedCards.get_node("secondCard/PlayerNameLabel").text = ""
	playedCards.get_node("thirdCard/PlayerNameLabel").text = ""
	playedCards.get_node("fourthCard/PlayerNameLabel").text = ""
	playedCards.get_node("firstCard/CardImage").texture = null
	playedCards.get_node("secondCard/CardImage").texture = null
	playedCards.get_node("thirdCard/CardImage").texture = null
	playedCards.get_node("fourthCard/CardImage").texture = null

func connectClickedCards() -> void:
	hand.card1.clickedCard.connect(onCardClicked)
	hand.card2.clickedCard.connect(onCardClicked)
	hand.card3.clickedCard.connect(onCardClicked)
	
func setUpScene(newPlayerName: String, card1: CardData, card2: CardData, card3: CardData, viradoCard: CardData, newPlayerId: String ):
	hand.setInitialCards(card1, card2, card3)
	connectClickedCards()
	playerName.text = newPlayerName
	
	lastCard.suit = viradoCard.suit
	lastCard.value = viradoCard.value
	lastCard.update_texture()
	
	viradoLabel.text =  "Virado: %s" % [lastCard.getSuitName() ]
	playerId = newPlayerId


func onCardClicked(clickedCard: Card):
	selectedCard = clickedCard
	selectedCardLabel.text =  "Carta seleccionada: %s" % [selectedCard.getCardName() ]

func playCard():
	if selectedCard == hand.card1: playedCard.emit("1")
	if selectedCard == hand.card2: playedCard.emit("2")
	if selectedCard == hand.card3: playedCard.emit("3")


func _on_play_card_button_pressed() -> void:
	if !selectedCard: return
	if not isYourTurn(): return 
	print("played card! " + selectedCard.getCardName())
	playCard()
	hand.playCard(selectedCard)
	selectedCard = null

func isYourTurn():
	return currentPlayerTurnId == playerId
	
func setPlayerTurn(newPlayerId: String):
	currentPlayerTurnId = newPlayerId
	if(isYourTurn()): turnLabel.text = "Es tu turno!" 
	else: turnLabel.text = "No es tu turno =(" 

func addPlayedCard(player: Dictionary, card: Dictionary, playedOrder: int):
	print(playedOrder)
	if (playedOrder == 1):
		var node = playedCards.get_node("firstCard")
		node.get_node("PlayerNameLabel").text = player["name"]
		node.set_card_data(card["value"], card["suit"], node.position )
	if (playedOrder == 2): 
		var node = playedCards.get_node("secondCard")
		node.get_node("PlayerNameLabel").text = player["name"]
		node.set_card_data(card["value"], card["suit"], node.position )
	if (playedOrder == 3):
		var node = playedCards.get_node("thirdCard")
		node.get_node("PlayerNameLabel").text = player["name"]
		node.set_card_data(card["value"], card["suit"], node.position )
	if (playedOrder == 4):
		var node = playedCards.get_node("fourthCard")
		node.get_node("PlayerNameLabel").text = player["name"]
		node.set_card_data(card["value"], card["suit"], node.position )
