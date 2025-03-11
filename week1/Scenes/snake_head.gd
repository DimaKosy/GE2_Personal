extends CharacterBody2D

@export var mass = 1
@export var max_speed = 50
@export var circle_distance = 100
var force = Vector2(0,0)
var col_force = Vector2(0,0)
var ran_dir = 0
var circle_center = position
var circle_point = position

@export var speed:float = 100

func _ready() -> void:
	find_child("left").body_entered.connect(left_enter)
	find_child("center").body_exited.connect(center_enter)
	find_child("right").body_exited.connect(right_enter)
	find_child("left").body_entered.connect(left_exit)
	find_child("center").body_exited.connect(center_exit)
	find_child("right").body_exited.connect(right_exit)

func left_enter(body: Node) -> void:
	col_force += Vector2(sin(rotation), cos(rotation))

func center_enter(body: Node) -> void:
	col_force += Vector2(-cos(rotation), sin(rotation))
	pass
	
func right_enter(body: Node) -> void:
	col_force += Vector2( sin(rotation), -cos(rotation))

func left_exit(body: Node) -> void:
	col_force = Vector2(sin(rotation), cos(rotation))

func center_exit(body: Node) -> void:
	col_force -= Vector2(-cos(rotation), sin(rotation))
	pass
	
func right_exit(body: Node) -> void:
	col_force -= Vector2( sin(rotation), -cos(rotation))

func wander(delta: float) -> Vector2:
	ran_dir = ran_dir + (0.1 * PI * (randf() - 0.5))
	
	circle_center = global_position + circle_distance * Vector2(cos(rotation),sin(rotation))
	circle_point = circle_center - (circle_distance/2.0)  * Vector2(cos(ran_dir),sin(ran_dir))
	var to_target = circle_point - global_position
	
	var desired = to_target.normalized() * max_speed
	
	#rotation = lerp_angle(rotation ,to_target.angle(), delta * 0.1)
	
	return desired - velocity


func _process(delta: float):	
	force += wander(delta)
	col_force = col_force.normalized()
	force += col_force
	
	velocity += force
	force = (Vector2(0,0))
	move_and_slide()
	if velocity.length() > 0:
		var target_rotation = velocity.angle()  
		rotation = lerp_angle(rotation, target_rotation, delta * 5)
	
	pass
	
