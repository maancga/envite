extends Node2D

class_name FourPlayersHandsDisplay

@onready var myHand: MyHand = $MyHand
@onready var secondHand: UnknownHand = $Player2Hand
@onready var thirdHand: UnknownHand = $Player3Hand
@onready var fourthHand: UnknownHand = $Player4Hand
@onready var playedCards: UIPlayedCards = $PlayedCards
@onready var player2NameLabel: Label = $Player2NameLabel
@onready var player3NameLabel: Label = $Player3NameLabel
@onready var player4NameLabel: Label = $Player4NameLabel

var currentPlayerTurnId: String
var players : Dictionary
var yourId: String
var playersArray: Array[String]
var selectedCard: Card = null
signal playedCard(card)

func connectClickedCards() -> void:
	myHand.card1.clickedCard.connect(onCardClicked)
	myHand.card2.clickedCard.connect(onCardClicked)
	myHand.card3.clickedCard.connect(onCardClicked)

func onCardClicked(clickedCard: Card):
	selectedCard = clickedCard

func setHands(card1: CardData, card2: CardData, card3: CardData):
	myHand.setInitialCards(card1, card2, card3)
	connectClickedCards()
	resetOtherPlayersCards()
	cleanPlayedCards()

func setUp(_playerId: String, _playerTurnId: String, _players: Dictionary) -> void:
	yourId = _playerId
	currentPlayerTurnId = _playerTurnId
	players = _players
	for player in players.keys():
		playersArray.append(player)
	for player in playersArray:
		var distance = RelativeHandsDistance.new(playersArray, yourId).calculateDistance(player)
		if (distance == 1):
			player2NameLabel.text = players[player]["name"]
		if (distance == 2):
			player3NameLabel.text = players[player]["name"]
		if (distance == 3):
			player4NameLabel.text = players[player]["name"]

func playCard(playerId: String, index: int):
	var distance = RelativeHandsDistance.new(playersArray, yourId).calculateDistance(playerId)

	var chosenHand = null
	if (distance == 0):
		chosenHand = myHand
	if (distance == 1):
		chosenHand = secondHand
	if (distance == 2):
		chosenHand = thirdHand
	if (distance == 3):
		chosenHand = fourthHand

	if (index == 1):
		chosenHand.playFirstCard()
	if (index == 2):
		chosenHand.playSecondCard()
	if (index == 3):
		chosenHand.playThirdCard()

func resetOtherPlayersCards():
	secondHand.resetCardTextures()
	thirdHand.resetCardTextures()
	fourthHand.resetCardTextures()

	
func addPlayedCard(player: String, card: Dictionary, cardHandIndex: int):
	playedCards.addCard(players[player]["name"], card["value"], card["suit"])
	playCard(player, cardHandIndex)

func playCardButtonPressed():
	if selectedCard == myHand.card1: playedCard.emit("1")
	if selectedCard == myHand.card2: playedCard.emit("2")
	if selectedCard == myHand.card3: playedCard.emit("3")


func _on_play_card_button_pressed() -> void:
	if !selectedCard: return
	playCardButtonPressed()
	selectedCard = null

func cleanPlayedCards():
	playedCards.cleanPlayedCards()
	playedCards.setAmountOfPlayers(playersArray.size())
