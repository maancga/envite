extends Node

class_name PlayerInteractor

func dealHandToPlayer(_player: String, _hand: ServerHand) -> void:
	push_error("⚠️ dealHandToPlayer() must be implemented by subclass")

func informViradoToPlayer(_card: ServerCard) -> void:
	push_error("⚠️ dealHandToPlayer() must be implemented by subclass")

func informPlayerTurn(_player: String) -> void:
	push_error("⚠️ informPlayerTurn() must be implemented by subclass")

func informPlayerPlayedCard(_player: Dictionary, _card: ServerCard, _playedOrder: int) -> void:
	push_error("⚠️ informPlayerPlayedCard() must be implemented by subclass")
