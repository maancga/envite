extends Node2D

@onready var playersDisplay: HandDisplaysScript

signal vidoCalledSignal()
signal vidoAcceptedSignal()
signal vidoRejectedSignal()
signal vidoRaisedSignal()
signal playedCardSignal()


var playerId : String
var currentPlayerTurnId: String
var players : Dictionary
var team1 : Array[String]
var team2 : Array[String]
var currentDealerId: String

func setVirado(card: CardData):
	playersDisplay.setVirado(card)

func setCards(card1: CardData, card2: CardData, card3: CardData):
	playersDisplay.setHands(card1, card2, card3)

func setTeamLabels():
	playersDisplay.setTeamLabels()

func setUpScene(newPlayerId: String, newPlayers: Dictionary, newTeam1: Array[String], newTeam2: Array[String], team1Leader: String, team2Leader: String, handDisplay: Node):
	players = newPlayers
	team1 = newTeam1
	team2 = newTeam2
	add_child(handDisplay)
	playersDisplay = handDisplay
	playersDisplay.setUp(newPlayerId, currentPlayerTurnId, newPlayers, team1Leader, team2Leader, newTeam1, newTeam2)
	setTeamLabels()
	playersDisplay.connect("vidoCalledSignal", onVidoCalled)
	playersDisplay.connect("vidoAcceptedSignal", onVidoAccepted)
	playersDisplay.connect("vidoRejectedSignal", onVidoRejected)
	playersDisplay.connect("vidoRaisedSignal", onVidoRaised)
	playersDisplay.connect("droppedCardSignal", onDroppedCard)



func setPlayerTurn(newPlayerId: String):
	playersDisplay.setTurnTo(newPlayerId)

func addPlayedCard(player: String, card: Dictionary, cardHandIndex: int):
	playersDisplay.addPlayedCard(player, card, cardHandIndex)

func getTeam(player: String) -> String:
	if player in team1: return "team1"
	if player in team2: return "team2"
	return "unknown"

func playerWonRound(player: String,  roundScore: int):
	playersDisplay.playerWonRound(player, roundScore)

func teamWonChicoPoints(teamName: String, chicoPoints: int):
	playersDisplay.teamWonChicoPoints(teamName, chicoPoints)

func teamWonChico(teamName: String, chicosScore: int):
	playersDisplay.teamWonChico(teamName, chicosScore)

func teamWon(teamName: String):
	playersDisplay.teamWon(teamName)

func setDealer(dealer: String):
	currentDealerId = dealer

func onVidoCalled():
	vidoCalledSignal.emit()

func setPlayerCalledVido(vidoPlayerId: String):
	playersDisplay.setVidoCalledView(vidoPlayerId)

func rejectedVido(rejecterPlayer: String):
	playersDisplay.exitVidoCalled(rejecterPlayer)

func raisedVidoTo7Piedras(vidoPlayerId: String):
	playersDisplay.raisedVidoTo7Piedras(vidoPlayerId)

func raisedVidoTo9Piedras(vidoPlayerId: String):
	playersDisplay.raisedVidoTo9Piedras(vidoPlayerId)

func raisedVidoToChico(vidoPlayerId: String):
	playersDisplay.raisedVidoToChico(vidoPlayerId)

func raisedVidoToGame(vidoPlayerId: String):
	playersDisplay.raisedVidoToGame(vidoPlayerId)

func onVidoAccepted():
	vidoAcceptedSignal.emit()
	
func onVidoRejected():
	vidoRejectedSignal.emit()
	
func onVidoRaised():
	vidoRaisedSignal.emit()

func onDroppedCard(cardIndex: String):
	playedCardSignal.emit(cardIndex)

func refusedVido(vidoPlayerId: String):
	playersDisplay.refusedVido(vidoPlayerId)
	
func acceptedVido(vidoPlayerId: String):
	playersDisplay.acceptedVido(vidoPlayerId)

func notifyIsNotTurn():
	print("No es tu turno!")

func notifyCardPlayedAlready():
	print("Ya jugaste esa carta!")

func notifyHasPlayedAlreadyInHand():
	print("Ya jugaste una carta en esta mano!")

func vidoCanOnlyBeCalledOnYourTurn():
	print("No puedes hacer vido si no es tu turno!")
