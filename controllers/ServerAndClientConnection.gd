extends Node

class_name ServerAndClientConnection

signal clientConnectedSignal(playerId: String)

func start():
	var peer = ENetMultiplayerPeer.new()
	var port = 9000
	var err = peer.create_server(port)
	if err != OK:
		push_error("❌ Could not start server!")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(onClientConnected)
	print("🟢 Server running on port", port)

func connectClient(ip = "127.0.0.1", port = 9000):
	if multiplayer.has_multiplayer_peer() and not multiplayer.is_server():
		print("⚠️ Already connected — ignoring request.")
		return
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