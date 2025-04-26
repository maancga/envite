extends Control

class_name DropZoneCard

func setCardData(namePlayer: String, value: ValueEnum.Value, suit: SuitEnum.Suit) -> void:
	var path = CardSpritePathResolver.new().resolve(suit, value)
	var text = load(path)
	$Overlay/PlayerName.text = namePlayer
	$Overlay/Image.texture = text
