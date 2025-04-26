extends Node2D

signal cardDroppedSignal(card: HandCard)

var onZoneCard: HandCard = null
@onready var cardsContainer = $Control/CardsContainer

func addCard(namePlayer: String, newValue: ValueEnum.Value, givenSuit: SuitEnum.Suit):
	var card = preload("res://scenes/game/drop-zone/DropZoneCard.tscn").instantiate()
	cardsContainer.add_child(card)
	card.setCardData(namePlayer, newValue, givenSuit)

func dropZoneAreaEntered(area: Area2D) -> void:
	var card = area.get_parent()
	if card is HandCard:
		onZoneCard = card
		modulate = Color(1.2, 1.2, 1.2)
		
func dropZoneAreaExited(area: Area2D) -> void:
	var card = area.get_parent()
	if card is HandCard:
		onZoneCard = null
		modulate = Color(1, 1, 1)
		
func _unhandled_input(event):
	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if onZoneCard:
			cardDroppedSignal.emit(onZoneCard)
			onZoneCard = null
			modulate = Color(1, 1, 1)
