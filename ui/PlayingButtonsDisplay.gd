extends Node2D

class_name PlayingButtonsDisplay

signal playCardButtonPressedSignal()
signal callVidoButtonPressedSignal()


func hideButtons():
	$CallVidoButton.visible = false
	$PlayCardButton.visible = false

func showButtons():
	$CallVidoButton.visible = false
	$PlayCardButton.visible = false


func _on_play_card_button_pressed() -> void:
	playCardButtonPressedSignal.emit()


func _on_call_vido_button_pressed() -> void:
	callVidoButtonPressedSignal.emit()
