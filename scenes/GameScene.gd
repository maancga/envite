extends Node2D

@onready var hand = $MyHand
@onready var selectedCardLabel = $"Carta seleccionada"
@onready var cardShuffler=$CardShuffler
@onready var virado= $Virado/Card
@onready var viradoLabel = $Virado/ViradoLabel
@onready var playerName = $PlayerName
@onready var turnLabel = $TurnLabel
@onready var playedCards = $"4PlayersPlayedCards"
@onready var team1LabelTopLabel = $Team1Score/TopLabel
@onready var team2LabelTopLabel = $Team2Score/TopLabel
@onready var team1GameChicosScore = $Team1Score/GameChicosScore
@onready var team2GameChicosScore = $Team2Score/GameChicosScore
@onready var team1ChicoPointsScore = $Team1Score/ChicoPointsScore
@onready var team2ChicoPointsScore = $Team2Score/ChicoPointsScore
@onready var team1RoundScore = $Team1Score/RoundScore
@onready var team2RoundScore = $Team2Score/RoundScore

var playerId : String
var currentPlayerTurnId: String
var players : Dictionary
var team1 : Array[String]
var team2 : Array[String]

var selectedCard: Card = null
signal playedCard(card)

func _ready() -> void:
	connectClickedCards()
	cleanCards()

func cleanCards():
	playedCards.get_node("firstCard/PlayerNameLabel").text = ""
	playedCards.get_node("secondCard/PlayerNameLabel").text = ""
	playedCards.get_node("thirdCard/PlayerNameLabel").text = ""
	playedCards.get_node("fourthCard/PlayerNameLabel").text = ""
	playedCards.get_node("firstCard/CardImage").texture = null
	playedCards.get_node("secondCard/CardImage").texture = null
	playedCards.get_node("thirdCard/CardImage").texture = null
	playedCards.get_node("fourthCard/CardImage").texture = null


func cleanTeamLabels():
	team1LabelTopLabel.text = "Equipo 1"
	team2LabelTopLabel.text = "Equipo 2"


func connectClickedCards() -> void:
	hand.card1.clickedCard.connect(onCardClicked)
	hand.card2.clickedCard.connect(onCardClicked)
	hand.card3.clickedCard.connect(onCardClicked)

func setCards(card1: CardData, card2: CardData, card3: CardData):
	hand.setInitialCards(card1, card2, card3)
	connectClickedCards()

func setVirado(card: CardData):
	virado.suit = card.suit
	virado.value = card.value
	virado.update_texture()
	viradoLabel.text =  "Virado: %s" % [virado.getSuitName() ]

func setInitialCards(card1: CardData, card2: CardData, card3: CardData, viradoCard: CardData,):
	setCards(card1, card2, card3)
	setVirado(viradoCard)

	
func setUpScene(newPlayerName: String, newPlayerId: String, newPlayers: Dictionary, newTeam1: Array[String], newTeam2: Array[String]):
	playerName.text = newPlayerName
	playerId = newPlayerId
	players = newPlayers
	team1 = newTeam1
	team2 = newTeam2

func onCardClicked(clickedCard: Card):
	selectedCard = clickedCard
	selectedCardLabel.text =  "Carta seleccionada: %s" % [selectedCard.getCardName() ]

func playCard():
	if selectedCard == hand.card1: playedCard.emit("1")
	if selectedCard == hand.card2: playedCard.emit("2")
	if selectedCard == hand.card3: playedCard.emit("3")


func _on_play_card_button_pressed() -> void:
	if !selectedCard: return
	if not isYourTurn(): return 
	print("played card! " + selectedCard.getCardName())
	playCard()
	hand.playCard(selectedCard)
	selectedCard = null

func isYourTurn():
	return currentPlayerTurnId == playerId
	
func setPlayerTurn(newPlayerId: String):
	currentPlayerTurnId = newPlayerId
	if(isYourTurn()): turnLabel.text = "Es tu turno!" 
	else: turnLabel.text = "No es tu turno =(" 

func addPlayedCard(player: Dictionary, card: Dictionary, playedOrder: int):
	if (playedOrder == 1):
		var node = playedCards.get_node("firstCard")
		node.get_node("PlayerNameLabel").text = player["name"]
		node.set_card_data(card["value"], card["suit"], node.position )
	if (playedOrder == 2): 
		var node = playedCards.get_node("secondCard")
		node.get_node("PlayerNameLabel").text = player["name"]
		node.set_card_data(card["value"], card["suit"], node.position )
	if (playedOrder == 3):
		var node = playedCards.get_node("thirdCard")
		node.get_node("PlayerNameLabel").text = player["name"]
		node.set_card_data(card["value"], card["suit"], node.position )
	if (playedOrder == 4):
		var node = playedCards.get_node("fourthCard")
		node.get_node("PlayerNameLabel").text = player["name"]
		node.set_card_data(card["value"], card["suit"], node.position )

func getTeam(player: String) -> String:
	if player in team1: return "team1"
	if player in team2: return "team2"
	return "unknown"

func playerWonRound(player: String,  roundScore: int):
	print("Player %s won the round!" % [players[player]["name"]])
	if getTeam(player) == "team1": team1RoundScore.text = str(roundScore)
	if getTeam(player) == "team2": team2RoundScore.text = str(roundScore)
	await get_tree().create_timer(2.0).timeout
	cleanCards()

func teamWonChicoPoints(teamName: String, chicoPoints: int):
	print("Team %s won chico points!" % [teamName])
	if teamName == "team1": team1ChicoPointsScore.text = str(chicoPoints)
	if teamName == "team2": team2ChicoPointsScore.text = str(chicoPoints)
	await get_tree().create_timer(2.0).timeout
	cleanCards()
	resetRoundScore()

func resetRoundScore():
	team1RoundScore.text = "0"
	team2RoundScore.text = "0"


func teamWonChico(teamName: String, chicosScore: int):
	print("Team %s won a chico!" % [teamName])
	if teamName == "team1": team1GameChicosScore.text = str(chicosScore)
	if teamName == "team2": team2GameChicosScore.text = str(chicosScore)
	await get_tree().create_timer(2.0).timeout
	cleanCards()
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
	cleanCards()
