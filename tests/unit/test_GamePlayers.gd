extends "res://addons/gut/test.gd"

func test_creates_two_teams_with_two_players_each():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")
	
	assert_eq(players.team1.players[0], "721778859")
	assert_eq(players.team1.players[1], "552119499")
	assert_eq(players.team2.players[0], "136122084")
	assert_eq(players.team2.players[1], "780900127")

func test_gets_the_team_from_a_player():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")
	
	assert_eq(players.getTeam("721778859"), "team1")
	assert_eq(players.getTeam("552119499"), "team1")
	assert_eq(players.getTeam("136122084"), "team2")
	assert_eq(players.getTeam("780900127"), "team2")


func test_removes_a_player_succesfully():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	players.removePlayer("721778859")
	assert_eq(players.playerIds.size(), 3)
	assert_eq(players.playersIdsMap.size(), 3)
	assert_eq(players.playerInstances.size(), 3)
	assert_eq(players.team1.players.size(), 1)
	assert_eq(players.team2.players.size(), 1)

