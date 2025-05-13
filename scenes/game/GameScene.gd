extends Node2D
class_name GameScene

@onready var playersDisplay: HandDisplaysScript

signal vidoCalledSignal()
signal vidoAcceptedSignal()
signal vidoRejectedSignal()
signal vidoRaisedSignal()
signal playedCardSignal()
signal tumbarSignal()
signal achicarseSignal()
signal returnToMenuSignal()

var currentPlayerTurnId: String
var players : Dictionary
var team1 : Array[String]
var team2 : Array[String]
var currentDealerId: String
var playerId: String
var team1Leader: String
var team2Leader: String

@onready var notificationsManager: NotificationsManager = $Notifications
@onready var yourTurnSound = $YourTurnSound

func setVirado(card: CardData):
	playersDisplay.setVirado(card)

func setCards(card1: CardData, card2: CardData, card3: CardData):
	playersDisplay.setHands(card1, card2, card3)

func setTeamLabels():
	playersDisplay.setTeamLabels()

func setUpScene(newPlayerId: String, newPlayers: Dictionary, newTeam1: Array[String], newTeam2: Array[String], _team1Leader: String, _team2Leader: String, handDisplay: Node):
	playerId = newPlayerId
	players = newPlayers
	team1 = newTeam1
	team2 = newTeam2
	team1Leader = _team1Leader
	team2Leader = _team2Leader
	add_child(handDisplay)
	playersDisplay = handDisplay
	playersDisplay.setUp(newPlayerId, currentPlayerTurnId, newPlayers, team1Leader, _team2Leader, newTeam1, newTeam2, notificationsManager)
	setTeamLabels()
	playersDisplay.connect("vidoCalledSignal", onVidoCalled)
	playersDisplay.connect("vidoAcceptedSignal", onVidoAccepted)
	playersDisplay.connect("vidoRejectedSignal", onVidoRejected)
	playersDisplay.connect("vidoRaisedSignal", onVidoRaised)
	playersDisplay.connect("droppedCardSignal", onDroppedCard)
	playersDisplay.connect("yourTurnSignal", onYourTurn)
	playersDisplay.connect("tumbarSignal", onTumbar)
	playersDisplay.connect("achicarseSignal", onAchicarse)

func setPlayerTurn(newPlayerId: String):
	playersDisplay.setTurnTo(newPlayerId)

func addPlayedCard(player: String, card: Dictionary, cardHandIndex: int):
	playersDisplay.addPlayedCard(player, card, cardHandIndex)

func playerWonRound(player: String,  roundScore: int):
	playersDisplay.playerWonRound(player, roundScore)
	notificationsManager.showMessage(players[player]["name"] + " ganó la mano")

func teamWonPiedras(teamName: String, piedras: int):
	playersDisplay.teamWonPiedras(teamName, piedras)
	notificationsManager.showMessage("El equipo " + teamName + " ganó " + str(piedras) + " piedras")

func teamWonChico(teamName: String, chicosScore: int):
	playersDisplay.teamWonChico(teamName, chicosScore)
	notificationsManager.showMessage("El equipo " + teamName + " ganó un chico")

func teamWon(teamName: String):
	playersDisplay.teamWon(teamName)
	notificationsManager.showMessage("El equipo " + teamName + " ganó la partida")
	var endGame = preload("res://scenes/game/end-game/EndGame.tscn").instantiate()
	add_child(endGame)
	endGame.connect("buttonPressedSignal", returnToMenu)

func setDealer(dealer: String):
	currentDealerId = dealer

func onVidoCalled():
	vidoCalledSignal.emit()

func setPlayerCalledVido(vidoPlayerId: String):
	playersDisplay.setVidoCalledView(vidoPlayerId)
	$VidoCalledFor4PiedrasSound.play()
	notificationsManager.showMessage(players[vidoPlayerId]["name"] + " envidó por 4 piedras" )

func rejectedVido(rejecterPlayer: String):
	playersDisplay.exitVidoCalled(rejecterPlayer)

func raisedVidoTo7Piedras(vidoPlayerId: String):
	playersDisplay.raisedVidoTo7Piedras(vidoPlayerId)
	$VidoCalledFor7PiedrasSound.play()
	notificationsManager.showMessage(players[vidoPlayerId]["name"] + " envidó por 7 piedras" )

func raisedVidoTo9Piedras(vidoPlayerId: String):
	playersDisplay.raisedVidoTo9Piedras(vidoPlayerId)
	$VidoCalledFor9PiedrasSound.play()
	notificationsManager.showMessage(players[vidoPlayerId]["name"] + " envidó por 9 piedras" )

func raisedVidoToChico(vidoPlayerId: String):
	playersDisplay.raisedVidoToChico(vidoPlayerId)
	$VidoCalledForChicoSound.play()
	notificationsManager.showMessage(players[vidoPlayerId]["name"] + " envidó por un chico" )

func raisedVidoToGame(vidoPlayerId: String):
	playersDisplay.raisedVidoToGame(vidoPlayerId)
	$VidoCalledForGameSound.play()
	notificationsManager.showMessage(players[vidoPlayerId]["name"] + " envidó por LA PARTIDA" )

func onVidoAccepted():
	vidoAcceptedSignal.emit()
	
func onVidoRejected():
	vidoRejectedSignal.emit()
	
func onVidoRaised():
	vidoRaisedSignal.emit()

func onTumbar():
	tumbarSignal.emit()

func onAchicarse():
	achicarseSignal.emit()

func onDroppedCard(cardIndex: String):
	playedCardSignal.emit(cardIndex)

func refusedVido(vidoPlayerId: String):
	playersDisplay.refusedVido(vidoPlayerId)
	
func acceptedVido(vidoPlayerId: String):
	playersDisplay.acceptedVido(vidoPlayerId)

func notifyIsNotTurn():
	$WrongActionSound.play()
	notificationsManager.showMessage("No es tu turno!")

func notifyCardPlayedAlready():
	$WrongActionSound.play()
	notificationsManager.showMessage("Ya jugaste esa carta!")


func notifyHasPlayedAlreadyInHand():
	$WrongActionSound.play()
	notificationsManager.showMessage("Ya jugaste una carta en esta mano!")


func vidoCanOnlyBeCalledOnYourTurn():
	$WrongActionSound.play()
	notificationsManager.showMessage("No puedes hacer vido si no es tu turno!")

func onYourTurn():
	$YourTurnSound.play()
	notificationsManager.showMessage("Es tu turno!")

func cannNotPlayBecauseTumboIsBeingDecided():
	$WrongActionSound.play()
	notificationsManager.showMessage("No puedes jugar porque se está decidiendo el tumbo!")

func cannNotCallVidoBecauseTumboIsBeingDecided():
	$WrongActionSound.play()
	notificationsManager.showMessage("No puedes vidar porque se está decidiendo el tumbo!")

func notifyTeam1IsOnTumbo():
	playersDisplay.team1OnTumboView()
	if playerId in team2: 
		notificationsManager.showMessage("El equipo 1 está decidiendo el tumbo")
		return
	if not (team1Leader == playerId):
		notificationsManager.showMessage(players[team1Leader]["name"] + " tiene que elegir si tumbar")
		return
	if (team1Leader == playerId):
		notificationsManager.showMessage("Tienes que seleccionar el tumbo")
		return

func notifyTeam2IsOnTumbo():
	playersDisplay.team2OnTumboView()
	if playerId in team1: notificationsManager.showMessage("El equipo 2 está decidiendo el tumbo")
	if not (team2Leader == playerId):
		notificationsManager.showMessage(players[team2Leader]["name"] + "tiene que seleccionar el tumbo")
		return
	if (team2Leader == playerId):
		notificationsManager.showMessage("Tienes que seleccionar el tumbo")
		return

func notifyCannNotTakeThisDecisionIfNotInWaitingForTumbo():
	notificationsManager.showMessage("Esta decisión no puede tomarse si no se está en tumbo")

func notifyTumboIsAccepted():
	notificationsManager.showMessage("¡Tumbo!")
	playersDisplay.acceptedTumbo()

func notifyTumboIsRejected():
	notificationsManager.showMessage("Se achican")

func notifyCanNotMakeTheActionAfterTheGameEnded():
	notificationsManager.showMessage("No se puede hacer la acción porque la partida ya terminó.")

func notifyVidoCalledThisRoundAlready():
	notificationsManager.showMessage("No se puede llamar al vido porque ya se ha llamado en esta ronda.")

func returnToMenu():
	returnToMenuSignal.emit()

func notifyCurrentHandWinner(winnerPlayerId: String):
	playersDisplay.updateCurrentHandWinner(winnerPlayerId)
