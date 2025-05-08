extends Line2D

@export var target:Node2D
var segment_count = 7
var segment_length = 20
var max_angle_degrees = 50.0
var leg_start = 2
var leg_gap = 2
var leg_end = 3
var leg_target_pos = Vector2(50,10)
var foot_reset_circle = 30

@export var inter_rate = 0.5
@export var leg:PackedScene

var leg_indices:Array[int] #for the body index relative to leg
var leg_left_position:Array[Vector2]
var leg_right_position:Array[Vector2]

var foot_left_target:Array[Vector2]
var foot_right_target:Array[Vector2]

var leg_joints_left = []
var leg_joints_right = []



func _ready() -> void:
	z_index = 1
	
	segment_count = target.segment_count
	segment_length = target.segment_length
	max_angle_degrees = target.max_angle_degrees
	leg_start = target.leg_start
	leg_gap = target.leg_gap
	leg_end = target.leg_end
	foot_reset_circle = target.foot_reset_circle
	leg_target_pos = target.leg_target_pos
	texture = target.my_texture
	
	for i in segment_count:
		add_point(Vector2(0,0))#i * segment_length
		#for j in range(0, segment_count - 1):
			#var new_shape = CollisionShape2D.new()
			#$RigidBody2D.add_child(new_shape)
			#var segment = SegmentShape2D.new()
			#segment.a = Vector2(0,i * segment_length)
			#segment.b = Vector2(0,(i + 1) * segment_length)
			#new_shape.shape = segment
		
		if i < leg_start:
			continue
		if (leg_start - i)%leg_gap != 0:
			continue
		if i > segment_count - leg_end:
			continue
		
		leg_indices.append(i)
		leg_left_position.append(Vector2(0,0))
		leg_right_position.append(Vector2(0,0))
		foot_left_target.append(Vector2(0,0))
		foot_right_target.append(Vector2(0,0))
		
		var left_leg:Line2D = leg.instantiate()
		var right_leg:Line2D = leg.instantiate()
		left_leg.width = 2
		right_leg.width = 2
		
		# setting the leg ordering
		left_leg.z_index = 0
		right_leg.z_index = 0
		left_leg.z_as_relative = true
		right_leg.z_as_relative = true
		
		#texture
		var gradient := Gradient.new()
		
	
		var grad_offset = i/float(segment_count);
		
		
		gradient.add_point(0.0, texture.gradient.sample(grad_offset))
		#gradient.add_point(1.0, Color.BLACK)
		gradient.add_point(1.0, Color.BLACK)
		
		#print(texture.gradient.get_color(grad_offset))
		
		
		var gradient_texture := GradientTexture1D.new()
		gradient_texture.gradient = gradient
		
		left_leg.texture_mode = Line2D.LINE_TEXTURE_TILE
		right_leg.texture_mode = Line2D.LINE_TEXTURE_TILE
		left_leg.texture = gradient_texture
		right_leg.texture = gradient_texture
		
		#leg width
		
		
		add_child(left_leg)
		add_child(right_leg)
		
		
		
		leg_joints_left.append(left_leg)
		leg_joints_right.append(right_leg)
		
		for j in range(3):
			leg_joints_left[leg_joints_left.size() - 1].add_point(Vector2(0,0))
			leg_joints_right[leg_joints_right.size() - 1].add_point(Vector2(0,0))
			pass
		
		pass	
	pass

func leg_joint_update(source:Vector2, destination:Vector2, leg_index:int, leg_joint:Array, side:int):
	leg_joint[leg_index].set_point_position(0, source)
	
	# move the end point 
	var last_index = leg_joint[leg_index].get_point_count() - 1
	var current_end = leg_joint[leg_index].get_point_position(last_index)
	var new_end = current_end + (destination - current_end) * inter_rate
	leg_joint[leg_index].set_point_position(last_index, new_end)
	
	# move the points back
	for i in range(last_index - 1, 0, -1):
		var next_pos = leg_joint[leg_index].get_point_position(i + 1)
		var dir = (leg_joint[leg_index].get_point_position(i) - next_pos).normalized()
		leg_joint[leg_index].set_point_position(i, next_pos + dir * segment_length)
	
	for i in range(1, leg_joint[leg_index].get_point_count()):
		var prev = leg_joint[leg_index].get_point_position(i - 1)
		var dir = (leg_joint[leg_index].get_point_position(i) - prev).normalized()
		leg_joint[leg_index].set_point_position(i, prev + dir * segment_length)
	pass

func _process(delta: float) -> void:

	var target_pos = get_point_position(0) + (target.global_position - get_point_position(0)) * inter_rate
	
	set_point_position(0, target_pos)
	

	for i in range(1, get_point_count()):
		var cur_pos = get_point_position(i)
		var prev_pos = get_point_position(i - 1)
		var to_cur = cur_pos - prev_pos

		# Normalize direction and clamp distance
		var direction = to_cur.normalized()
		target_pos = prev_pos + direction * segment_length

		# Angle limiting
		if i > 1:
			var base_dir = (get_point_position(i - 1) - get_point_position(i - 2)).normalized()
			var angle = base_dir.angle_to(direction)
			var max_angle = deg_to_rad(max_angle_degrees)

			if abs(angle) > max_angle:
				direction = base_dir.rotated(clamp(angle, -max_angle, max_angle))
				pass
		
			
			#var segment = SegmentShape2D.new()
			#segment.a = get_point_position(i-1)
			#segment.b = prev_pos + direction * segment_length
			#get_child(0).get_child(i -1).shape = segment
			#print(get_child(0).get_child(i -1).shape.a)
		set_point_position(i, prev_pos + direction * segment_length)
		
	for i in leg_indices.size():
		var direction
		if i != 0:
			direction = (get_point_position(leg_indices[i]) - get_point_position(leg_indices[i] - 1)).normalized()
		else:
			direction = (get_point_position(leg_indices[i]) - get_point_position(leg_indices[i] + 1)).normalized().rotated(PI)
		var left_direction = Vector2(-direction.y, direction.x)
		var right_direction = Vector2(direction.y, -direction.x)
		
		leg_left_position[i] = get_point_position(leg_indices[i]) + (direction * leg_target_pos.y) + (left_direction * leg_target_pos.x)
		leg_right_position[i] = get_point_position(leg_indices[i]) + (direction * leg_target_pos.y) + (right_direction * leg_target_pos.x)
		
		if leg_left_position[i].distance_to(foot_left_target[i]) > foot_reset_circle:
			foot_left_target[i] = leg_left_position[i] #+ (leg_left_position[i] - foot_left_target[i]).normalized()*foot_reset_circle
			
			pass
		
		if leg_right_position[i].distance_to(foot_right_target[i]) > foot_reset_circle:
			foot_right_target[i] = leg_right_position[i]#leg_right_position[i] + (leg_right_position[i] - foot_right_target[i]).normalized()*foot_reset_circle
			
			pass
			
		var offset_distance = width_curve.sample(leg_indices[i]/float(get_point_count())) * 2.0

		# For left leg
		var left_source = get_point_position(leg_indices[i]) + left_direction * offset_distance
		leg_joint_update(left_source, foot_left_target[i], i, leg_joints_left, -1)

		# For right leg
		var right_source = get_point_position(leg_indices[i]) + right_direction * offset_distance
		leg_joint_update(right_source, foot_right_target[i], i, leg_joints_right, 1)
		
		#print(leg_joints_left[i]) 
		pass
	pass



func _draw():
	for i in get_point_count():
		var point_pos:Vector2 = get_point_position(i)
		var offset:float = i / float(get_point_count())
		#print(offset)
		var w = width_curve.sample(offset)
		#print("W" + str(w))
		
		#draw_circle(point_pos, w*4, Color.ORANGE_RED)
		pass
	
	#for i in leg_indices.size():
		#draw_circle(get_point_position(leg_indices[i]), 10, Color.PINK)
	
		#draw_circle(leg_left_position[i], 10, Color.GREEN)
		#draw_circle(leg_left_position[i], foot_reset_circle, Color.ORANGE_RED,false)
		#draw_circle(leg_right_position[i], 10, Color.RED)
		#draw_circle(leg_right_position[i], foot_reset_circle, Color.ORANGE_RED,false)
		
		#draw_circle(foot_left_target[i], 5, Color.HOT_PINK,false)
		#var offset:float = leg_indices[i] / float(get_point_count())
		
		#for j in range(1,leg_joints_left[i].size()):
			#draw_line(leg_joints_left[i][j-1], leg_joints_left[i][j], Color.TEAL, 2* width_curve.sample(offset))
			#pass
		#draw_circle(foot_right_target[i], 5, Color.HOT_PINK,false)
		#for j in range(1,leg_joints_right[i].size()):
			#draw_line(leg_joints_right[i][j-1], leg_joints_right[i][j],Color.TEAL, 2* width_curve.sample(offset))
			#pass
		#pass
	pass
