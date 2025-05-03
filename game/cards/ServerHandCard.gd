class_name ServerHandCard

var card: ServerCard
var cardIndexHand: int

func _init(_card: ServerCard, _cardIndexHand: int) -> void:
	card = _card
	cardIndexHand = _cardIndexHand

func to_dict() -> Dictionary:
	return card.to_dict()

func equals(other: ServerHandCard) -> bool:
	if card.equals(other.card):
		return true
	return false

func play() -> void:
	card.play()

func isPlayed() -> bool:
	return card.isPlayed()

func getCardName() -> String:
	return card.getCardName()
