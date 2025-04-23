extends Node2D

class_name TeamScoreLabels

@onready var team1Label = $Control/HBoxContainer/FirstColumn/Team1Label
@onready var team2Label = $Control/HBoxContainer/FirstColumn/Team2Label
@onready var team1Chicos = $Control/HBoxContainer/SecondColumn/Team1Chicos
@onready var team2Chicos = $Control/HBoxContainer/SecondColumn/Team2Chicos
@onready var team1Piedras = $Control/HBoxContainer/ThirdColumn/Team1Piedras
@onready var team2Piedras = $Control/HBoxContainer/ThirdColumn/Team2Piedras
@onready var team1Rondas = $Control/HBoxContainer/FourthColumn/Team1Rondas
@onready var team2Rondas = $Control/HBoxContainer/FourthColumn/Team2Rondas

var highlightColor = "54ba5e"

func highlightTeam1Row():
	team1Label.add_theme_color_override("font_color", highlightColor)
	team1Chicos.add_theme_color_override("font_color", highlightColor)	
	team1Piedras.add_theme_color_override("font_color", highlightColor)	
	team1Rondas.add_theme_color_override("font_color", highlightColor)	

func highlightTeam2Row():
	team2Label.add_theme_color_override("font_color", highlightColor)
	team2Chicos.add_theme_color_override("font_color", highlightColor)	
	team2Piedras.add_theme_color_override("font_color", highlightColor)	
	team2Rondas.add_theme_color_override("font_color", highlightColor)	

func setTeam1Rondas(rounds: int):
	team1Rondas.text = str(rounds)

func setTeam2Rondas(rounds: int):
	team2Rondas.text = str(rounds)

func setTeam1Piedras(piedras: int):
	team1Piedras.text = str(piedras)

func setTeam2Piedras(piedras: int):
	team2Piedras.text = str(piedras)
	
func setTeam1Chicos(chicos: int):
	team1Chicos.text = str(chicos)

func setTeam2Chicos(chicos: int):
	team2Chicos.text = str(chicos)
