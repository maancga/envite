extends Control

class_name DropZoneCard

var playerId: String

func _ready() -> void:
	paintAsNormal()

func setCardData(playerName: String, _playerId: String,  value: ValueEnum.Value, suit: SuitEnum.Suit) -> void:
	var path = CardSpritePathResolver.new().resolve(suit, value)
	var text = load(path)
	$Overlay/PlayerName.text = playerName
	$Overlay/Image.texture = text
	playerId = _playerId

func paintAsWinning() -> void:
	$GoldBorder.visible = true

func paintAsNormal() -> void:
	$GoldBorder.visible = false
