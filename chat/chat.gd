extends WindowDialog

func _ready():
	pass

remote func sendmsg(msg):
	$ScrollContainer/Label.text+=msg
	pass

func _process(delta):
	$ScrollContainer/Label.rect_min_size.x = $ScrollContainer.rect_size.x - 15
	if Input.is_action_just_pressed("focus_chat"):
		popup_centered()
		$msg.grab_focus()
	if Input.is_action_just_pressed("ui_accept") and $msg.has_focus():
		send()
		pass
	pass

func send():
	var message = "["+$"/root/Gamemanager".nickname+"]: "+$msg.text+"\n"
	rpc("sendmsg", message)
	pass
