extends Camera2D

@export var speed:float = 100

func _process(delta: float):
	var velocity:Vector2
	velocity.x += Input.get_axis("Left","Right")
	velocity.y += Input.get_axis("Up","Down")
	
	position += velocity.normalized() * delta * speed
	
	pass
