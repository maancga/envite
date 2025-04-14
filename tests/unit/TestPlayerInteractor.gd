class_name TestPlayerInteractor extends PlayerInteractor

var amountOfCallsFunction1 = 0
var idCallsFunction1: Array[String]
var amountOfCallsFunction2 = 0
var idCallsFunction2: Array[String]

func dealHandToPlayer(player: String, _hand: ServerHand) -> void:
    amountOfCallsFunction1+=1
    idCallsFunction1.append(player)

func informViradoToPlayer(player: String, _card: ServerCard) -> void:
    amountOfCallsFunction2+=1
    idCallsFunction2.append(player)

func dealHandToPlayersBeenCalled(amount: int):
    return amount == amountOfCallsFunction1

func calledPlayerIds(playerIds: Array[String]):
    return playerIds == idCallsFunction1

func informViradoToPlayerBeenCalled(amount: int):
    return amount == amountOfCallsFunction2

func calledPlayerIdsForVirado(playerIds: Array[String]):
    return playerIds == idCallsFunction1