extends Control

signal exitOptionsButtonPressedSignal()

func onExitButtonPressed() -> void:
	exitOptionsButtonPressedSignal.emit()
