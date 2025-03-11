extends CharacterBody2D


@export var speed:float = 100

func _process(delta: float):	
	var v:Vector2
	v.x += Input.get_axis("ui_left","ui_right")
	
	v.y += Input.get_axis("ui_up","ui_down")
	
	v = v.normalized() * speed * delta
	move_and_collide(v)
	
	pass
	
