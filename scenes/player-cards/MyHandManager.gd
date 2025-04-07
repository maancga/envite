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
