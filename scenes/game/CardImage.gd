extends Sprite2D

class_name CardImage

func update_texture(suit: SuitEnum.Suit, value: ValueEnum.Value):
	var path = CardSpritePathResolver.new().resolve(suit, value)
	var tex = load(path)
	texture = tex
