extends Node

class_name PlayerInteractor

func dealHandToPlayer(_player: String, _hand: ServerHand) -> void:
	push_error("⚠️ dealHandToPlayer() must be implemented by subclass")

func informViradoToPlayer(_player: String, _card: ServerCard) -> void:
	push_error("⚠️ dealHandToPlayer() must be implemented by subclass")
