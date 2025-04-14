extends Node2D

class_name Deck

const Suits = preload("res://cards/SuitEnum.gd")
const Values = preload("res://cards/ValueEnum.gd")

var cards : Array[ServerCard]

func getTopCard():
	return cards.pop_front()

func createAndShuffle():
	push_error("⚠️ createAndShuffle() must be implemented by subclass")
