extends "res://addons/gut/test.gd"
const pathResolver = preload("res://cards/CardSpritePathResolver.gd")

var bastosParameters = [
		[
			SuitEnum.Suit.BASTOS,
			ValueEnum.Value.AS,
			"res://cards/images/cards/card_bastos_0.png"
		],
		[
			SuitEnum.Suit.BASTOS,
			ValueEnum.Value._2,
			"res://cards/images/cards/card_bastos_1.png"
		],[
			SuitEnum.Suit.BASTOS,
			ValueEnum.Value._3,
			"res://cards/images/cards/card_bastos_2.png"
		],[
			SuitEnum.Suit.BASTOS,
			ValueEnum.Value._4,
			"res://cards/images/cards/card_bastos_3.png"
		],[
			SuitEnum.Suit.BASTOS,
			ValueEnum.Value._5,
			"res://cards/images/cards/card_bastos_4.png"
		],[
			SuitEnum.Suit.BASTOS,
			ValueEnum.Value._6,
			"res://cards/images/cards/card_bastos_5.png"
		],
		[
			SuitEnum.Suit.BASTOS,
			ValueEnum.Value._7,
			"res://cards/images/cards/card_bastos_6.png"
		],
		[
			SuitEnum.Suit.BASTOS,
			ValueEnum.Value.SOTA,
			"res://cards/images/cards/card_bastos_7.png"
		],
			[
			SuitEnum.Suit.BASTOS,
			ValueEnum.Value.CABALLO,
			"res://cards/images/cards/card_bastos_8.png"
		],	[
			SuitEnum.Suit.BASTOS,
			ValueEnum.Value.REY,
			"res://cards/images/cards/card_bastos_9.png"
		],
	]
	
var orosParameters = [
		[
			SuitEnum.Suit.OROS,
			ValueEnum.Value.AS,
			"res://cards/images/cards/card_oro_0.png"
		],
		[
			SuitEnum.Suit.OROS,
			ValueEnum.Value._2,
			"res://cards/images/cards/card_oro_1.png"
		],[
			SuitEnum.Suit.OROS,
			ValueEnum.Value._3,
			"res://cards/images/cards/card_oro_2.png"
		],[
			SuitEnum.Suit.OROS,
			ValueEnum.Value._4,
			"res://cards/images/cards/card_oro_3.png"
		],[
			SuitEnum.Suit.OROS,
			ValueEnum.Value._5,
			"res://cards/images/cards/card_oro_4.png"
		],[
			SuitEnum.Suit.OROS,
			ValueEnum.Value._6,
			"res://cards/images/cards/card_oro_5.png"
		],
		[
			SuitEnum.Suit.OROS,
			ValueEnum.Value._7,
			"res://cards/images/cards/card_oro_6.png"
		],
		[
			SuitEnum.Suit.OROS,
			ValueEnum.Value.SOTA,
			"res://cards/images/cards/card_oro_7.png"
		],
			[
			SuitEnum.Suit.OROS,
			ValueEnum.Value.CABALLO,
			"res://cards/images/cards/card_oro_8.png"
		],	[
			SuitEnum.Suit.OROS,
			ValueEnum.Value.REY,
			"res://cards/images/cards/card_oro_9.png"
		],
	]
	
var copasParameters = [
		[
			SuitEnum.Suit.COPAS,
			ValueEnum.Value.AS,
			"res://cards/images/cards/card_copas_0.png"
		],
		[
			SuitEnum.Suit.COPAS,
			ValueEnum.Value._2,
			"res://cards/images/cards/card_copas_1.png"
		],[
			SuitEnum.Suit.COPAS,
			ValueEnum.Value._3,
			"res://cards/images/cards/card_copas_2.png"
		],[
			SuitEnum.Suit.COPAS,
			ValueEnum.Value._4,
			"res://cards/images/cards/card_copas_3.png"
		],[
			SuitEnum.Suit.COPAS,
			ValueEnum.Value._5,
			"res://cards/images/cards/card_copas_4.png"
		],[
			SuitEnum.Suit.COPAS,
			ValueEnum.Value._6,
			"res://cards/images/cards/card_copas_5.png"
		],
		[
			SuitEnum.Suit.COPAS,
			ValueEnum.Value._7,
			"res://cards/images/cards/card_copas_6.png"
		],
		[
			SuitEnum.Suit.COPAS,
			ValueEnum.Value.SOTA,
			"res://cards/images/cards/card_copas_7.png"
		],
			[
			SuitEnum.Suit.COPAS,
			ValueEnum.Value.CABALLO,
			"res://cards/images/cards/card_copas_8.png"
		],	[
			SuitEnum.Suit.COPAS,
			ValueEnum.Value.REY,
			"res://cards/images/cards/card_copas_9.png"
		],
	]
	
var espadasParameters = [
		[
			SuitEnum.Suit.ESPADAS,
			ValueEnum.Value.AS,
			"res://cards/images/cards/card_espadas_0.png"
		],
		[
			SuitEnum.Suit.ESPADAS,
			ValueEnum.Value._2,
			"res://cards/images/cards/card_espadas_1.png"
		],[
			SuitEnum.Suit.ESPADAS,
			ValueEnum.Value._3,
			"res://cards/images/cards/card_espadas_2.png"
		],[
			SuitEnum.Suit.ESPADAS,
			ValueEnum.Value._4,
			"res://cards/images/cards/card_espadas_3.png"
		],[
			SuitEnum.Suit.ESPADAS,
			ValueEnum.Value._5,
			"res://cards/images/cards/card_espadas_4.png"
		],[
			SuitEnum.Suit.ESPADAS,
			ValueEnum.Value._6,
			"res://cards/images/cards/card_espadas_5.png"
		],
		[
			SuitEnum.Suit.ESPADAS,
			ValueEnum.Value._7,
			"res://cards/images/cards/card_espadas_6.png"
		],
		[
			SuitEnum.Suit.ESPADAS,
			ValueEnum.Value.SOTA,
			"res://cards/images/cards/card_espadas_7.png"
		],
			[
			SuitEnum.Suit.ESPADAS,
			ValueEnum.Value.CABALLO,
			"res://cards/images/cards/card_espadas_8.png"
		],	[
			SuitEnum.Suit.ESPADAS,
			ValueEnum.Value.REY,
			"res://cards/images/cards/card_espadas_9.png"
		],
]

func test_checks_bastos_sprite_path_is_resolved_correctly(params=use_parameters(bastosParameters)):
	var newPathResolver = pathResolver.new()
	var path = newPathResolver.resolve(params[0], params[1])
	assert_eq(path, params[2])
	
func test_checks_oros_sprite_path_is_resolved_correctly(params=use_parameters(orosParameters)):
	var newPathResolver = pathResolver.new()
	var path = newPathResolver.resolve(params[0], params[1])
	assert_eq(path, params[2])
	
func test_checks_copas_sprite_path_is_resolved_correctly(params=use_parameters(copasParameters)):
	var newPathResolver = pathResolver.new()
	var path = newPathResolver.resolve(params[0], params[1])
	assert_eq(path, params[2])
	
func test_checks_espadas_sprite_path_is_resolved_correctly(params=use_parameters(espadasParameters)):
	var newPathResolver = pathResolver.new()
	var path = newPathResolver.resolve(params[0], params[1])
	assert_eq(path, params[2])
