extends Node2D

@onready var myhand: NewMyHand = $NewMyHand
@onready var dropZone = $DropZone

func _ready():
	var card1 =  preload("res://scenes/game/cards/HandCard.tscn").instantiate()
	var card2 =  preload("res://scenes/game/cards/HandCard.tscn").instantiate()
	var card3 =  preload("res://scenes/game/cards/HandCard.tscn").instantiate()
	var card4 =  preload("res://scenes/game/cards/HandCard.tscn").instantiate()
	var card5 =  preload("res://scenes/game/cards/HandCard.tscn").instantiate()
	myhand.addCard(card1)
	myhand.addCard(card2)
	myhand.addCard(card3)
	myhand.addCard(card4)
	myhand.addCard(card5)
	card1.setCardData(ValueEnum.Value._4, SuitEnum.Suit.COPAS)
	card2.setCardData(ValueEnum.Value._6, SuitEnum.Suit.OROS)
	card3.setCardData(ValueEnum.Value._4, SuitEnum.Suit.ESPADAS)
	card4.setCardData(ValueEnum.Value.CABALLO, SuitEnum.Suit.BASTOS)
	card5.setCardData(ValueEnum.Value.SOTA, SuitEnum.Suit.OROS)

	dropZone.connect("cardDroppedSignal", onCardDropped)
	
func onCardDropped(card: HandCard):
	myhand.eraseCard(card)
	dropZone.addCard("holaaa", card.value, card.suit)
	
