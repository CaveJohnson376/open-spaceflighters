extends Node2D
var plrsam = preload("res://scenes/spaceship.tscn")
var nickname

func _ready():
	$"/root/Gamemanager".connect("create_player", self, "cplayer")
	$"/root/Gamemanager".emit_signal("start_game")
	
	pass

func cplayer(id, nickname):
	print("creatingplayer...")
	var player = plrsam.instance()
	player.nickname = nickname
	player.set_network_master(id)
	$players.add_child(player)
	player.player_id = id
	pass
