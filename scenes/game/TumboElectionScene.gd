extends Node2D

class_name TumboElectionScene

signal tumbarButtonPressedSignal()
signal achicarseButtonPressedSignal()

func _ready() -> void:
	$TumbarButton.connect("buttonPressedSignal", onTumbarButtonPressed)
	$AchicarseButton.connect("buttonPressedSignal", onAchicarseButtonPressed)


func onTumbarButtonPressed() -> void:
	tumbarButtonPressedSignal.emit()

func onAchicarseButtonPressed() -> void:
	achicarseButtonPressedSignal.emit()
