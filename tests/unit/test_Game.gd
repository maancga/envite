extends "res://addons/gut/test.gd"

func test_starts_a_game_with_4_players_and_deals_to_the_4_players():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck, SixPlayersTriumphHierarchy.new())

	game.newGame()

	assert_true(spy.dealHandToPlayersBeenCalled(4))
	assert_true(spy.informViradoToPlayerBeenCalled((1)))


func test_notifies_players_in_the_given_order():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")
	
	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck, SixPlayersTriumphHierarchy.new())

	game.newGame()

	assert_true((spy.calledPlayerIds([
		"136122084",
		"552119499",
		"780900127",
		"721778859",
	])))

	
func test_assigns_dealer_to_first_player_on_new_game():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")
	
	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck, SixPlayersTriumphHierarchy.new())

	game.newGame()

	assert_true(spy.getLastDealer() == "721778859")

func test_assigns_first_turn_to_the_player_next_to_dealer_player_on_new_game():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")
	
	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck, SixPlayersTriumphHierarchy.new())

	game.newGame()

	assert_true(spy.getLastInformPlayerTurnCall() == "136122084")

func test_does_nothing_if_playing_player_is_not_current_turn_player():
	var players = GamePlayers.new()
	players.addPlayer("721778859", "Manu")
	players.addPlayer("136122084", "Atteneri")
	players.addPlayer("552119499", "Alexis")
	players.addPlayer("780900127", "Jose")
	
	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck, SixPlayersTriumphHierarchy.new())

	game.newGame()

	game.playFirstCard("721778859")
	assert_eq(spy.getLastInformPlayerTurnCall(), "136122084")

func test_partial_game():
	var players = GamePlayers.new()
	players.addPlayer("1", "Manu")      # Equipo 1
	players.addPlayer("2", "Atteneri")  # Equipo 2
	players.addPlayer("3", "Alexis")    # Equipo 1
	players.addPlayer("4", "Jose")      # Equipo 2

	var spy = TestPlayerInteractor.new()
	var deck = TestDeck.new()
	var game = Game.new(players, spy, deck, FourPlayersTriumphHierarchy.new())
	deck.setTopCards([
	# Jugador 2
	ServerCard.new(ValueEnum.Value.AS, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.OROS),

	# Jugador 3
	ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.ESPADAS),
	ServerCard.new(ValueEnum.Value._4, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.OROS),

	# Jugador 4
	ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.BASTOS), # la mala
	ServerCard.new(ValueEnum.Value._4, SuitEnum.Suit.OROS),

	# Jugador 1
	ServerCard.new(ValueEnum.Value._5, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.OROS),
	ServerCard.new(ValueEnum.Value._6, SuitEnum.Suit.OROS),

	# Virado
	ServerCard.new(ValueEnum.Value._7, SuitEnum.Suit.BASTOS),
	])
	game.newGame()

	# Sets the deck for after the round finishes the new deal is done correctly
	deck.setTopCards([
	# Jugador 3
	ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.OROS),
	ServerCard.new(ValueEnum.Value._7, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.BASTOS),

	# Jugador 4
	ServerCard.new(ValueEnum.Value.AS, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value._6, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.COPAS),

	# Jugador 1
	ServerCard.new(ValueEnum.Value._5, SuitEnum.Suit.OROS),
	ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value._6, SuitEnum.Suit.BASTOS),

	# Jugador 2
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.ESPADAS),
	ServerCard.new(ValueEnum.Value._4, SuitEnum.Suit.BASTOS),

	# Lo virado (carta 13)
	ServerCard.new(ValueEnum.Value._7, SuitEnum.Suit.OROS),
])

	# Lo virado es el 7 de bastos
	game.playFirstCard("2") # As de bastos
	game.playFirstCard("3") # Sota de espadas
	game.playFirstCard("4") # Sota de bastos
	game.playSecondCard("1") # 2 de oros
	# Gana jugador 4 - equipo 2
	game.playSecondCard("4") # 2 de bastos (la mala)
	game.playFirstCard("1") # 5 de bastos
	game.playSecondCard("2") # 2 de copas
	game.playSecondCard("3") # 4 de copas
	# Gana jugador 4 - equipo 2
	# Ya que el equipo 2 gana 2 rondas, ganan piedras.
	assert_eq(spy.team2PiedrasLastUpdate == 2, true)


	# Sets the deck for after the round finishes the new deal is done correctly
	deck.setTopCards([
	# Jugador 4
	ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.OROS),
	ServerCard.new(ValueEnum.Value._5, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._6, SuitEnum.Suit.COPAS),

	# Jugador 1
	ServerCard.new(ValueEnum.Value.AS, SuitEnum.Suit.COPAS),
	ServerCard.new(ValueEnum.Value._4, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._7, SuitEnum.Suit.OROS),

	# Jugador 2
	ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.ESPADAS),
	ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.COPAS),

	# Jugador 3
	ServerCard.new(ValueEnum.Value._6, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.BASTOS),
	ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.COPAS),

	# Virado
	ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.BASTOS),
])
	# Segunda ronda - reparte jugador 2, empiezan jugando desde el 3. Lo virado son oros.
	game.playSecondCard("3") # 7 de copas
	game.playFirstCard("4") # As de copas
	game.playFirstCard("1") # 5 de oros
	game.playSecondCard("2") # 2 de copas
	# Gana jugador 1 - equipo 1
	game.playSecondCard("1") # 3 de copas
	game.playThirdCard("2") # 3 de espadas
	game.playFirstCard("3") # 3 de oros
	game.playSecondCard("4") # 6 de copas
	# Gana jugador 3 - equipo 1 esta ronda, 2 rondas completas jugadas
	assert_eq(spy.team2PiedrasLastUpdate == 2, true)
	assert_eq(spy.team1PiedrasLastUpdate == 2, true)

	# Segunda ronda - reparte jugador 3, empiezan jugando desde el 4. Lo virado son bastos.
	game.playThirdCard("4") # 6 de copas
	game.playFirstCard("1") # As de copas
	game.playFirstCard("2") # 2 de bastos (la mala)
	game.playThirdCard("3") # caballo de copas
	# Gana jugador 2 - equipo 2
	game.playThirdCard("2") # 3 de copas
	game.playSecondCard("3") # 3 de bastos
	game.playSecondCard("4") # 5 de bastos
	game.playSecondCard("1") # 4 de bastos
	# Gana jugador 4 - equipo 2 esta ronda, 2 rondas completas jugadas
	assert_eq(spy.team2PiedrasLastUpdate == 4, true)
	assert_eq(spy.team1PiedrasLastUpdate == 2, true)
