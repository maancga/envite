extends Node2D

signal nameChosenSignal(name)
signal startGameSignal()

@onready var userName = $ChooseNameControl/UserInput
@onready var team1PlayerList: TeamPlayerList = $Team1PlayersList
@onready var team2PlayerList: TeamPlayerList = $Team2PlayersList

func _ready() -> void:
	team1PlayerList.setTeamColor1()
	team1PlayerList.setTeamName("Equipo 1")
	team2PlayerList.setTeamColor2()
	team2PlayerList.setTeamName("Equipo 2")

func _on_ready_button_pressed() -> void:
	emit_signal("nameChosenSignal", userName.text)
	
func updateList(newPlayerId: String, newPlayers: Dictionary, newTeam1: Array[String], newTeam2: Array[String], team1Leader: String, team2Leader: String):
	cleanPlayersLists()
	var playersArray = []
	for player in newPlayers.keys():
		playersArray.append(player)
	for player in playersArray:
		var currentPlayer = newPlayers[player]
		var playerName = currentPlayer["name"]
		var isLeader = (player == team1Leader) || (player == team2Leader)
		var isYou = newPlayerId == player
		if player in newTeam1 : 
			team1PlayerList.addPlayer(playerName, isLeader, isYou)
		if player in newTeam2 : 
			team2PlayerList.addPlayer(playerName, isLeader, isYou)
		
func cleanPlayersLists():
	team1PlayerList.cleanPlayersList()
	team2PlayerList.cleanPlayersList()


func _on_start_game_button_pressed() -> void:
	startGameSignal.emit()
