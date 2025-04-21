class_name SixPlayersTriumphHierarchy extends TriumphHierarchy

var triumphHierarchy: Array[Dictionary] = [
	{ "value": ValueEnum.Value._3, "suit": SuitEnum.Suit.BASTOS },
	{ "value": ValueEnum.Value.CABALLO, "suit": SuitEnum.Suit.BASTOS },
	{ "value": ValueEnum.Value.SOTA, "suit": SuitEnum.Suit.OROS },
]

func getTriumphHierarchy():
  return triumphHierarchy
