extends Node
export var players = {}
export var nickname = "player"
export var isplaying = false
export var ishost = false
export var issingleplayer = false
export var ready = false

signal create_player(id, playername)

func _ready():
	get_tree().connect("network_peer_connected", self, "on_player_connect")
	get_tree().connect("network_peer_disconnected", self, "on_player_disconnect")
	get_tree().connect("connected_to_server", self, "on_connect_ok")
	get_tree().connect("connection_failed", self, "on_connect_fail")
	get_tree().connect("server_disconnected", self, "on_server_disconnect")
	pass

remote func register_player(id, nickname):
	players[id] = nickname
	if get_tree().is_network_server():
		rpc_id(id, "register_player", 1, nickname)
		for peer_id in players:
			#rpc_id(id, "register_player", peer_id)
			rpc_id(peer_id, "register_player", id, nickname)
		pass
	print("register")
	pass

func start_game():
	
	while not ready:
		pass
	isplaying = true
	if get_tree().is_network_server():
		emit_signal("create_player", 1, nickname)
		pass
	for peer_id in players:
		if peer_id == 1:
			pass
		else:
			emit_signal("create_player", peer_id, players[peer_id])
	pass

func _input(event):
	pass

func on_player_connect(id):
	register_player(id, "")
	pass

func on_connect_fail():
	pass

func on_player_disconnect(id):
	pass

func on_connect_ok():
	
	start_game()
	pass

func on_server_disconnect():
	pass

func _on_join(ip, port, nick):
	nickname = nick
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, port)
	get_tree().set_network_peer(peer)
	register_player(get_tree().get_network_unique_id(), nickname)
	ishost = false
	pass


func _on_host(port, plrcount, nick):
	nickname = nick
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(port, plrcount)
	get_tree().set_network_peer(peer)
	register_player(get_tree().get_network_unique_id(), nickname)
	start_game()
	ishost = true


func _on_disconnect():
	get_tree().network_peer.close_connection()
	isplaying = false
	ishost = false


