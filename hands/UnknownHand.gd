extends Node2D

class_name UnknownHand 

@onready var card1 = $Card1
@onready var card2 = $Card2
@onready var card3 = $Card3
var UNKNWON_CARD_TEXTURE = load("res://cards/images/carta_desconocida_1.png")


func playFirstCard():
	card1.get_node("CardImage").texture = null
	
func playSecondCard():
	card2.get_node("CardImage").texture = null
	
func playThirdCard():
	card3.get_node("CardImage").texture = null

func resetCardTextures():
	card1.get_node("CardImage").texture = UNKNWON_CARD_TEXTURE
	card2.get_node("CardImage").texture = UNKNWON_CARD_TEXTURE
	card3.get_node("CardImage").texture = UNKNWON_CARD_TEXTURE
