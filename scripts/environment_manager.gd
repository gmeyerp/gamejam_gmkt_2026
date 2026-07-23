extends Node3D

var max_cleaners : int
var max_maintenance : int

@export var lights : Array[Light3D]
@onready var game_lights = lights.duplicate()
@export var dirt : Array [Node3D]

func clear_office():
	for i in range(lights.size()):
		game_lights[i].repair()
		game_lights = lights.duplicate()
	for i in range(dirt.size()):
		dirt[i].clean()


func on_employee_fired(department: GlobalVariables.Department):
	match department:
		GlobalVariables.Department.Maintenance:
			on_maintenance_fired()
		GlobalVariables.Department.Cleaning:
			on_cleaner_fired()

func on_maintenance_fired():
	var rand = randi_range(0, lights.size() - 1)
	game_lights[rand].break_light()
	game_lights.remove_at(rand)

func on_cleaner_fired():
	pass
