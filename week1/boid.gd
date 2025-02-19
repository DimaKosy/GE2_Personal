extends CharacterBody3D

@export var target:Node3D
#@export var force:Node3D
#@export var acc:Vector3

@export var mass:float = 1
@export var max_speed = 10

func _ready():
	pass
	
func _process(delta: float):
	var force = seek(target)
	
	var accel = force/mass
	
	velocity = Vector3(0,0,1)
	
	move_and_slide()
	
	pass

func seek(target:Node3D) -> Vector3:
	var to_target = target.global_position - global_position
	var desired = to_target.normalized() * max_speed
	
	return  desired - velocity
