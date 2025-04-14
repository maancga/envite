class_name RealPlayerInteractor extends PlayerInteractor

signal dealHandToPlayerSignal(player: String, hand: ServerHand)
signal dealViradoToPlayerSignal(player: String, card: ServerCard)

func dealHandToPlayer(player: String, hand: ServerHand) -> void:
	dealHandToPlayerSignal.emit(player, hand)


func informViradoToPlayer(player: String, card: ServerCard) -> void:
	dealViradoToPlayerSignal.emit(player, card)
