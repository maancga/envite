class_name DealerManager

var gamePlayers: GamePlayers
var playerInteractor: PlayerInteractor
var currentDealer: String

func _init(_gamePlayers: GamePlayers, _playerInteractor: PlayerInteractor) -> void:
    self.gamePlayers = _gamePlayers
    self.playerInteractor = _playerInteractor
    self.currentDealer = gamePlayers.playerIds[0]

func setNewDealer() -> void:
    currentDealer = gamePlayers.getNextPlayer(currentDealer)

func getCurrentDealer() -> String:
    return currentDealer
