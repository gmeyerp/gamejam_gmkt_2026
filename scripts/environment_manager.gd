extends Node3D
class_name EnvironmentManager

var max_cleaners: int
var max_maintenance: int

@export var lights: Array[Light3D]
@onready var game_lights = lights.duplicate()
@export var dirt: Array[Node3D]
@export var garbage_speed: float = 0
@export var garbage: PackedScene
@onready var diegetic_report: DiegeticUIDisplay = $Desk/Report/DiegeticReportUI

var garbage_timer: float = 0
const DUMP_TIMER: float = 10

func clear_office():
	for light in lights:
		if light.has_method("repair"):
			light.repair()
	game_lights = lights.duplicate()
	
	for node in dirt:
		for child in node.get_children():
			child.queue_free()
			
	garbage_speed = 0
	garbage_timer = 0
	
	diegetic_report.reset_papers()

func on_employee_fired(employee: EmployeeData):
	match employee.department:
		GlobalVariables.Department.Maintenance:
			on_maintenance_fired()
		GlobalVariables.Department.Cleaning:
			on_cleaner_fired()

func on_maintenance_fired():
	print("Office knows maintenance fired")
	if game_lights.size() == 0:
		return
	var rand = randi_range(0, game_lights.size() - 1)
	if game_lights[rand].has_method("break_light"):
		game_lights[rand].break_light()
	game_lights.remove_at(rand)

func on_cleaner_fired():
	print("Office knows cleaner fired")
	garbage_speed += 1

func _process(delta: float) -> void:
	garbage_timer += garbage_speed * delta
	if garbage_timer >= DUMP_TIMER:
		garbage_timer = 0
		create_garbage()

func create_garbage():
	if dirt.size() == 0 or not garbage:
		return
	var instance = garbage.instantiate()
	var rand = randi_range(0, dirt.size() - 1)
	dirt[rand].add_child(instance)
	instance.position += Vector3.UP * dirt[rand].get_children().size() * 0.3
