extends CharacterBody2D

@export var mass = 1
@export var max_speed = 20
@export var circle_distance = 100
var force = Vector2(0,0)
var ran_dir = 0
var circle_center = position
var circle_point = position

func _ready():
	pass
	
func _process(delta: float):
	
	force = wander(delta)
	
	var accel = force/mass
	
	velocity = velocity + accel
	

	move_and_slide()
	
	queue_redraw()
	
	pass

func wander(delta: float) -> Vector2:
	ran_dir = ran_dir + (0.1 * PI * (randf() - 0.5))
	
	circle_center = global_position + circle_distance * Vector2(cos(rotation),sin(rotation))
	circle_point = circle_center - (circle_distance/2.0)  * Vector2(cos(ran_dir),sin(ran_dir))
	var to_target = circle_point - global_position
	
	var desired = to_target.normalized() * max_speed
	
	rotation = lerp_angle(rotation ,to_target.angle(), delta * 0.1)
	
	return desired - velocity

	
func _draw() -> void:
	draw_circle(circle_center - global_position, circle_distance/2,Color(255,0,0),false,1)
	draw_line(circle_center - global_position, circle_point - global_position,Color(255,0,0),1)
	draw_line(Vector2(0,0), 300*force, Color(255,0,255), 1)
	pass
