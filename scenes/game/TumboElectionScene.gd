extends Node2D

class_name TumboElectionScene

signal tumbarButtonPressedSignal()
signal irseButtonPressedSignal()

func onTumbarButtonPressed() -> void:
	tumbarButtonPressedSignal.emit()

func onIrseButtonPressed() -> void:
	irseButtonPressedSignal.emit()
