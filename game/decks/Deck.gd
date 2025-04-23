extends Node2D

class_name Deck

const Suits = preload("res://game/cards/SuitEnum.gd")
const Values = preload("res://game/cards/ValueEnum.gd")

var cards : Array[ServerCard]

func getTopCard():
	return cards.pop_front()

func getAHand():
	var hand = ServerHand.new(ServerHandCard.new(getTopCard(), 1), ServerHandCard.new(getTopCard(), 2), ServerHandCard.new(getTopCard(), 3))
	return hand

func createAndShuffle():
	push_error("⚠️ createAndShuffle() must be implemented by subclass")
