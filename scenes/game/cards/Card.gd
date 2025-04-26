extends Node2D

class_name Card

const Suits = preload("res://game/cards/SuitEnum.gd")
const Values = preload("res://game/cards/ValueEnum.gd")
const pathResolver = preload("res://scenes/game/cards/CardSpritePathResolver.gd")

signal clickedCard
signal hovered
signal hoveredOff

@export var suit : Suits.Suit
@export var value : Values.Value
@onready var card_image: Sprite2D = $CardImage
var cardOverDropArea: bool

func setPosition(newPosition: Vector2):
	position = newPosition

func setRotation(newRotation: float):
	rotation_degrees = newRotation

func setCardData(newValue: Values.Value, givenSuit: Suits.Suit):
	suit = givenSuit
	value = newValue
	update_texture()
	
# func _process(_delta: float) -> void:
	#if card_being_dragged:
		#var mouse_pos = get_global_mouse_position()
	#	card_being_dragged.global_position = mouse_pos

func update_texture():
	var path = pathResolver.new().resolve(suit, value)
	var tex = load(path)
	card_image.texture = tex

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		clickedCard.emit(self)
		
func getCardName():
	return  ValueEnum.VALUES_TRANSLATIONS[value] + " de " + getSuitName()
	
func getSuitName():
	return str(SuitEnum.SUIT_NAMES[suit])


func _on_area_2d_mouse_entered() -> void:
	hovered.emit(self)

func _on_area_2d_mouse_exited() -> void:
	hoveredOff.emit(self)
	
func cardIsOverDropArea():
	cardOverDropArea = true
	
func cardNotOverDropArea():
	cardOverDropArea = false
	
func isCardOverDropArea():
	return cardOverDropArea

	
