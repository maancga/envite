extends "res://addons/gut/test.gd"

func getFixedTopCards() -> Array[ServerCard]:
	return [
	ServerCard.new(ValueEnum.Value.AS, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.OROS),

	ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.ESPADAS),
	ServerCard.new(ValueEnum.Value._4, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.OROS),

	ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._4, SuitEnum.Suit.OROS),

	ServerCard.new(ValueEnum.Value._5, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.OROS),
	ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.BASTOS),

	ServerCard.new(ValueEnum.Value._7, SuitEnum.Suit.BASTOS),
	]

func advancesGameUntilTeam2Tumbo():
	var players = GamePlayers.new()
	players.addPlayer("1", "Manu")      # Equipo 1
	players.addPlayer("2", "Atteneri")  # Equipo 2
	players.addPlayer("3", "Alexis")    # Equipo 1
	players.addPlayer("4", "Jose")      # Equipo 2

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck, FourPlayersTriumphHierarchy.new())
	deck.setTopCards(getFixedTopCards())
	game.newGame()
	deck.setTopCards(getFixedTopCards())

	game.playFirstCard("2") # As de bastos
	game.playFirstCard("3") # Sota de espadas
	game.playFirstCard("4") # Sota de bastos
	game.playSecondCard("1") # 2 de oros

	game.playSecondCard("4") # 2 de bastos (la mala)
	game.playFirstCard("1") # 5 de bastos
	game.playSecondCard("2") # 2 de copas
	game.playSecondCard("3") # 4 de copas
	assert_eq(spy.team2PiedrasLastUpdate == 2, true)
	deck.setTopCards(getFixedTopCards())

	game.playThirdCard("3") # Caballo de oros
	game.playThirdCard("4") # Rey de oros
	game.playThirdCard("1") # Cuatro de oros
	game.playSecondCard("2") # 2 de oros

	game.playFirstCard("4") # sota de espadas
	game.playFirstCard("1") # sota de bastos
	game.playThirdCard("2") # Rey de bastos
	game.playFirstCard("3") # as de bastos
	assert_eq(spy.team2PiedrasLastUpdate == 4, true)
	deck.setTopCards(getFixedTopCards())

	game.playFirstCard("4") # As de bastos
	game.playFirstCard("1") # Sota de espadas
	game.playFirstCard("2") # Sota de bastos
	game.playSecondCard("3") # 2 de oros

	game.playSecondCard("2") # 2 de bastos (la mala)
	game.playFirstCard("3") # 5 de bastos
	game.playSecondCard("4") # 2 de copas
	game.playSecondCard("1") # 4 de copas
	assert_eq(spy.team2PiedrasLastUpdate == 6, true)
	deck.setTopCards(getFixedTopCards())

	game.playThirdCard("1") # Caballo de oros
	game.playThirdCard("2") # Rey de oros
	game.playThirdCard("3") # Cuatro de oros
	game.playSecondCard("4") # 2 de oros

	game.playFirstCard("2") # sota de espadas
	game.playFirstCard("3") # sota de bastos
	game.playThirdCard("4") # Rey de bastos
	game.playFirstCard("1") # as de bastos
	assert_eq(spy.team2PiedrasLastUpdate == 8, true)
	deck.setTopCards(getFixedTopCards())

	game.playFirstCard("2") # As de bastos
	game.playFirstCard("3") # Sota de espadas
	game.playFirstCard("4") # Sota de bastos
	game.playSecondCard("1") # 2 de oros

	game.playSecondCard("4") # 2 de bastos (la mala)
	game.playFirstCard("1") # 5 de bastos
	game.playSecondCard("2") # 2 de copas
	game.playSecondCard("3") # 4 de copas
	assert_eq(spy.team2PiedrasLastUpdate == 10, true)
	deck.setTopCards(getFixedTopCards())

	game.playThirdCard("3") # Caballo de oros
	game.playThirdCard("4") # Rey de oros
	game.playThirdCard("1") # Cuatro de oros
	game.playSecondCard("2") # 2 de oros

	game.playFirstCard("4") # sota de espadas
	game.playFirstCard("1") # sota de bastos
	game.playThirdCard("2") # Rey de bastos
	game.playFirstCard("3") # as de bastos
	assert_eq(spy.team2PiedrasLastUpdate == 11, true)
	assert_eq(game.team2IsOnTumbo, true)

	assert_true(spy.informGameIsOnTumboCalls == 1)
	return [game, spy]

func test_gets_to_tumbo_takes_it_and_wins():
	var result = advancesGameUntilTeam2Tumbo()
	var game = result[0]
	var spy = result[1]

	game.takeTumbo("2")

	game.playFirstCard("4") # As de bastos
	game.playFirstCard("1") # Sota de espadas
	game.playFirstCard("2") # Sota de bastos
	game.playSecondCard("3") # 2 de oros

	game.playSecondCard("2") # 2 de bastos (la mala)
	game.playFirstCard("3") # 5 de bastos
	game.playSecondCard("4") # 2 de copas
	game.playSecondCard("1") # 4 de copas

	assert_true(spy.team2ChicosLastUpdate == 1)
	assert_eq(spy.team2PiedrasLastUpdate == 0, true)

func test_gets_to_tumbo_rejects_it_multiple_times():
	var result = advancesGameUntilTeam2Tumbo()
	var game: Game = result[0]
	var spy = result[1]

	print(game.gameState.getStateName())
	game.notTakeTumbo("2")

	print(game.gameState.getStateName())
	assert_eq(spy.team2PiedrasLastUpdate == 11, true)
	assert_eq(spy.team1PiedrasLastUpdate == 1, true)
	print(game.scoresManager.team1Score.piedras)

	game.notTakeTumbo("2")
	print(game.gameState.getStateName())


	assert_eq(spy.team2PiedrasLastUpdate == 11, true)
	assert_eq(spy.team1PiedrasLastUpdate == 2, true)

	game.notTakeTumbo("2")
	print(game.gameState.getStateName())


	assert_eq(spy.team2PiedrasLastUpdate == 11, true)
	assert_eq(spy.team1PiedrasLastUpdate == 3, true)
