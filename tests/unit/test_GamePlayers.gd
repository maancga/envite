extends "res://addons/gut/test.gd"

func test_creates_two_teams_with_two_players_each():
	var players = GamePlayers.new()
	players.addPlayer("721778859")
	players.addPlayer("136122084")
	players.addPlayer("552119499")
	players.addPlayer("780900127")
	
	assert_eq(players.team1.players[0], "721778859")
	assert_eq(players.team1.players[1], "552119499")
	assert_eq(players.team2.players[0], "136122084")
	assert_eq(players.team2.players[1], "780900127")
