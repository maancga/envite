class_name RealPlayerInteractor extends PlayerInteractor

signal dealHandToPlayerSignal(player: String, hand: ServerHand)
signal dealViradoToPlayerSignal(player: String, card: ServerCard)
signal sendCurrentPlayerTurnSignal(player: String)
signal sendPlayerPlayedCardSignal(player: Dictionary, card: ServerCard, playedOrder: int)

func dealHandToPlayer(player: String, hand: ServerHand) -> void:
	dealHandToPlayerSignal.emit(player, hand)

func informViradoToPlayer(card: ServerCard) -> void:
	dealViradoToPlayerSignal.emit(card)

func informPlayerTurn(player: String) -> void:
	sendCurrentPlayerTurnSignal.emit(player)

func informPlayerPlayedCard(player: Dictionary, card: ServerCard, playedOrder: int) -> void:
	sendPlayerPlayedCardSignal.emit(player, card, playedOrder)
