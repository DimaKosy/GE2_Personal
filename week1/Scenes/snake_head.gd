extends CharacterBody2D

@export var mass = 1
@export var max_speed = 50
@export var circle_distance = 50
@export var circle_size = 50
var force = Vector2(0,0)
var ran_dir = 0.0
var circle_center = position
var circle_point = position

@export var speed:float = 100	



func wander(delta: float) -> Vector2:
	var direction = Vector2(1,0)
	
	direction = direction.rotated(PI/2)
	
	return direction


func _process(delta: float):	
	force = Vector2(0,0)
	force += wander(delta)
	
	velocity += force * max_speed * delta
	
	velocity = velocity.normalized() * min(velocity.length(), max_speed)
	
	move_and_slide()
	
	if velocity.length() > 0:
		var target_rotation = velocity.angle() 
		rotation = lerp_angle(rotation, target_rotation, delta * 5)  # Smooth rotation

	queue_redraw()

func _draw() -> void:
	
	draw_circle(circle_center - global_position, circle_size,Color(255,0,0),false,1)
	draw_line(circle_center - global_position, circle_point - global_position,Color(255,0,0),1)
	draw_line(Vector2(0,0), 300*force.rotate(-velocity.angle()), Color(255,0,255), 1)
	pass
