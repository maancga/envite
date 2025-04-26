extends Node2D

class_name HandCard

@export var suit : SuitEnum.Suit
@export var value : ValueEnum.Value
@onready var cardImage: CardImage = $CardImage
var cardOverDropArea: bool
var handIndex: String = "0"
var isHiden: bool

var dragging: bool = false
var initialPosition: Vector2 = Vector2.ZERO
var initialZIndex: int = 0
static var draggingCard : HandCard = null 
static var hoveredCard : HandCard = null 
var dragTween: Tween = null

func _exit_tree():
	if draggingCard == self:
		draggingCard = null
	if hoveredCard == self:
		hoveredCard = null
	dragging = false

func _ready():
	update_texture()

func setCardData(newValue: ValueEnum.Value, givenSuit: SuitEnum.Suit):
	suit = givenSuit
	value = newValue
	update_texture()

func setHandIndex(index: String):
	handIndex = index

func setPositionWithTransition(newPosition: Vector2):
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", newPosition, 0.2)
	initialPosition = newPosition

func setRotation(newRotation: float):
	rotation_degrees = newRotation

func setZIndex(zIndex: int):
	z_index = zIndex
	initialZIndex = zIndex

func update_texture():
	cardImage.update_texture(suit, value)

func _process(_delta):
	if dragging:
		updateCardPosition()

func otherCardIsBeingDragged():
	return draggingCard != null && draggingCard != self
	
func _onArea2DInputEvent(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not (event is InputEventMouseButton):
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	if event.pressed:
		if otherCardIsBeingDragged():
			return
		if hoveredCard == self:
			startBeingDraged()
	else:
		if dragging and draggingCard == self:
			stopBeingDraged()

func _unhandled_input(event):
	if dragging and event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		stopBeingDraged()

func startBeingDraged():
	draggingCard = self
	dragging = true
	initialPosition = position
	z_index = 1000
	scale *= 1.05
	modulate = Color(1.2, 1.2, 1.2)
	if dragTween:
		dragTween.kill()
	dragTween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func updateCardPosition():
	var localMousePos = get_parent().to_local(get_global_mouse_position())

	if dragTween:
		dragTween.kill()

	dragTween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	dragTween.tween_property(self, "position", localMousePos, 0.2)

func stopBeingDraged():
	dragging = false
	z_index = initialZIndex
	modulate = Color(1, 1, 1)
	if draggingCard == self:
		draggingCard = null

	snapBack()

func snapBack():
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", initialPosition, 0.3)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.3)

func onMouseEnteredArea() -> void:
	if hoveredCard and hoveredCard != self:
		hoveredCard.resetHover()
	hoveredCard = self
	startHover()

func startHover():
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
	z_index = 1000


func onMouseExitedArea() -> void:
	if hoveredCard == self:
		resetHover()
		hoveredCard = null

func resetHover() -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	z_index = initialZIndex

func hideCard() -> void:
	isHiden = true
	cardImage.visible = false
