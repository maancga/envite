extends Control

class_name TeamPlayerList
var color: String = ""

func setTeamName(teamName):
	$TeamName.text = teamName
	
func setTeamColor1():
	color = "team1"
	
func setTeamColor2():
	color = "team2"
	
func addPlayer(playerName: String, isLeader: bool, isYou: bool):
	var control = Control.new()
	control.custom_minimum_size = Vector2(0, 50)
	var playerNameScene = preload("res://scenes/PlayerNameDisplay.tscn").instantiate()
	control.add_child(playerNameScene)
	playerNameScene.setPlayerName(playerName)
	if (isLeader): playerNameScene.convertToLeader()
	if isYou: playerNameScene.isPlayerTurn()
	if color == "team1": playerNameScene.setTeam1Color()
	if color == "team2": playerNameScene.setTeam2Color()
	$PlayerList.add_child(control)

func cleanPlayersList():
	for child in $PlayerList.get_children():
		child.queue_free()
