extends Node2D
export var planetradius = 0

func _ready():
	for i in range(0, 360):
		$LightOccluder2D.occluder.polygon[i] = Vector2(planetradius-20, 0).rotated(i)
		pass
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
