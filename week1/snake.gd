extends Line2D

@export var segment_count = 30
@export var segment_length = 20
@export var max_angle_degrees = 30.0

func _ready() -> void:
	for i in segment_count:
		add_point(Vector2(0,i * segment_length))
		pass	
	pass

func _process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	set_point_position(0, mouse_pos)

	for i in range(1, get_point_count()):
		var cur_pos = get_point_position(i)
		var prev_pos = get_point_position(i - 1)
		var to_cur = cur_pos - prev_pos

		# Normalize direction and clamp distance
		var direction = to_cur.normalized()
		var target_pos = prev_pos + direction * segment_length

		# Angle limiting
		if i > 1:
			var base_dir = (get_point_position(i - 1) - get_point_position(i - 2)).normalized()
			var angle = base_dir.angle_to(direction)
			var max_angle = deg_to_rad(max_angle_degrees)

			if abs(angle) > max_angle:
				direction = base_dir.rotated(clamp(angle, -max_angle, max_angle))

		set_point_position(i, prev_pos + direction * segment_length)

	
	pass



func _draw():
	for i in get_point_count():
		var point_pos:Vector2 = get_point_position(i)
		var offset:float = i / float(get_point_count())
		#print(offset)
		var w = width_curve.sample(offset)
		#print("W" + str(w))
		
		draw_circle(point_pos, w*4, Color.ORANGE_RED)
		pass
	pass
