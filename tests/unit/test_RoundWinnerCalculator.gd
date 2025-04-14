extends "res://addons/gut/test.gd"

func test_calculates_the_winner_for_the_highest_playable_round_with_6_players():
	var virado  =  ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.COPAS)

	var tresDeBastos = ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.BASTOS)
	var onceDeBastos = ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.BASTOS)
	var diezDeOros = ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.OROS)
	var dosDeCopas = ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS)
	var reyDeCopas = ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.COPAS)
	var caballoDeCopas = ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.COPAS)

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
	var virado  =  ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.COPAS)

	var cincoDeCopas = ServerCard.new(ValueEnum.Value._5, SuitEnum.Suit.COPAS)
	var caballoDeCopas = ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.COPAS)
	var diezDeCopas = ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.COPAS)
	var dosDeCopas = ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS)
	var reyDeCopas = ServerCard.new(ValueEnum.Value.REY, SuitEnum.Suit.COPAS)
	var asDeCopas = ServerCard.new(ValueEnum.Value.AS, SuitEnum.Suit.COPAS)

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
