extends Node2D

signal nameChosenSignal(name)

@onready var userName = $UserInput

func _on_ready_button_pressed() -> void:
	emit_signal("nameChosenSignal", userName.text)
	
