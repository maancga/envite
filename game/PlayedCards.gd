class_name PlayedCards

var playedCards: Dictionary[String, ServerHandCard]
var firstCard: ServerHandCard
var firstPlayerId: String
var playerInteractor: PlayerInteractor
var triumphHierarchy: TriumphHierarchy

func _init(_playerInteractor: PlayerInteractor, _triumphHierarchy: TriumphHierarchy):
	playedCards = {}
	firstCard = null
	playerInteractor = _playerInteractor
	triumphHierarchy = _triumphHierarchy

func addCard(playerId: String, card: ServerHandCard):
	if firstCard == null:
		firstCard = card

	playedCards[playerId] = card

func amountOfCards() -> int:
	return playedCards.size()

func calculateWinner(virado: ServerCard) -> String:
	return RoundWinnerCalculator.new(virado, firstCard, triumphHierarchy).calculateWinner(playedCards)

func cleanCards():
	playedCards.clear()
	firstCard = null

func playerHasPlayedAlready(playerId: String) -> bool:
	return playedCards.has(playerId)
