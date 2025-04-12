extends Node2D

var card_being_dragged
var initial_card_position

@export var card1: Card
@export var card2: Card
@export var card3: Card

func _ready():
	card1 = $Card1
	card2 = $Card2
	card3 = $Card3

func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.global_position = mouse_pos
		

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var card = raycast_check_for_card()
			if card && card is Card:
				initial_card_position = card.global_position
				card_being_dragged = card
		else:
			if card_being_dragged:
				card_being_dragged.global_position = initial_card_position
				card_being_dragged = null

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null
	
func setInitialCards(initialCard1: CardData, initialCard2: CardData,initialCard3: CardData,):
	var cardPreload = preload("res://cards/Card.tscn")
	var newCard1 = cardPreload.instantiate()
	var newCard2 = cardPreload.instantiate()
	var newCard3 = cardPreload.instantiate()

	var card1Position = card1.position
	var card2Position = card2.position
	var card3Position = card3.position
	var card1Rotation = card1.rotation
	var card2Rotation = card2.rotation
	var card3Rotation = card3.rotation
	
	if card1: card1.queue_free()
	if card2: card2.queue_free()
	if card3: card3.queue_free()

	# Add new cards to the scene
	add_child(newCard1)
	add_child(newCard2)
	add_child(newCard3)
	
	newCard1.set_card_data(initialCard1.value,initialCard1.suit, card1Position)
	newCard2.set_card_data(initialCard2.value,initialCard2.suit, card2Position)
	newCard3.set_card_data(initialCard3.value,initialCard3.suit, card3Position)
	newCard1.rotation = card1Rotation
	newCard2.rotation = card2Rotation
	newCard3.rotation = card3Rotation
	
	card1 = newCard1
	card2 = newCard2
	card3 = newCard3
