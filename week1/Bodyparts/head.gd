extends RigidBody2D

@export var body:PackedScene
@export var tail:PackedScene
@export var body_count = 4
@export var body_displacement = 20
var body_segments:Node2D

func rotate_displace_child():
	var segments:Array = body_segments.get_children()
	var previous:Node2D = self
	
	for n:Node2D in segments:
		var to_next:Vector2 = n.global_position - previous.global_position
		
		to_next = to_next.normalized()
		
		n.position = previous.position + to_next * body_displacement
		pass
	pass

func _ready() -> void:
	body_segments = find_child("body_segments")
	for i in range(body_count):
		var new_segment:RigidBody2D
		new_segment = body.instantiate()
		body_segments.add_child(new_segment)
		
		new_segment.position = Vector2(0, (i+1) * body_displacement)
		pass
	pass
	
func _process(delta: float) -> void:
	
	
	pass
