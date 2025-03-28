extends CharacterBody2D


@export var speed:float = 100
var z = 0

func _process(delta: float):	
	var v:Vector2
	v.x += Input.get_axis("ui_left","ui_right")
	
	v.y += Input.get_axis("ui_up","ui_down")*0.1
	z += Input.get_axis("ui_page_up", "ui_page_down")*0.1
	z = min(max(z, 0.5),5)
	#print(z)
	find_child("Camera2D").zoom = Vector2(1,1)/Vector2(z,z)
	
	v = v.normalized() * speed * delta
	move_and_collide(v)
	
	pass
	
