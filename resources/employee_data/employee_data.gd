extends Resource
class_name EmployeeData

@export var name: String
@export var age: int
@export var department: GlobalVariables.Department = GlobalVariables.Department.Office

@export var layoff_round: int
@export var layoff_motive: GlobalVariables.LayoffMotive

@export var production_rate: float
@export var salary: float
@export var commentary: Array[String] = []
