extends Node

class_name PlayerInteractor

func informPlayersAndTeams(_players: Dictionary) -> void:
	push_error("⚠️ informPlayersAndTeams() must be implemented by subclass")

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
	
func informPlayerRoundWinner(_player: String, _roundScore: int)-> void:
	push_error("⚠️ informPlayerRoundWinner() must be implemented by subclass")

func informTeamWonChicoPoints(_teamName: String, _chicoPoints: int)-> void:
	push_error("⚠️ informTeamWonChicoPoints() must be implemented by subclass")

func informTeamWonChico(_teamName: String, _chicos: int)-> void:
	push_error("⚠️ informTeamWonChico() must be implemented by subclass")

func informTeamWon(_teamName: String)-> void:
	push_error("⚠️ informTeamWon() must be implemented by subclass")

func informDealer(_dealer: String)-> void:
	push_error("⚠️ informDealer() must be implemented by subclass")
