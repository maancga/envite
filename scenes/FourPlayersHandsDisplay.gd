extends Node2D

class_name FourPlayersHandsDisplay

@onready var myHand: MyHand = $MyHand
@onready var secondHand: UnknownHand = $Player2Hand
@onready var thirdHand: UnknownHand = $Player3Hand
@onready var fourthHand: UnknownHand = $Player4Hand
@onready var playedCards = $"4PlayersPlayedCards"
@onready var player2NameLabel = $Player2NameLabel
@onready var player3NameLabel = $Player3NameLabel
@onready var player4NameLabel = $Player4NameLabel

var currentPlayerTurnId: String
var players : Dictionary
var yourId: String
var playersArray: Array[String]

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


func cleanPlayedCards():
	playedCards.get_node("firstCard/PlayerNameLabel").text = ""
	playedCards.get_node("secondCard/PlayerNameLabel").text = ""
	playedCards.get_node("thirdCard/PlayerNameLabel").text = ""
	playedCards.get_node("fourthCard/PlayerNameLabel").text = ""
	playedCards.get_node("firstCard/CardImage").texture = null
	playedCards.get_node("secondCard/CardImage").texture = null
	playedCards.get_node("thirdCard/CardImage").texture = null
	playedCards.get_node("fourthCard/CardImage").texture = null

func resetOtherPlayersCards():
	secondHand.resetCardTextures()
	thirdHand.resetCardTextures()
	fourthHand.resetCardTextures()

	
func addPlayedCard(player: String, card: Dictionary, playedOrder: int, cardHandIndex: int):
	print("Player %s played card its %s card %s" % [players[player]["name"], cardHandIndex, card, ])
	if (playedOrder == 1):
		var node = playedCards.get_node("firstCard")
		node.get_node("PlayerNameLabel").text = players[player]["name"]
		node.set_card_data(card["value"], card["suit"] )
	if (playedOrder == 2): 
		var node = playedCards.get_node("secondCard")
		node.get_node("PlayerNameLabel").text = players[player]["name"]
		node.set_card_data(card["value"], card["suit"] )
	if (playedOrder == 3):
		var node = playedCards.get_node("thirdCard")
		node.get_node("PlayerNameLabel").text = players[player]["name"]
		node.set_card_data(card["value"], card["suit"] )
	if (playedOrder == 4):
		var node = playedCards.get_node("fourthCard")
		node.get_node("PlayerNameLabel").text = players[player]["name"]
		node.set_card_data(card["value"], card["suit"])
	playCard(player, cardHandIndex)
