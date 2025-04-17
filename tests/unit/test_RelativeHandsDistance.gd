extends "res://addons/gut/test.gd"

func test_relative_distance_0():
	var players: Array[String] = ["player1", "player2", "player3", "player4"]
	var currentPlayerId = "player2"
	var relative_distance = RelativeHandsDistance.new(players, currentPlayerId)
	
	assert_eq(relative_distance.calculateDistance("player2"), 0, "Distance to self should be 0")

func test_relative_distance_1():
	var players: Array[String] = ["player1", "player2", "player3", "player4"]
	var currentPlayerId = "player2"
	var relative_distance = RelativeHandsDistance.new(players, currentPlayerId)
	
	assert_eq(relative_distance.calculateDistance("player3"), 1, "Distance to next player should be 1")

func test_relative_distance_2():
	var players: Array[String] = ["player1", "player2", "player3", "player4"]
	var currentPlayerId = "player2"
	var relative_distance = RelativeHandsDistance.new(players, currentPlayerId)
	
	assert_eq(relative_distance.calculateDistance("player4"), 2, "Distance to second next player should be 2")

func test_relative_distance_3():
	var players: Array[String] = ["player1", "player2", "player3", "player4"]
	var currentPlayerId = "player2"
	var relative_distance = RelativeHandsDistance.new(players, currentPlayerId)
	
	assert_eq(relative_distance.calculateDistance("player1"), 3, "Distance to third next player should be 3")

func test_relative_distance_last_player():
	var players: Array[String] = ["player1", "player2", "player3", "player4"]
	var currentPlayerId = "player4"
	var relative_distance = RelativeHandsDistance.new(players, currentPlayerId)
	
	assert_eq(relative_distance.calculateDistance("player1"), 1, "Distance from last player to first should be 1")
	assert_eq(relative_distance.calculateDistance("player2"), 2, "Distance from last player to second should be 2")
	assert_eq(relative_distance.calculateDistance("player3"), 3, "Distance from last player to third should be 3")
	assert_eq(relative_distance.calculateDistance("player4"), 0, "Distance to self should be 0")
