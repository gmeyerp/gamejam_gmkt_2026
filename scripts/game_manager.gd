extends Node
class_name GameManager

@export var demission_manager: DemissionManager
@export var post_processing: CanvasLayer
@onready var desk: PlayerDesk = $Office/Desk
@onready var score_number: Label = $GameHUD/Score/ScoreNumber
@onready var end_menu: CanvasLayer = $EndMenu
@onready var final_score: Label = $EndMenu/Control/Score
@onready var game_hud: CanvasLayer = $GameHUD
@onready var office: EnvironmentManager = $Office

var score: int = 0
@onready var employee_number: int = EmployeeList.get_employee_number()
@onready var employee_number_ui: Label = $GameHUD/EmployeeNumer/CurrentEmployeeNumber


var is_playing: bool = false
@export var max_game_time: float = 15.0
var game_time: float = 0.0

func _ready() -> void:
	if demission_manager:
		demission_manager.game_finished.connect(_on_demission_game_finished)

func game_start() -> void:
	game_time = 0.0
	is_playing = true
	post_processing.set_distortion(0)
	reset_score()
	end_menu.hide()
	game_hud.show()
	update_employee_number()
	office.clear_office()
	
	if demission_manager:
		demission_manager.start_game()
	
	if not desk.report.player_scored.is_connected(increase_score):
		desk.report.player_scored.connect(increase_score)
	
	if not desk.report.decision_ui.layoff_chosen.is_connected(demission_manager.process_decision):
		desk.report.decision_ui.layoff_chosen.connect(demission_manager.process_decision)
	
	if not EmployeeList.employee_fired.is_connected(on_employee_fired):
		EmployeeList.employee_fired.connect(on_employee_fired)

func _process(delta: float) -> void:
	if is_playing:
		game_time += delta
		post_processing.set_distortion(clamp(game_time/max_game_time, 0, 1 ))

func _on_start_button_pressed() -> void:
	game_start()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_demission_game_finished() -> void:
	is_playing = false
	if desk and desk.report:
		desk.report.close_inspection()
	print("Acabou os funcionários! Tempo total: ", game_time)
	end_menu.show()
	game_hud.hide()
	final_score.text = str(score)

func reset_score():
	score = 0
	update_score()

func increase_score(add_score: int):
	print("Score Change")
	score += add_score
	update_score()

func update_score():
	score_number.text = str(score)

func update_employee_number():
	employee_number_ui.text = str(EmployeeList.get_employee_number())

func on_employee_fired():
	print("Employee fired")
	update_employee_number()
