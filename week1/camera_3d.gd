extends Camera3D

@export var speed:float = 10

func _process(delta: float):
	var velocity:Vector3
	velocity.x += Input.get_axis("Left","Right")
	velocity.z += Input.get_axis("Up","Down")
	size += Input.get_axis("ZoomIn","ZoomOut")
	size = max(min(size,50),10)
	
	position += velocity.normalized() * delta * speed
	
	
	
	pass
