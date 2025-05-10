extends Node2D

signal buttonPressedSignal()

func onEndButtonPressed() -> void:
	buttonPressedSignal.emit()
