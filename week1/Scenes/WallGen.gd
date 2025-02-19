extends Marker3D

@export var Wall:PackedScene

func _ready():
	
	for i in range(1):
		var newWall = Wall.instantiate()
		newWall.get_child(0).shape.size = Vector3(0.5,1,40)
		add_child(newWall)
		pass
	
	pass
