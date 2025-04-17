class_name PlayedCards

var cards: Dictionary[String, ServerCard]
var firstCard: ServerCard
var firstPlayerId: String
var playerInteractor: PlayerInteractor

func _init(_playerInteractor: PlayerInteractor):
    cards = {}
    firstCard = null
    playerInteractor = _playerInteractor

func addCard(playerId: String, card: ServerCard, turn: int):
    if firstCard == null:
        firstCard = card
    if cards.has(playerId): return
    cards[playerId] = card
    playerInteractor.informPlayerPlayedCard(playerId, card, turn)

func calculateWinner(virado: ServerCard) -> String:
    return RoundWinnerCalculator.new(virado, firstCard).calculateWinner(cards)
