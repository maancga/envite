extends Node

class_name ServerAndClientConnection

signal clientConnectedSignal(playerId: String)
var gameSessions: GameSessions

func start(_gameSessions: GameSessions):
	gameSessions = _gameSessions
	var peer = ENetMultiplayerPeer.new()
	var port = 9000
	var err = peer.create_server(port)
	if err != OK:
		push_error("❌ Could not start server!")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(onClientConnected)
	multiplayer.peer_disconnected.connect(onClientDisconnected)
	print("🟢 Server running on port", port)

# REMOTE ip ec2-13-53-37-187.eu-north-1.compute.amazonaws.com
# local ip 127.0.0.1
func connectClient(ip = "127.0.0.1", port = 9000):
	if multiplayer.has_multiplayer_peer() and not multiplayer.is_server():
		print("⚠️ Already connected — ignoring request.")
		return
	print("📡 Attempting to connect to %s:%d" % [ip, port])
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip, port)
	if err != OK:
		push_error("❌ Could not connect to server!")
		return
	multiplayer.multiplayer_peer = peer

func onClientConnected(id):
	print("🟢 Client connected with id: ", id)
	rpc_id(id, "receiveClientId", str(id))

@rpc("authority")
func receiveClientId(playerId: String):
	clientConnectedSignal.emit(playerId)

func onClientDisconnected(id):
	print("🔴 Client disconnected with id: ", id)
	gameSessions.disconnectPlayer(str(id))