extends Button

signal buttonPressedSignal()

func onButtonMouseEntered() -> void:
	$ButtonFocusedSound.play()

func onButtonPressed() -> void:
	buttonPressedSignal.emit()
