extends Node
class_name EmployeeListManager

signal employee_fired

@export var employee_list: Array[EmployeeData]

@onready var current_employees : Array[EmployeeData] = employee_list.duplicate()
var next_list : Array[EmployeeData]

func reset_list() -> Array[EmployeeData]:
	current_employees = employee_list.duplicate()
	return current_employees.duplicate()

func get_average_productivity(department: GlobalVariables.Department) -> float:
	var sum: float = 0
	var workers: float = 0
	for i in range(current_employees.size()):
		if current_employees[i].department == department:
			sum += current_employees[i].production_rate
			workers += 1
	for i in range(next_list.size()):
		if current_employees[i].department == department:
			sum += current_employees[i].production_rate
			workers += 1
	print(GlobalVariables.Department.keys()[department])
	print("Average Productivity %s: " % GlobalVariables.Department.keys()[department]  + str(sum))
	return sum/workers

func get_average_salary(department: GlobalVariables.Department) -> float:
	var sum: float = 0
	var workers: float = 0	
	for i in range(current_employees.size()):
		if current_employees[i].department == department:
			sum += current_employees[i].salary
			workers += 1
	for i in range(next_list.size()):
		if current_employees[i].department == department:
			sum += current_employees[i].salary
			workers += 1
	print("Average Salary %s: " % GlobalVariables.Department.keys()[department] + str(sum))
	return sum/workers

func get_employee_number():
	return current_employees.size() + next_list.size()

func add_next_round(employee: EmployeeData):
	next_list.append(employee)

func remove_from_list(employee: EmployeeData):
	current_employees.erase(employee)
	employee_fired.emit()

func start_new_round():
	current_employees = next_list.duplicate()
	next_list.clear()

func get_employee_list() -> Array[EmployeeData]:
	return current_employees.duplicate()
