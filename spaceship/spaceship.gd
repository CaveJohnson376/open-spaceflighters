extends RigidBody2D

const MIN_TIME = 0.05
const max_thrust = 100
const max_ang_thrust = 0.05
var throttle = 0
var thrust = 0
var timer = 0
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
	$nicknameholder.visible = not is_network_master()
	print("playercreated")
	pass

func _physics_process(delta):
	timer += delta
	if is_network_master():
		throttle += 1 if Input.is_action_pressed("engine_up") else 0
		throttle -= 1 if Input.is_action_pressed("engine_down") else 0
		throttle = 100 if Input.is_action_pressed("engine_max") else throttle
		throttle = 0 if Input.is_action_pressed("engine_min") else throttle
		throttle = clamp(throttle, 0, 100)
		
		thrust = max_thrust/100*(100 if Input.is_action_pressed("engine_pulse")else throttle)
		linear_velocity+=thrust*Vector2(0, -1).rotated(rotation)
		
		angular_velocity-=max_ang_thrust if Input.is_action_pressed("rotateleft") else 0
		angular_velocity+=max_ang_thrust if Input.is_action_pressed("rotateright") else 0
		
		$Camera2D.rotation_degrees = angular_velocity*-10
		
		if timer >= MIN_TIME:
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
	
	pass
