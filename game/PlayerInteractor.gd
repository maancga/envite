extends Node

class_name PlayerInteractor

func informPlayersAndTeams(_players: Dictionary) -> void:
	push_error("⚠️ informPlayersAndTeams() must be implemented by subclass")

func informPlayerAdded(_players: Dictionary) -> void:
	push_error("⚠️ informPlayerAdded() must be implemented by subclass")

func informTriumphsConfiguration(_triumph: TriumphHierarchy) -> void:
	push_error("⚠️ informTriumphsConfiguration() must be implemented by subclass")

func informPlayerCantBeAddedSinceMaxIsReached():
	push_error("⚠️ informPlayerCantBeAddedSinceMaxIsReached() must be implemented by subclass")

func informGameCanNotStartSinceTheMinimumOfPlayersIsNotReached(_playerId: String):
	push_error("⚠️ informGameCanNotStartSinceTheMinimumOfPlayersIsNotReached() must be implemented by subclass")

func informGameCanNotStartSinceItsNotOwner(_player: String):
	push_error("⚠️ informGameCanNotStartSinceItsNotOwner() must be implemented by subclass")

func informIsGameOwner(_playerId: String):
	push_error("⚠️ informIsGameOwner() must be implemented by subclass")

func dealHandToPlayer(_player: String, _hand: ServerHand) -> void:
	push_error("⚠️ dealHandToPlayer() must be implemented by subclass")

func informVirado(_card: ServerCard) -> void:
	push_error("⚠️ informVirado() must be implemented by subclass")

func informPlayerTurn(_player: String) -> void:
	push_error("⚠️ informPlayerTurn() must be implemented by subclass")

func informPlayerPlayedCard(_player: String, _card: ServerHandCard, _playedOrder: int) -> void:
	push_error("⚠️ informPlayerPlayedCard() must be implemented by subclass")

func informPlayerCouldNotPlayCardBecauseItsNotTurn(_player: String) -> void:
	push_error("⚠️ informPlayerCouldNotPlayCardBecauseItsNotTurn() must be implemented by subclass")

func informPlayerCouldNotPlayCardBacauseHasPlayedAlreadyInCurrentHand(_player: String)-> void:
	push_error("⚠️ informPlayerCouldNotPlayCardBacauseHasPlayedAlreadyInCurrentHand() must be implemented by subclass")

func informPlayerCouldNotPlayCardBecauseItsPlayedAlready(_player: String)-> void:
	push_error("⚠️ informPlayerCouldNotPlayCardBecauseItsPlayedAlready() must be implemented by subclass")

func informPlayerCouldNotPlayCardBecauseItsVido(_player: String)-> void:
	push_error("⚠️ informPlayerCouldNotPlayCardBecauseItsVido() must be implemented by subclass")

func informPlayerRefusedVido(_player: String) -> void:
	push_error("⚠️ informPlayerRefusedVido() must be implemented by subclass")

func informPlayerAcceptedVido(_player: String) -> void:
	push_error("⚠️ informPlayerAcceptedVido() must be implemented by subclass")

func informVidoRaisedFor7Piedras(_player: String) -> void:
	push_error("⚠️ informVidoRaisedFor7Piedras() must be implemented by subclass")
	
func informVidoRaisedFor9Piedras(_player: String) -> void:
	push_error("⚠️ informVidoRaisedFor9Piedras() must be implemented by subclass")

func informVidoRaisedForChico(_player: String) -> void:
	push_error("⚠️ informVidoRaisedForChico() must be implemented by subclass")

func informVidoRaisedForGame(_player: String) -> void:
	push_error("⚠️ informVidoRaisedForGame() must be implemented by subclass")

func informCanNotRaiseVidoMoreThanGame(_player: String) -> void:
	push_error("⚠️ informCanNotRaiseVidoMoreThanGame() must be implemented by subclass")
	
func informPlayerRoundWinner(_player: String, _roundScore: int)-> void:
	push_error("⚠️ informPlayerRoundWinner() must be implemented by subclass")

func informTeamWonPiedras(_teamName: String, _piedras: int, _piedrasOnPlay: int)-> void:
	push_error("⚠️ informTeamWonPiedras() must be implemented by subclass")

func informTeamWonChico(_teamName: String, _chicos: int)-> void:
	push_error("⚠️ informTeamWonChico() must be implemented by subclass")

func informTeamWon(_teamName: String)-> void:
	push_error("⚠️ informTeamWon() must be implemented by subclass")

func informDealer(_dealer: String)-> void:
	push_error("⚠️ informDealer() must be implemented by subclass")

func cannotRefuseVidoBecauseThereIsNoVidoCalled(_playerId: String):
	push_error("⚠️ cannotRefuseVidoBecauseThereIsNoVidoCalled() must be implemented by subclass")

func cannotAcceptVidoBecauseThereIsNoVidoCalled(_playerId: String):
	push_error("⚠️ cannotAcceptVidoBecauseThereIsNoVidoCalled() must be implemented by subclass")

func cannotRaiseVidoBecauseThereIsNoVidoCalled(_playerId: String):
	push_error("⚠️ cannotRaiseVidoBecauseThereIsNoVidoCalled() must be implemented by subclass")

func informPlayerFromSameTeamCanNotTakeDecision(_player: String):
	push_error("⚠️ informPlayerFromSameTeamCanNotTakeDecision() must be implemented by subclass")

func informOnlyLeaderCanTakeThisDecision(_player: String):
	push_error("⚠️ informOnlyLeaderCanTakeThisDecision() must be implemented by subclass")

func informPlayerCalledVido(_playerId: String):
	push_error("⚠️ informPlayerCalledVido() must be implemented by subclass")

func informVidoCanOnlyBeCalledOnYourTurn(_playerId: String):
	push_error("⚠️ informVidoCanOnlyBeCalledOnYourTurn() must be implemented by subclass")

func informCannNotCallVidoBecauseAlreadyCalled(_playerId: String):
	push_error("⚠️ informCannNotCallVidoBecauseAlreadyCalled() must be implemented by subclass")

func informCannNotCallVidoBecauseTumboIsBeingDecided(_playerId: String):
	push_error("⚠️ informCannNotCallVidoBecauseTumboIsBeingDecided() must be implemented by subclass")

func informCannNotPlayCardBecauseTumboIsBeingDecided(_playerId: String):
	push_error("⚠️ informCannNotPlayCardBecauseTumboIsBeingDecided() must be implemented by subclass")

func informTumboIsAccepted():
	push_error("⚠️ informTumboIsAccepted() must be implemented by subclass")

func informTumboIsRejected():
	push_error("⚠️ informTumboIsRejected() must be implemented by subclass")

func cannNotTakeThisDecisionIfNotInWaitingForTumbo(_playerId: String):
	push_error("⚠️ cannNotTakeThisDecisionIfNotInWaitingForTumbo() must be implemented by subclass")

func informTeam1IsOnTumbo():
	push_error("⚠️ informTeam1IsOnTumbo() must be implemented by subclass")

func informTeam2IsOnTumbo():
	push_error("⚠️ informTeam2IsOnTumbo() must be implemented by subclass")

func canNotMakeTheActionAfterTheGameEnded(_playerId: String):
	push_error("⚠️ canNotMakeTheActionAfterTheGameEnded() must be implemented by subclass")

func vidoCalledThisRoundAlready(_playerId: String):
	push_error("⚠️ vidoCalledThisRoundAlready() must be implemented by subclass")