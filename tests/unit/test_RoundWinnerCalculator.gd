extends "res://addons/gut/test.gd"

func test_calculates_the_winner_for_the_highest_playable_round_with_4_players():
	var virado  =  ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.OROS)

	
	var tresDeBastos = ServerCard.new(ValueEnum.Value._3, SuitEnum.Suit.BASTOS)
	var onceDeBastos = ServerCard.new(ValueEnum.Value.CABALLO, SuitEnum.Suit.BASTOS)
	var diezDeOros = ServerCard.new(ValueEnum.Value.SOTA, SuitEnum.Suit.OROS)
	var dosDeCopas = ServerCard.new(ValueEnum.Value._2, SuitEnum.Suit.COPAS)

	var calculator = RoundWinnerCalculator.new(virado, tresDeBastos)

	var winner = calculator.calculateWinner({
		"player1": tresDeBastos,
		"player2": onceDeBastos,
		"player3": diezDeOros,
		"player4": dosDeCopas,
	})

	assert_eq(winner, "player1")
