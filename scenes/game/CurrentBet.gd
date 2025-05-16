extends Label

var raisedTo4 = false
var raisedTo7 = false
var raisedTo9 = false
var raisedToChico = false
var raisedToGame = false

func _ready():
	text = "Apuesta actual: 2 piedras"

func raise():
	if raisedToGame : return
	if raisedToChico: 
		raisedToGame = true
		return
	if raisedTo9: 
		raisedToChico = true
		return
	if raisedTo7: 
		raisedTo9 = true
		return
	if raisedTo4: 
		raisedTo7 = true
		return
	raisedTo4 = true

func updateText():
	if raisedToGame : 
		text = "Apuesta actual: PARTIDA"
		return
	if raisedToChico: 
		text = "Apuesta actual: Un chico"
		return
	if raisedTo9: 
		text = "Apuesta actual: 9 piedras"
		return
	if raisedTo7: 
		text = "Apuesta actual: 7 piedras"
		return
	if raisedTo4: 
		text = "Apuesta actual: 4 piedras"
		return
	text = "Apuesta actual: 2 piedras"

func resetBets():
	raisedTo4 = false
	raisedTo7 = false
	raisedTo9 = false
	raisedToChico = false
	raisedToGame = false
	
