extends Node2D

@onready var hand = $FourPlayersHandsDisplay/MyHand
@onready var virado = $Virado/Card
@onready var team1LabelTopLabel = $Team1Score/TopLabel
@onready var team2LabelTopLabel = $Team2Score/TopLabel
@onready var team1GameChicosScore = $Team1Score/GameChicosScore
@onready var team2GameChicosScore = $Team2Score/GameChicosScore
@onready var team1ChicoPointsScore = $Team1Score/ChicoPointsScore
@onready var team2ChicoPointsScore = $Team2Score/ChicoPointsScore
@onready var team1RoundScore = $Team1Score/RoundScore
@onready var team2RoundScore = $Team2Score/RoundScore
@onready var team1Score = $Team1Score
@onready var team2Score = $Team2Score
@onready var playersDisplay: FourPlayersHandsDisplay = $FourPlayersHandsDisplay
@onready var playerCalledVidoLabel: Label = $PlayerCalledVidoLabel

signal vidoCalledSignal()
signal vidoAcceptedSignal()
signal vidoRejectedSignal()
signal vidoRaisedSignal()

var playerId : String
var currentPlayerTurnId: String
var players : Dictionary
var team1 : Array[String]
var team2 : Array[String]
var currentDealerId: String

func _ready() -> void:
	setTeamLabels()
	playersDisplay.connect("vidoCalledSignal", Callable(self, "onVidoCalled"))
	playersDisplay.connect("vidoAcceptedSignal", Callable(self, "onVidoAccepted"))
	playersDisplay.connect("vidoRejectedSignal", Callable(self, "onVidoRejected"))
	playersDisplay.connect("vidoRaisedSignal", Callable(self, "onVidoRaised"))

func setVirado(card: CardData):
	virado.suit = card.suit
	virado.value = card.value
	virado.update_texture()

func setCards(card1: CardData, card2: CardData, card3: CardData):
	playersDisplay.setHands(card1, card2, card3)

func setTeamLabels():
	team1Score.setTeam1Color()
	team2Score.setTeam2Color()
	team1LabelTopLabel.text = "Equipo 1"
	team2LabelTopLabel.text = "Equipo 2"

func setUpScene(newPlayerId: String, newPlayers: Dictionary, newTeam1: Array[String], newTeam2: Array[String], team1Leader: String, team2Leader: String):
	playersDisplay.setUp(newPlayerId, currentPlayerTurnId, newPlayers, team1Leader, team2Leader, newTeam1, newTeam2)
	playerId = newPlayerId
	players = newPlayers
	team1 = newTeam1
	team2 = newTeam2

	
func setPlayerTurn(newPlayerId: String):
	playersDisplay.setTurnTo(newPlayerId)

func addPlayedCard(player: String, card: Dictionary, cardHandIndex: int):
	playersDisplay.addPlayedCard(player, card, cardHandIndex)

func getTeam(player: String) -> String:
	if player in team1: return "team1"
	if player in team2: return "team2"
	return "unknown"

func playerWonRound(player: String,  roundScore: int):
	print("Player %s won the round!" % [players[player]["name"]])
	if getTeam(player) == "team1": team1RoundScore.text = str(roundScore)
	if getTeam(player) == "team2": team2RoundScore.text = str(roundScore)
	await get_tree().create_timer(2.0).timeout
	playersDisplay.cleanPlayedCards()

func teamWonChicoPoints(teamName: String, chicoPoints: int):
	print("Team %s won chico points!" % [teamName])
	if teamName == "team1": team1ChicoPointsScore.text = str(chicoPoints)
	if teamName == "team2": team2ChicoPointsScore.text = str(chicoPoints)
	await get_tree().create_timer(2.0).timeout
	resetRoundScore()

func resetRoundScore():
	team1RoundScore.text = "0"
	team2RoundScore.text = "0"


func teamWonChico(teamName: String, chicosScore: int):
	print("Team %s won a chico!" % [teamName])
	if teamName == "team1": team1GameChicosScore.text = str(chicosScore)
	if teamName == "team2": team2GameChicosScore.text = str(chicosScore)
	await get_tree().create_timer(2.0).timeout
	resetChicoPointsScore()

func resetChicoPointsScore():
	team1ChicoPointsScore.text = "0"
	team2ChicoPointsScore.text = "0"
	resetRoundScore()

func teamWon(teamName: String):
	print("Team %s won!" % [teamName])
	if teamName == "team1": team1LabelTopLabel.text = "EQUIPO 1 GANÓ"
	if teamName == "team2": team2LabelTopLabel.text = "EQUIPO 2 GANADOR"
	await get_tree().create_timer(2.0).timeout

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
