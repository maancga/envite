class_name PlayedCards

var playedCards: Dictionary[String, ServerHandCard]
var firstCard: ServerHandCard
var firstPlayerId: String
var playerInteractor: PlayerInteractor

func _init(_playerInteractor: PlayerInteractor):
	playedCards = {}
	firstCard = null
	playerInteractor = _playerInteractor

func addCard(playerId: String, card: ServerHandCard):
	if firstCard == null:
		firstCard = card

	playedCards[playerId] = card

func amountOfCards() -> int:
	return playedCards.size()

func calculateWinner(virado: ServerCard) -> String:
	return RoundWinnerCalculator.new(virado, firstCard).calculateWinner(playedCards)

func cleanCards():
	playedCards.clear()
	firstCard = null

func playerHasPlayedAlready(playerId: String) -> bool:
	return playedCards.has(playerId)
