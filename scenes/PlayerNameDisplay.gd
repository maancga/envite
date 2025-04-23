extends Node2D

class_name PlayerNameDisplay

@export var defaultColor = Color.WHITE
@export var highlightedColor = Color.RED

func _ready() -> void:
	$CrownPixelArt.visible = false
	$Borde.visible = false

func setPlayerName(playerName: String):
	$PlayerNameLabel.text = playerName

func convertToLeader():
	$CrownPixelArt.visible = true
	
func isPlayerTurn():
	$Borde.visible = true

func isNotPlayerTurn():
	$Borde.visible = false
	
func isYou():
	$PlayerNameLabel.add_theme_color_override("font_color", highlightedColor)

func setTeam1Color():
	$TablonDeMadera.modulate = Color("3f5db8")
	
func setTeam2Color():
	$TablonDeMadera.modulate = Color("813373")
