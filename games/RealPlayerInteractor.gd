class_name RealPlayerInteractor extends PlayerInteractor

func dealHandToPlayer(player: String, hand: ServerHand) -> void:
	print("Player:", player, "→ int?", typeof(player), "→", int(player))
	rpc_id(int(player), "receiveHand", hand)

func informViradoToPlayer(player: String, card: ServerCard) -> void:
	rpc_id(int(player), "receiveVirado", card)
