extends Node
class_name EmployeeListManager

@export var employee_list: Array[EmployeeData]

@onready var current_employees : Array[EmployeeData] = employee_list
var next_list : Array[EmployeeData]

func reset_list():
	current_employees = employee_list

func get_average_productivity() -> float:
	var sum: float = 0
	for i in range(current_employees):
		sum += current_employees[i].production_rate
	for i in range(next_list):
		sum += current_employees[i].production_rate
	return sum

func get_average_salary() -> float:
	var sum: float = 0
	for i in range(current_employees):
		sum += current_employees[i].salary
	for i in range(next_list):
		sum += current_employees[i].salary
	return sum

func add_next_round(employee: EmployeeData):
	next_list.append(employee)

func remove_from_list(employee: EmployeeData):
	current_employees.erase(employee)

func start_new_round():
	current_employees = next_list.duplicate()
	next_list.clear()

func get_employee_list() -> Array[EmployeeData]:
	return current_employees.duplicate()
