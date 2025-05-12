extends Node2D

class_name VidoButtonDisplay

signal callVidoButtonPressedSignal()

func _on_call_vido_button_pressed() -> void:
	callVidoButtonPressedSignal.emit()
