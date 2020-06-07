extends Control

func _ready():
	$mainmenu.popup_centered()
	pass # Replace with function body.

func _on_multiplayer_pressed():
	$multiplayer.popup_centered()
	pass

func _on_startmultiplayergame():
	print("here we go")
	$"/root/Gamemanager".emit_signal("host", $multiplayer/port.value, $multiplayer/maxplayers.value, $multiplayer/nickname.text)
	pass


func _on_joinmultiplayergame():
	$"/root/Gamemanager".emit_signal("join", $multiplayer/IP.text, $multiplayer/port.value, $multiplayer/nickname.text)
	pass
