extends Node2D

class_name Card

const Suits = preload("res://cards/SuitEnum.gd")
const Values = preload("res://cards/ValueEnum.gd")
const pathResolver = preload("res://cards/CardSpritePathResolver.gd")

signal clickedCard

@export var suit : Suits.Suit
@export var value : Values.Value
@onready var card_image: Sprite2D = $CardImage

func set_card_data(newValue: Values.Value, givenSuit: Suits.Suit, givenPosition: Vector2):
	suit = givenSuit
	value = newValue
	position = givenPosition
	update_texture()

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
