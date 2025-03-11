extends CharacterBody2D

@export var mass = 1
@export var max_speed = 80
@export var circle_distance = 50
@export var circle_size = 50
var force = Vector2(0,0)
var ran_dir = 0.0
var time = 0
var ray_length = 400

var ray_origin = Vector2(0,0)
var ray_target1 = Vector2(0,0)
var ray_target2 = Vector2(0,0)
@export var speed:float = 100	

func ray_detection():
	var space_state = get_world_2d().direct_space_state

	ray_origin = global_position
	ray_target1 = global_position + Vector2(ray_length, 0).rotated(deg_to_rad(20)).rotated(rotation)
	ray_target2 = global_position + Vector2(ray_length, 0).rotated(deg_to_rad(-20)).rotated(rotation)
		
	var query1 = PhysicsRayQueryParameters2D.create(ray_origin, ray_target1)
	var query2 = PhysicsRayQueryParameters2D.create(ray_origin, ray_target2)
	query1.collide_with_areas = false  # Usually you only want to hit physics bodies
	query2.collide_with_bodies = true

	var result1 = space_state.intersect_ray(query1)
	var result2 = space_state.intersect_ray(query1)

	if result1:
		var collider = result1.get("collider")
		print(collider)
		if collider is TileMapLayer:
			print("Ray hit a TileMap with collision at position: ", result1.position)
			ran_dir += deg_to_rad(30 * ray_length/(result1.position - global_position).length())
	elif result2:
		var collider = result2.get("collider")
		print(collider)
		if collider is TileMapLayer:
			print("Ray hit a TileMap with collision at position: ", result2.position)
			ran_dir -= deg_to_rad(30 * ray_length/(result2.position - global_position).length())
	pass

func wander(delta: float) -> Vector2:
	var direction = Vector2(1,0)
	
	time += delta
	if time > 0.5:
		time = 0
		ran_dir += randf_range(-PI/3,PI/3)
		ran_dir = clamp(ran_dir, rotation - deg_to_rad(90), rotation + deg_to_rad(90))
		
	rotation = lerp(rotation, ran_dir, 0.02)
	
	direction = direction.rotated(rotation)
	
	return direction


func _process(delta: float):
	
	force = Vector2(0,0)
	force += wander(delta)
	ray_detection()
	
	velocity += force * max_speed * delta
	
	velocity = velocity.normalized() * min(velocity.length(), max_speed)
	
	move_and_slide()
	
	if velocity.length() > 0:
		var target_rotation = velocity.angle() 
		rotation = lerp_angle(rotation, target_rotation, delta * 5)  # Smooth rotation

	queue_redraw()

func _draw() -> void:
	draw_line(Vector2(0,0), 300*force.rotated(-velocity.angle()), Color(255,0,255), 1)
	draw_line(ray_origin - global_position, (ray_target1 - global_position).rotated(-rotation), Color.RED,3)
	draw_line(ray_origin - global_position, (ray_target2 - global_position).rotated(-rotation), Color.RED,3)
	pass
