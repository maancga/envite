extends Node2D

class_name TumboElectionScene

signal tumbarButtonPressedSignal()
signal achicarseButtonPressedSignal()

func onTumbarButtonPressed() -> void:
	tumbarButtonPressedSignal.emit()

func onAchicarseButtonPressed() -> void:
	achicarseButtonPressedSignal.emit()
