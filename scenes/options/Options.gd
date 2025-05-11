extends Control	

signal exitOptionsButtonPressedSignal()

func _ready() -> void:
	$VBoxContainer/ExitButton.connect("buttonPressedSignal", onExitButtonPressed)

func onExitButtonPressed() -> void:
	exitOptionsButtonPressedSignal.emit()
