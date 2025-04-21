extends Node2D

class_name VidoElectionScene

signal rejectButtonPressedSignal()
signal acceptButtonPressedSignal()
signal raisedButtonPressedSignal()


func _on_reject_vido_button_pressed() -> void:
	rejectButtonPressedSignal.emit()

func _on_accept_vido_button_pressed() -> void:
	acceptButtonPressedSignal.emit()

func _on_raise_vido_button_pressed() -> void:
	raisedButtonPressedSignal.emit()
