class_name CardBuilder

var suit: SuitEnum.Suit
var value: ValueEnum.Value

func withSuit(_suit: SuitEnum.Suit) -> CardBuilder:
    suit = _suit
    return self

func withValue(_value: ValueEnum.Value) -> CardBuilder:
    value = _value
    return self

func build() -> ServerCard:
    return ServerCard.new(value, suit)