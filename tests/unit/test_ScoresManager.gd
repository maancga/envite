extends "res://addons/gut/test.gd"

var teamsRoundsParameters = [
		[[0, 0], [0, 0]],
		[[0, 0], [1, 2]],
		[[0, 0], [2, 4]],
		[[0, 0], [3, 6]],
		[[0, 0], [4, 8]],
		[[0, 0], [5, 10]],
		[[1, 2], [0, 0]],
		[[1, 2], [1, 2]],
		[[1, 2], [2, 4]],
		[[1, 2], [3, 6]],
		[[1, 2], [4, 8]],
		[[1, 2], [5, 10]],
		[[2, 4], [0, 0]],
		[[2, 4], [1, 2]],
		[[2, 4], [2, 4]],
		[[2, 4], [3, 6]],
		[[2, 4], [4, 8]],
		[[2, 4], [5, 10]],
		[[3, 6], [0, 0]],
		[[3, 6], [1, 2]],
		[[3, 6], [2, 4]],
		[[3, 6], [3, 6]],
		[[3, 6], [4, 8]],
		[[3, 6], [5, 10]],
		[[4, 8], [0, 0]],
		[[4, 8], [1, 2]],
		[[4, 8], [2, 4]],
		[[4, 8], [3, 6]],
		[[4, 8], [4, 8]],
		[[4, 8], [5, 10]],
		[[5, 10], [0, 0]],
		[[5, 10], [1, 2]],
		[[5, 10], [2, 4]],
		[[5, 10], [3, 6]],
		[[5, 10], [4, 8]],
		[[5, 10], [5, 10]]
	]
	
func test_the_amount_of_rounds_of_both_teams_have_won_with_scores(params=use_parameters(teamsRoundsParameters)):
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)

	var team1WonRounds = params[0][0]
	var team1Piedras  = params[0][1]
	var team2WonRounds = params[1][0]
	var team2Piedras  = params[1][1]
	
	for _currentWonRound in team1WonRounds:
		scoresManager.teamOneWinsRound()
	for _currentWonRound in team2WonRounds:
		scoresManager.teamTwoWinsRound()

	assert_eq(scoresManager.team1HasPiedras(team1Piedras), true)
	assert_eq(scoresManager.team2HasPiedras(team2Piedras), true)
	assert_eq(scoresManager.team1HasChicos(0), true)
	assert_eq(scoresManager.team2HasChicos(0), true)

func test_that_when_team1_summs_12_piedras_it_stays_at_11_piedras_and_is_on_tumbo():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 5:
		scoresManager.teamOneWinsRound()

	scoresManager.teamOneWinsRound()

	assert_eq(scoresManager.team1HasPiedras(11), true)
	assert_eq(scoresManager.team2HasPiedras(0), true)
	assert_eq(scoresManager.team1HasChicos(0), true)
	assert_eq(scoresManager.team2HasChicos(0), true)
	assert_eq(scoresManager.team1IsOnTumbo(), true)
	assert_eq(scoresManager.team2IsOnTumbo(), false)

func test_if_team1_wins_7_rounds_wins_a_chico():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 7:
		scoresManager.teamOneWinsRound()

	assert_eq(scoresManager.team1HasPiedras(0), true)
	assert_eq(scoresManager.team2HasPiedras(0), true)
	assert_eq(scoresManager.team1HasChicos(1), true)
	assert_eq(scoresManager.team2HasChicos(0), true)
	assert_eq(scoresManager.team1IsOnTumbo(), false)
	assert_eq(scoresManager.team2IsOnTumbo(), false)


func test_that_when_team2_summs_12_piedras_it_stays_at_11_piedras_and_is_on_tumbo():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 5:
		scoresManager.teamTwoWinsRound()

	scoresManager.teamTwoWinsRound()

	assert_eq(scoresManager.team1HasPiedras(0), true)
	assert_eq(scoresManager.team2HasPiedras(11), true)
	assert_eq(scoresManager.team1HasChicos(0), true)
	assert_eq(scoresManager.team2HasChicos(0), true)
	assert_eq(scoresManager.team1IsOnTumbo(), false)
	assert_eq(scoresManager.team2IsOnTumbo(), true)

func test_if_team2_wins_7_rounds_wins_a_chico():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 7:
		scoresManager.teamTwoWinsRound()

	assert_eq(scoresManager.team1HasPiedras(0), true)
	assert_eq(scoresManager.team2HasPiedras(0), true)
	assert_eq(scoresManager.team1HasChicos(0), true)
	assert_eq(scoresManager.team2HasChicos(1), true)
	assert_eq(scoresManager.team1IsOnTumbo(), false)
	assert_eq(scoresManager.team2IsOnTumbo(), false)

func test_if_team_2_wins_when_team_1_is_on_tumbo_it_wins_3_piedras():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 6:
		scoresManager.teamOneWinsRound()
	
	scoresManager.teamTwoWinsRound()


	assert_eq(scoresManager.team1HasPiedras(11), true)
	assert_eq(scoresManager.team2HasPiedras(3), true)

func test_if_team_2_wins_2_rounds_when_team_1_is_on_tumbo_it_wins_6_piedras():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 6:
		scoresManager.teamOneWinsRound()
	
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()


	assert_eq(scoresManager.team1HasPiedras(11), true)
	assert_eq(scoresManager.team2HasPiedras(6), true)

func test_if_team_2_wins_3_rounds_when_team_1_is_on_tumbo_it_wins_9_piedras():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 6:
		scoresManager.teamOneWinsRound()
	
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()


	assert_eq(scoresManager.team1HasPiedras(11), true)
	assert_eq(scoresManager.team2HasPiedras(9), true)

func test_if_team_2_wins_4_rounds_when_team_1_is_on_tumbo_it_wins_11_piedras_and_both_are_on_tumbo():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 6:
		scoresManager.teamOneWinsRound()
	
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()


	assert_eq(scoresManager.team1HasPiedras(11), true)
	assert_eq(scoresManager.team1IsOnTumbo(), true)
	assert_eq(scoresManager.team2HasPiedras(11), true)
	assert_eq(scoresManager.team2IsOnTumbo(), true)

func test_if_team1_wins_when_both_are_on_tumbo_wins_chico():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 6:
		scoresManager.teamOneWinsRound()
	
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()

	scoresManager.teamOneWinsRound()

	assert_eq(scoresManager.team1HasPiedras(0), true)
	assert_eq(scoresManager.team1HasChicos(1), true)
	assert_eq(scoresManager.team2HasPiedras(0), true)
	assert_eq(scoresManager.team2HasChicos(0), true)

func test_if_team2_wins_when_both_are_on_tumbo_wins_chico():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 6:
		scoresManager.teamOneWinsRound()
	
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()
	scoresManager.teamTwoWinsRound()

	scoresManager.teamTwoWinsRound()

	assert_eq(scoresManager.team1HasPiedras(0), true)
	assert_eq(scoresManager.team1HasChicos(0), true)
	assert_eq(scoresManager.team2HasPiedras(0), true)
	assert_eq(scoresManager.team2HasChicos(1), true)

func test_if_teams_win_a_round_after_winning_a_chico_still_win_2_piedras():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 7:
		scoresManager.teamOneWinsRound()

	scoresManager.teamOneWinsRound()
	scoresManager.teamTwoWinsRound()


	assert_eq(scoresManager.team1HasPiedras(2), true)
	assert_eq(scoresManager.team1HasChicos(1), true)
	assert_eq(scoresManager.team2HasPiedras(2), true)
	assert_eq(scoresManager.team2HasChicos(0), true)


func test_team2_wins_a_point_when_team1_is_on_tumbo_and_rejects_the_tumbo():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 6:
		scoresManager.teamOneWinsRound()

	scoresManager.teamOneRejectsTumbo()

	assert_eq(scoresManager.team1HasPiedras(11), true)
	assert_eq(scoresManager.team2HasPiedras(1), true)


func test_team1_wins_a_point_when_team2_is_on_tumbo_and_rejects_the_tumbo():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 6:
		scoresManager.teamTwoWinsRound()

	scoresManager.teamTwoRejectsTumbo()

	assert_eq(scoresManager.team1HasPiedras(1), true)
	assert_eq(scoresManager.team2HasPiedras(11), true)

func test_team1_wins_4_points_when_team2_is_on_tumbo_and_rejects_the_tumbo_and_team1_wins_round():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var scoresManager = ScoresManager.new(TestPlayerInteractor.new(), players)
	
	for _currentWonRound in 6:
		scoresManager.teamTwoWinsRound()

	scoresManager.teamTwoRejectsTumbo()
	scoresManager.teamOneWinsRound()

	assert_eq(scoresManager.team1HasPiedras(4), true)
	assert_eq(scoresManager.team2HasPiedras(11), true)
