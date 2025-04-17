extends "res://addons/gut/test.gd"

class TestDealerManager: extends GutTest

func test_gets_the_first_player_as_first_dealer():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")

	var spy = TestPlayerInteractor.new()

	var dealerManager = DealerManager.new(players, spy)

	assert_eq(dealerManager.getCurrentDealer(), "721778859")

func test_gets_the_second_player_as_second_dealer():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("721778860", "Pablo")

	var spy = TestPlayerInteractor.new()

	var dealerManager = DealerManager.new(players, spy)
	dealerManager.setNewDealer()

	assert_eq(dealerManager.getCurrentDealer(), "721778860")

func test_gets_the_third_player_as_third_dealer():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("721778860", "Pablo")
	players.addPlayer("721778861", "Javi")

	var spy = TestPlayerInteractor.new()

	var dealerManager = DealerManager.new(players, spy)
	dealerManager.setNewDealer()
	dealerManager.setNewDealer()

	assert_eq(dealerManager.getCurrentDealer(), "721778861")

func test_gets_the_first_player_as_dealer_when_everyone_has_dealt():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("721778860", "Pablo")
	players.addPlayer("721778861", "Javi")

	var spy = TestPlayerInteractor.new()

	var dealerManager = DealerManager.new(players, spy)
	dealerManager.setNewDealer()
	dealerManager.setNewDealer()
	dealerManager.setNewDealer()

	assert_eq(dealerManager.getCurrentDealer(), "721778859")

func test_gets_the_second_player_as_dealer_when_as_5th_dealer():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("721778860", "Pablo")
	players.addPlayer("721778861", "Javi")

	var spy = TestPlayerInteractor.new()

	var dealerManager = DealerManager.new(players, spy)
	dealerManager.setNewDealer()
	dealerManager.setNewDealer()
	dealerManager.setNewDealer()

	assert_eq(dealerManager.getCurrentDealer(), "721778859")