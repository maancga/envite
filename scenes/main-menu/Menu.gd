extends Control

class_name Menu

@onready var inputText = $VBoxContainer/LobbyName 

signal createGameSignal()
signal joinGameSignal()
signal openOptionsSignal()
signal exitGameSignal()

func _ready() -> void:
	$VBoxContainer/CrearPartidaButton.connect("buttonPressedSignal", onCrearPartidaButtonPressed)
	$VBoxContainer/UnirseAPartidaButton.connect("buttonPressedSignal", onUnirseAPartidaButtonPressed)
	$VBoxContainer/OpcionesButton.connect("buttonPressedSignal", onOpcionesButtonPressed)
	$VBoxContainer/SalirButton.connect("buttonPressedSignal", onSalirButtonPressed)

func onCrearPartidaButtonPressed() -> void:
	createGameSignal.emit()

func onUnirseAPartidaButtonPressed() -> void:
	joinGameSignal.emit()

func onOpcionesButtonPressed() -> void:
	openOptionsSignal.emit()

func onSalirButtonPressed() -> void:
	exitGameSignal.emit()
