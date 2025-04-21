class_name TenPlayersTriumphHierarchy extends TriumphHierarchy

var triumphHierarchy: Array[Dictionary] = [
  { "value": ValueEnum.Value._5, "suit": SuitEnum.Suit.OROS},
	{ "value": ValueEnum.Value._3, "suit": SuitEnum.Suit.BASTOS },
	{ "value": ValueEnum.Value.CABALLO, "suit": SuitEnum.Suit.BASTOS },
	{ "value": ValueEnum.Value.SOTA, "suit": SuitEnum.Suit.OROS },
]

func getTriumphHierarchy():
  return triumphHierarchy
