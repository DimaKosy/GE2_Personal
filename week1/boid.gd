extends CharacterBody3D

@export var target:Node3D
@export var force:Vector3
#@export var acc:Vector3

@export var mass:float = 1
@export var max_speed = 10

func _ready():
	pass
	
func _process(delta: float):
	var force = seek(target)
	
	var accel = force/mass
	
	velocity = velocity + accel
	
	move_and_slide()
	
	pass

func seek(target:Node3D) -> Vector3:
	var to_target = target.global_position - global_position
	var desired = to_target.normalized() * max_speed
	
	#print(to_target.x, " : ", to_target.z)
	draw_gizmos()
	
	return  desired - velocity
	
func draw_gizmos():
	DebugDraw3D.draw_arrow(global_position, global_position + force, Color.AQUAMARINE, 0.1)
	DebugDraw3D.draw_arrow(global_position, global_position + global_basis.x * 10, Color.AQUAMARINE, 0.1)
	DebugDraw3D.draw_arrow(global_position, global_position + velocity, Color.CRIMSON, 0.1)
	DebugDraw3D.draw_arrow(global_position, global_position + global_basis.y * 10, Color.CRIMSON, 0.1)
	DebugDraw2D.set_text("Velocity: ", velocity)
