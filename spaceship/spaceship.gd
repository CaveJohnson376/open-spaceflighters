extends RigidBody2D

const MIN_TIME = 0.05
const max_thrust = 5
const max_ang_thrust = 0.15
var throttle = 0
var total_throttle = 0
puppet var total_throttle_pub = 0
var thrust = 0
var timer = 0
var zoom = 0.1
var iscact = false
export var nickname = ""
export var player_id = 0
puppet var my_position = Vector2(0, 0)
puppet var my_velocity = Vector2(0, 0)
puppet var my_rotation = 0
puppet var my_ang_velocity = 0

func _ready():
	visible = true
	my_position = position
	$nicknameholder/nickname.text = nickname
	if is_network_master():
		$Camera2D.current = true
		$nicknameholder.visible = false
	else:
		$Camera2D.queue_free()
		pass
	print("playercreated")
	pass

func _process(delta):
	if is_network_master():
		$Engine_particles.scale = total_throttle * Vector2(0.1, 0.1)
		$Camera2D.zoom = zoom*Vector2(1, 1)
	else:
		$Engine_particles.scale = total_throttle_pub * Vector2(0.1, 0.1)
	
	var unreadmsgs = $"/root/Gamemanager".unreadmsgs
	var msgcount = "" if unreadmsgs == 0 else (" ("+str(clamp(unreadmsgs, 999, 0))+")")
	$CanvasLayer/FlightUI/openchat.text = "Chat"+msgcount
	iscact = $"/root/Gamemanager".ischatactive
	

func _physics_process(delta):
	timer += delta
	if is_network_master():
		throttle += 0.01 if Input.is_action_pressed("engine_up") and not iscact else 0
		throttle -= 0.01 if Input.is_action_pressed("engine_down") and not iscact else 0
		throttle = 1 if Input.is_action_pressed("engine_max") and not iscact else throttle
		throttle = 0 if Input.is_action_pressed("engine_min") and not iscact else throttle
		throttle = clamp(throttle, 0, 1)
		
		total_throttle = (1 if Input.is_action_pressed("engine_pulse") and not iscact else throttle)
		thrust = max_thrust*total_throttle
		linear_velocity+=thrust*Vector2(0, -1).rotated(rotation)
		
		angular_velocity-=max_ang_thrust if Input.is_action_pressed("rotateleft") and not iscact else 0
		angular_velocity+=max_ang_thrust if Input.is_action_pressed("rotateright") and not iscact else 0
		
		$Camera2D.rotation_degrees = angular_velocity*-10
		
		if timer >= MIN_TIME:
			rset_unreliable("total_throttle_pub", total_throttle)
			rset_unreliable("my_position", position)
			rset_unreliable("my_velocity", linear_velocity)
			rset_unreliable("my_rotation", rotation)
			rset_unreliable("my_ang_velocity", angular_velocity)
			timer = 0
			
		
	else:
		if not (my_position == Vector2(0, 0)):
			position = my_position
		if not (my_velocity == Vector2(0, 0)):
			linear_velocity = my_velocity
		if not (my_rotation == 0):
			rotation = my_rotation
		if not (my_ang_velocity == 0):
			angular_velocity = my_ang_velocity
	pass

func _input(event):
	if event is InputEventMouseButton:
		zoom -= 0.01 if event.button_index == BUTTON_WHEEL_UP else 0
		zoom += 0.01 if event.button_index == BUTTON_WHEEL_DOWN else 0
		zoom = clamp(zoom, 0.02, 0.5)
	pass
