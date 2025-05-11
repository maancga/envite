extends Node

var chooseNameScene
var yourId: String
var optionsCanvasReference
var menuCanvasReference
var menuSceneReference: Menu
var serverController
var gameScene
var lobbyController
var gameController

func _ready():
	var args = OS.get_cmdline_args()
	var serverAndClientConnection = ServerAndClientConnection.new()
	serverAndClientConnection.name = "ServerOrClient"

	add_child(serverAndClientConnection)
	if "--server" in args:
		print("🧠 Starting in SERVER mode")
		var gameSessions = GameSessions.new()
		serverAndClientConnection.start(gameSessions)
		setUpServerControllers(gameSessions)
		return
	print("🎮 Starting in CLIENT mode")
	if "--silence" in args:
		$GameMusic.stop()
	serverAndClientConnection.connectClient()
	serverAndClientConnection.connect("clientConnectedSignal", receivedClientId)
	serverController = StartMenuClientController.new()
	serverController.name = "ServerController"
	add_child(serverController)
	serverController.connect("receivedGameAssignedSignal", setUpAndLoadChooseNameScene)
	loadMenuScene()

func setUpServerControllers(gameSessions: GameSessions):
	serverController = StartMenuServerController.new(gameSessions)
	serverController.name = "ServerController"
	var serverLobbyController = ServerLobbyController.new(gameSessions)
	serverLobbyController.name = "LobbyController"
	var serverGameController = ServerGameController.new(gameSessions)
	serverGameController.name = "GameController"
	add_child(serverController)
	add_child(serverLobbyController)
	add_child(serverGameController)


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
	serverController.clientRequestsCreateGame()

func onJoinGame():
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
	lobbyController = ClientLobbyController.new(chooseNameScene)
	lobbyController.name = "LobbyController"
	add_child(chooseNameScene)
	add_child(lobbyController)
	chooseNameScene.setId(yourId)
	chooseNameScene.setLobbyName(gameId)
	lobbyController.connect("gameHasStartedSignal", startGame)


func startGame():
	gameScene = preload("res://scenes/game/GameScene.tscn").instantiate()
	gameController = ClientGameController.new(gameScene)
	gameController.name = "GameController"
	add_child(gameScene)
	add_child(gameController)
	gameController.clientNotifiestItJoinedGame()
	gameController.connect("returnToMenuSignal", onReturnToMenu)
	chooseNameScene.queue_free()
	lobbyController.queue_free()

func onReturnToMenu():
	menuCanvasReference.visible = true
	gameScene.queue_free()
	gameController.queue_free()
