extends Node

#var mylib = preload("res://bin/myClass.gdns").new()

func _ready():
	#var result = mylib.add_numbers(5, 7)
	#print("Result from DLL: ", result)
	#mylib.print_hello()
	var my_lib = load("res://bin/my_library.dll")
	my_lib.get_message()
