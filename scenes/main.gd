extends Node

var chooseNameScene
var silence = false
var yourId: String
var optionsCanvasReference
var menuCanvasReference
var menuSceneReference: Menu
var serverController

func _ready():
	var args = OS.get_cmdline_args()
	var serverAndClientConnection = ServerAndClientConnection.new()
	serverAndClientConnection.name = "ServerOrClient"
	add_child(serverAndClientConnection)
	if "--server" in args:
		print("🧠 Starting in SERVER mode")
		serverAndClientConnection.start()
		setUpServerControllers()
		return
	print("🎮 Starting in CLIENT mode")
	if "--silence" in args:
		silence = true
	serverAndClientConnection.connectClient()
	serverAndClientConnection.connect("clientConnectedSignal", receivedClientId)
	serverController = StartMenuClientController.new()
	serverController.name = "ServerController"
	add_child(serverController)
	loadMenuScene()

func setUpServerControllers():
	var gameSessions = GameSessions.new()
	serverController = StartMenuServerController.new(gameSessions)
	serverController.name = "ServerController"
	var lobbyController = ServerLobbyController.new(gameSessions)
	lobbyController.name = "LobbyController"
	var gameController = ServerGameController.new(gameSessions)
	gameController.name = "GameController"
	add_child(serverController)
	add_child(lobbyController)
	add_child(gameController)


func receivedClientId(playerId: String):
	yourId = playerId

func loadMenuScene():
	var menuScene = preload("res://scenes/main-menu/Menu.tscn").instantiate()
	menuSceneReference = menuScene
	var canvas = CanvasLayer.new()
	canvas.add_child(menuScene)
	add_child(canvas)
	menuScene.connect("createGameSignal", onCreateGame)
	menuScene.connect("joinGameSignal", onJoinGame)
	menuScene.connect("openOptionsSignal", onOpenOptions)
	menuScene.connect("exitGameSignal", onExitGame)
	menuCanvasReference = canvas

func onExitGame():
	get_tree().quit()

func onCreateGame():
	serverController.connect("receivedGameAssignedSignal", setUpAndLoadChooseNameScene)
	serverController.clientRequestsCreateGame()

func onJoinGame():
	serverController.connect("receivedGameAssignedSignal", setUpAndLoadChooseNameScene)
	serverController.clientRequestsJoinGame(menuSceneReference.inputText.text)
	
func onOpenOptions():
	var optionsScene = preload("res://scenes/options/Options.tscn").instantiate()
	var canvas = CanvasLayer.new()
	canvas.add_child(optionsScene)
	add_child(canvas)
	optionsScene.connect("exitOptionsButtonPressedSignal", onCloseOptions)
	optionsCanvasReference = canvas

func onCloseOptions():
	optionsCanvasReference.queue_free()

func setUpAndLoadChooseNameScene(gameId: String):
	menuCanvasReference.visible = false
	chooseNameScene = preload("res://scenes/choose-name/ChooseName.tscn").instantiate()
	var lobbyController = ClientLobbyController.new(chooseNameScene)
	lobbyController.name = "LobbyController"
	add_child(chooseNameScene)
	add_child(lobbyController)
	chooseNameScene.setId(yourId)
	chooseNameScene.setLobbyName(gameId)
	lobbyController.connect("gameHasStartedSignal", startGame)


func startGame():
	menuCanvasReference.visible = false
	var gameScene = preload("res://scenes/game/GameScene.tscn").instantiate()
	add_child(gameScene)
	var gameController = ClientGameController.new(gameScene)
	gameController.name = "GameController"
	add_child(gameController)
	gameController.clientNotifiestItJoinedGame()
	if silence: gameScene.muteMusic()
	chooseNameScene.queue_free()
