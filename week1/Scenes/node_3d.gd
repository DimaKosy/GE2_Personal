extends Node3D

func _ready() -> void:
	var lib = load("res://bin/mylib.dll")
	
	print(lib.add(1,1))
