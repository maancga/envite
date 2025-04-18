extends Node2D

class_name MyHand

var card_being_dragged
var initial_card_position

@export var card1: Card
@export var card2: Card
@export var card3: Card
@export var spacingCurve: Curve
@export var rotationCurve: Curve
@export var heightCurve: Curve

func _ready() -> void:
	card1.update_texture()
	card2.update_texture()
	card3.update_texture()
	connectHoverSignals()
	movePositions()


func movePositions():
	var cards = [card1, card2, card3]
	var showingCards = cards.filter(func(card): return card.card_image.texture != null)

	for card in showingCards:
		var index = showingCards.find(card) + 1
		var elementInDistribution: float = (float(index) / (showingCards.size() + 1))
		var spacingResult = getRelativeX(elementInDistribution)
		var heightResult = getRelativeHeight(elementInDistribution)
		card.setPosition(Vector2(spacingResult, heightResult))
		var new_rotation = getRelativeRotation(elementInDistribution)
		card.setRotation(new_rotation)
		print("element:", elementInDistribution, " spacing:", spacingResult, " height:", heightResult, " rotation:", new_rotation)

func getRelativeHeight(elementInDistribution: float):
	return heightCurve.sample_baked(elementInDistribution)

func getRelativeRotation(elementInDistribution: float):
	return rotationCurve.sample_baked(elementInDistribution)

func getRelativeX(elementInDistribution: float):
	return spacingCurve.sample_baked(elementInDistribution)

func connectHoverSignals() -> void:
	card1.hovered.connect(onCardHovered)
	card2.hovered.connect(onCardHovered)
	card3.hovered.connect(onCardHovered)
	card1.hoveredOff.connect(onCardHoveredOff)
	card2.hoveredOff.connect(onCardHoveredOff)
	card3.hoveredOff.connect(onCardHoveredOff)

func hightlightCard(card: Card) -> void:
	card.card_image.scale = Vector2(1.1, 1.1)

func unhightlightCard(card: Card) -> void:
	card.card_image.scale = Vector2(1, 1)

func onCardHovered(card: Card) -> void:
	hightlightCard(card)

func onCardHoveredOff(card: Card) -> void:
	unhightlightCard(card)

func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.global_position = mouse_pos
		

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var card = raycast_check_for_card()
			if card && isHandCard(card):
				initial_card_position = card.global_position
				card_being_dragged = card
		else:
			if card_being_dragged:
				card_being_dragged.global_position = initial_card_position
				card_being_dragged = null

func isHandCard(card: Node) -> bool:
	if card == card1 or card == card2 or card == card3:
		return true
	return false
				
func playFirstCard():
	card1.card_image.texture = null
	movePositions()
	
func playSecondCard():
	card2.card_image.texture = null
	movePositions()


func playThirdCard():
	card3.card_image.texture = null
	movePositions()

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
	card1.set_card_data(initialCard1.value, initialCard1.suit)
	card2.set_card_data(initialCard2.value, initialCard2.suit)
	card3.set_card_data(initialCard3.value, initialCard3.suit)
