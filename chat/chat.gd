extends WindowDialog

var unreadmsgs = 0

func _ready():
	pass

remote func sendmsg(msg):
	$ScrollContainer/Label.text+=msg
	unreadmsgs += 0
	pass

func _process(delta):
	$ScrollContainer/Label.rect_min_size.x = $ScrollContainer.rect_size.x - 15
	if Input.is_action_just_pressed("focus_chat") and not $msg.has_focus():
		popup_centered()
		$msg.grab_focus()
	if Input.is_action_just_pressed("ui_accept") and $msg.has_focus() and not Input.is_action_pressed("shift_modifier"):
		send()
		pass
	$"/root/Gamemanager".ischatopen = visible
	if visible:
		unreadmsgs = 0
	$"/root/Gamemanager".unreadmsgs = unreadmsgs
	$"/root/Gamemanager".ischatactive = $msg.has_focus()
	pass

func send():
	var message = "\n["+$"/root/Gamemanager".nickname+"]: "+$msg.text
	message.erase(message.length()-1, 1)
	$msg.text = ""
	rpc("sendmsg", message)
	sendmsg(message)
	pass
