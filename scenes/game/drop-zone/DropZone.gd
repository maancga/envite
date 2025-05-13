extends Node2D

class_name DropZone

signal cardDroppedSignal(cardHandIndex: String)

@onready var cardOnZoneSound: AudioStreamPlayer2D = $CardOnZoneSoundStreamPlayer
var isOnDropArea: bool = false
var onZoneCard: HandCard = null
@onready var cardsContainer = $Control/CardsContainer

func _process(_delta: float) -> void:
	processOnDropAreaSound()

func updateCurrentHandWinner(playerId: String):
	for card in cardsContainer.get_children():
		if (card.playerId == playerId): card.paintAsWinning()
		else: card.paintAsNormal()

func addCard(playerName: String, playerId: String, newValue: ValueEnum.Value, givenSuit: SuitEnum.Suit):
	var card = preload("res://scenes/game/drop-zone/DropZoneCard.tscn").instantiate()
	cardsContainer.add_child(card)
	card.setCardData(playerName, playerId, newValue, givenSuit)
	updateCurrentHandWinner(playerId)
	$PlaySoundStreamPlayer.play()

func cleanPlayedCards():
	for card in cardsContainer.get_children():
		card.queue_free()

func	processOnDropAreaSound():
		if isOnDropArea && !cardOnZoneSound.playing:
			cardOnZoneSound.play()
		if !isOnDropArea:
			cardOnZoneSound.stop()

func dropZoneAreaEntered(area: Area2D) -> void:
	var card = area.get_parent()
	if card is HandCard:
		isOnDropArea = true
		onZoneCard = card
		modulate = Color(1.2, 1.2, 1.2)
		
func dropZoneAreaExited(area: Area2D) -> void:
	var card = area.get_parent()
	if card is HandCard:
		isOnDropArea = false
		onZoneCard = null
		modulate = Color(1, 1, 1)
		
func _unhandled_input(event):
	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if onZoneCard:
			cardDroppedSignal.emit(onZoneCard.handIndex)
			onZoneCard = null
			modulate = Color(1, 1, 1)

