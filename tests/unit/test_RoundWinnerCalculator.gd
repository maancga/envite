extends "res://addons/gut/test.gd"

func test_calculates_the_winner_for_the_highest_playable_round_with_6_players():
	var virado = ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.COPAS)

	var tresDeBastos =	ServerHandCard.new(ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.BASTOS), 1)
	var onceDeBastos = ServerHandCard.new(ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.BASTOS), 2)
	var diezDeOros = ServerHandCard.new(ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.OROS), 3)
	var dosDeCopas = ServerHandCard.new(ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS), 4)
	var reyDeCopas = ServerHandCard.new(ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.COPAS), 5)
	var caballoDeCopas = ServerHandCard.new(ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.COPAS), 6)

	var calculator = RoundWinnerCalculator.new(virado, tresDeBastos)

	var winner = calculator.calculateWinner({
		"player1": tresDeBastos,
		"player2": onceDeBastos,
		"player3": diezDeOros,
		"player4": dosDeCopas,
		"player5": reyDeCopas,
		"player6": caballoDeCopas
	})

	assert_eq(winner, "player1")

func test_calculates_the_winner_for_only_virado_cards_round_with_6_players():
	var virado = ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.COPAS)

	var cincoDeCopas = ServerHandCard.new(ServerCard.new(ValueEnum.Value._5, SuitEnum.Suit.COPAS), 1)
	var caballoDeCopas = ServerHandCard.new(ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.COPAS), 2)
	var diezDeCopas = ServerHandCard.new(ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.COPAS), 3)
	var dosDeCopas = ServerHandCard.new(ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS), 4)
	var reyDeCopas = ServerHandCard.new(ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.COPAS), 5)
	var asDeCopas = ServerHandCard.new(ServerCard.new(ValueEnum.Value.AS, SuitEnum.Suit.COPAS), 6)

	var calculator = RoundWinnerCalculator.new(virado, cincoDeCopas)

	var winner = calculator.calculateWinner({
		"player1": cincoDeCopas,
		"player2": caballoDeCopas,
		"player3": diezDeCopas,
		"player4": dosDeCopas,
		"player5": reyDeCopas,
		"player6": asDeCopas
	})

	assert_eq(winner, "player4")


func test_case_3():
	var virado = ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS)

	var reyDeOros = ServerHandCard.new(ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.OROS), 1)
	var sotaDeOros = ServerHandCard.new(ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.OROS), 2)
	var caballoDeEspadas = ServerHandCard.new(ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.ESPADAS), 3)
	var tresDeOros = ServerHandCard.new(ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.OROS), 4)

	var calculator = RoundWinnerCalculator.new(virado, reyDeOros)

	var winner = calculator.calculateWinner({
		"player1": reyDeOros,
		"player2": sotaDeOros,
		"player3": caballoDeEspadas,
		"player4": tresDeOros,
	})

	assert_eq(winner, "player2")
