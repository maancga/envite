class_name RoundHands

var hands: Dictionary[String, ServerHand] = {}
var playerInteractor: PlayerInteractor

func _init(_playerInteractor: PlayerInteractor) -> void:
	playerInteractor = _playerInteractor

func addHand(playerId: String, hand: ServerHand) -> void:
	playerInteractor.dealHandToPlayer(playerId, hand)
	hands[playerId] = hand

func hasCard(playerId: String, value: ValueEnum.Value, suit: SuitEnum.Suit,) -> bool:
	var playerHand = hands[playerId]
	if playerHand.hasCard(value, suit):
			return true
	return false

func getFirstCard(playerId: String) -> ServerCard:
	var playerHand = hands[playerId]
	return playerHand.getFirstCard()

func getSecondCard(playerId: String) -> ServerCard:
	var playerHand = hands[playerId]
	return playerHand.getSecondCard()

func getThirdCard(playerId: String) -> ServerCard:
	var playerHand = hands[playerId]
	return playerHand.getThirdCard()

func amountOfHands() -> int:
	return hands.size()
