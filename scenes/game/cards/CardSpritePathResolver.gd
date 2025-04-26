extends Node

class_name CardSpritePathResolver

const SUITS_TO_PATH = {
	SuitEnum.Suit.OROS: "oro",
	SuitEnum.Suit.COPAS: "copas",
	SuitEnum.Suit.ESPADAS: "espadas",
	SuitEnum.Suit.BASTOS: "bastos"
}

const VALUES_TO_STRING = {
	ValueEnum.Value.AS: "0",
	ValueEnum.Value._2: "1",
	ValueEnum.Value._3: "2",
	ValueEnum.Value._4: "3",
	ValueEnum.Value._5: "4",
	ValueEnum.Value._6: "5",
	ValueEnum.Value._7: "6",
	ValueEnum.Value.SOTA: "7",
	ValueEnum.Value.CABALLO: "8",
	ValueEnum.Value.REY: "9"
}

func resolve(suit: SuitEnum.Suit, value: ValueEnum.Value):
	var suit_path = SUITS_TO_PATH[suit]
	var value_path  = VALUES_TO_STRING[value]
	var path = "res://scenes/game/cards/images/cards/card_" + suit_path + "_" + value_path + ".png"
	return path
