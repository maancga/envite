extends GameControllerInterface

class_name ClientGameController

const CardIndex = {
	CARD_1 = "1",
	CARD_2 = "2",
	CARD_3 = "3"
}

signal returnToMenuSignal()
var gameScene: GameScene

func _init(_gameScene: GameScene):
	gameScene = _gameScene

func sendToServer(method: String, args := []):
	const SERVER_ID = 1
	if args.size() == 0:
		rpc_id(SERVER_ID, method)
	elif args.size() == 1:
		rpc_id(SERVER_ID, method, args[0])
	elif args.size() == 2:
		rpc_id(SERVER_ID, method, args[0], args[1])
	else:
		push_error("Too many args for send_to_server")

@rpc("authority")
func receivePlayersAndTeams(players: Dictionary, team1: Array[String], team2: Array[String], team1Leader: String, team2Leader: String):
	var playerId = multiplayer.get_unique_id()
	var playerAmounts = team1.size() + team2.size()
	var handDisplayScene = null
	match playerAmounts:
		4: handDisplayScene = preload("res://scenes/game/player-hands-display/FourPlayersHandsDisplay.tscn").instantiate()
		6: handDisplayScene = preload("res://scenes/game/player-hands-display/SixPlayersHandsDisplay.tscn").instantiate()
		8: handDisplayScene = preload("res://scenes/game/player-hands-display/EightPlayersHandsDisplay.tscn").instantiate()
		10: handDisplayScene = preload("res://scenes/game/player-hands-display/TenPlayersHandsDisplay.tscn").instantiate()
		12: handDisplayScene = preload("res://scenes/game/player-hands-display/TwelvePlayersHandsDisplay.tscn").instantiate()
	gameScene.setUpScene(str(playerId), players, team1, team2, team1Leader, team2Leader, handDisplayScene)
	gameScene.connect("vidoCalledSignal", callVido)
	gameScene.connect("vidoAcceptedSignal", acceptVido)
	gameScene.connect("vidoRejectedSignal", rejectVido)
	gameScene.connect("vidoRaisedSignal", raisedVido)
	gameScene.connect("playedCardSignal", playCard)
	gameScene.connect("tumbarSignal", tumbar)
	gameScene.connect("achicarseSignal", achicarse)
	gameScene.connect("returnToMenuSignal", onReturnToMenu)

@rpc("authority")
func receiveHand(hand: Dictionary):
	gameScene.setCards(
		CardData.new(hand.firstCard.value, hand.firstCard.suit), 
		CardData.new(hand.secondCard.value, hand.secondCard.suit), 
		CardData.new(hand.thirdCard.value, hand.thirdCard.suit), 
	)

@rpc("authority")
func receiveVirado(virado: Dictionary):
	gameScene.setVirado(
		CardData.new(virado.value, virado.suit)
	)

@rpc("authority")
func receivePlayerTurn(playerId: String):
	gameScene.setPlayerTurn(playerId)

@rpc("authority")
func receiveCardPlayed(playerId: String, card: Dictionary, cardHandIndex: int):
	gameScene.addPlayedCard(playerId, card, cardHandIndex)

@rpc("authority")
func receivePlayerRoundWinner(playerId: String, roundScore: int):
	gameScene.playerWonRound(playerId, roundScore)

@rpc("authority")
func receiveTeamWonPiedras(teamName: String, piedras: int):
	gameScene.teamWonPiedras(teamName, piedras)

@rpc("authority")
func receiveTeamWonChico(teamName: String, chicos: int):
	gameScene.teamWonChico(teamName, chicos)

@rpc("authority")
func receiveTeamWon(teamName: String):
	gameScene.teamWon(teamName)

@rpc("authority")
func receiveDealer(dealer: String):
	gameScene.setDealer(dealer)

@rpc("authority")
func receivePlayerCouldNotPlayCardBecauseItsNotTurn():
	gameScene.notifyIsNotTurn()

@rpc("authority")
func receivePlayerCouldNotPlayCardBecauseHasPlayedAlreadyInHand():
	gameScene.notifyHasPlayedAlreadyInHand()

@rpc("authority")
func receivePlayerCouldNotPlayCardBecauseItsPlayedAlready():
	gameScene.notifyCardPlayedAlready()

@rpc("authority")
func receivePlayerCalledVido(playerId: String):
	gameScene.setPlayerCalledVido(playerId)

@rpc("authority")
func receivePlayerRefusedVido(playerId: String):
	gameScene.refusedVido(playerId)

@rpc("authority")
func receivePlayerAcceptedVido(playerId):
	gameScene.acceptedVido(playerId)

@rpc("authority")
func receivePlayerRaisedVidoTo7Piedras(playerId: String):
	gameScene.raisedVidoTo7Piedras(playerId)

@rpc("authority")
func receivePlayerRaisedVidoTo9Piedras(playerId: String):
	gameScene.raisedVidoTo9Piedras(playerId)

@rpc("authority")
func receivePlayerRaisedVidoToChico(playerId: String):
	gameScene.raisedVidoToChico(playerId)

@rpc("authority")
func receivePlayerRaisedVidoToGame(playerId: String):
	gameScene.raisedVidoToGame(playerId)

@rpc("authority")
func receivePlayerFromSameTeamCanNotTakeDecision(_playerId: String):
	print("player from same team can not take this decision")

@rpc("authority")
func receiveOnlyLeaderCanTakeThisDecision():
	print("only leader can take this decision")

@rpc("authority")
func receiveVidoCanOnlyBeCalledOnYourTurn():
	gameScene.receiveVidoCanOnlyBeCalledOnYourTurn()

@rpc("authority")
func receiveCannNotPlayCardBecauseTumboIsBeingDecided():
	gameScene.cannNotPlayBecauseTumboIsBeingDecided()

@rpc("authority")
func receiveCannNotCallVidoBecauseTumboIsBeingDecided():
	gameScene.cannNotCallVidoBecauseTumboIsBeingDecided()

@rpc("authority")
func receiveTeam1IsOnTumbo():
	gameScene.notifyTeam1IsOnTumbo()

@rpc("authority")
func receiveTeam2IsOnTumbo():
	gameScene.notifyTeam2IsOnTumbo()

@rpc("authority")
func receiveCannNotTakeThisDecisionIfNotInWaitingForTumbo():
	gameScene.notifyCannNotTakeThisDecisionIfNotInWaitingForTumbo()

@rpc("authority")
func receiveTumboIsAccepted():
	gameScene.notifyTumboIsAccepted()

@rpc("authority")
func receiveTumboIsRejected():
	gameScene.notifyTumboIsRejected()

@rpc("authority")
func receiveCanNotMakeTheActionAfterTheGameEnded():
	gameScene.notifyCanNotMakeTheActionAfterTheGameEnded()

@rpc("authority")
func receiveVidoCalledThisRoundAlready():
	gameScene.notifyVidoCalledThisRoundAlready()

@rpc("authority")
func receiveCurrentHandWinner(playerId: String):
	gameScene.notifyCurrentHandWinner(playerId)

func playCard(cardIndex: String) -> void:
	if cardIndex not in CardIndex.values():
		push_error("Invalid cardIndex: " + cardIndex)
		return
	sendToServer("onClientPlayedCard", [cardIndex])

func callVido() -> void:
	sendToServer("onClientCalledVido")

func acceptVido() -> void:
	sendToServer("onClientAcceptedVido")

func rejectVido() -> void:
	sendToServer("onClientRejectedVido")

func raisedVido() -> void:
	sendToServer("onClientRaisedVido")

func tumbar() -> void:
	sendToServer("onClientTumbar")

func achicarse() -> void:
	sendToServer("onClientAchicarse")

func clientNotifiestItJoinedGame():
	sendToServer("onClientNotifiesItJoinedGame")

func onReturnToMenu():
	returnToMenuSignal.emit()
