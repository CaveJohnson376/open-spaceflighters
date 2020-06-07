extends Control

func _ready():
	$mainmenu.popup_centered()
	pass # Replace with function body.

func _on_multiplayer_pressed():
	$multiplayer.popup_centered()
	pass

func _on_startmultiplayergame():
	$"/root/Gamemanager"._on_host($multiplayer/port.value, $multiplayer/maxplayers.value, $multiplayer/nickname.text)
	pass


func _on_joinmultiplayergame():
	$"/root/Gamemanager"._on_join($multiplayer/IP.value, $multiplayer/port.value, $multiplayer/nickname.text)
	pass
