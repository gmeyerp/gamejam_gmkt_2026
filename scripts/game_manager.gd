extends Node
class_name GameManager

@export var demission_manager: DemissionManager
@export var post_processing: CanvasLayer
@onready var desk: PlayerDesk = $Office/Desk
@onready var computer: DeskComputer = $Office/Desk/Computer
@onready var gameplay_controller: GameplayController = $GameplayController
@onready var score_number: Label = $GameHUD/Score/ScoreNumber
@onready var end_menu: CanvasLayer = $EndMenu
@onready var final_score: Label = $EndMenu/Control/Score
@onready var game_hud: CanvasLayer = $GameHUD
@onready var office: EnvironmentManager = $Office
@onready var route_manager: RouteManager = $Route_Manager

var score: int = 0
@onready var employee_number: int = EmployeeList.get_employee_number()
@onready var employee_number_ui: Label = $GameHUD/EmployeeNumer/CurrentEmployeeNumber


var is_playing: bool = false
@export var max_game_time: float = 15.0
var game_time: float = 0.0

func _ready() -> void:
	game_hud.hide()
	if demission_manager:
		demission_manager.game_finished.connect(_on_demission_game_finished)
	_connect_computer_os()
	if gameplay_controller:
		gameplay_controller.enter_menu()

func _connect_computer_os() -> void:
	if computer == null:
		return
	if computer.os_ui == null and computer.diegetic_display:
		computer.os_ui = computer.diegetic_display.get_ui()
	var os_ui: Control = computer.os_ui
	if os_ui == null:
		return
	if os_ui.has_signal("start_pressed") and not os_ui.start_pressed.is_connected(_on_os_start_pressed):
		os_ui.start_pressed.connect(_on_os_start_pressed)
	if os_ui.has_signal("quit_app_pressed") and not os_ui.quit_app_pressed.is_connected(_on_quit_button_pressed):
		os_ui.quit_app_pressed.connect(_on_quit_button_pressed)
	if os_ui.has_signal("return_to_boot_requested") and not os_ui.return_to_boot_requested.is_connected(return_to_title):
		os_ui.return_to_boot_requested.connect(return_to_title)

func _on_os_start_pressed() -> void:
	game_start()
	#isso nao deveria estar dentro do game start?
	if gameplay_controller:
		gameplay_controller.on_start_game_pressed()

func game_start() -> void:
	game_time = 0.0
	route_manager.start()
	is_playing = true
	post_processing.set_distortion(0)
	reset_score()
	end_menu.hide()
	game_hud.show()
	EmployeeList.reset_list()
	update_employee_number()
	office.clear_office()
	if desk and desk.clock:
		desk.clock.reset_clock()

	if demission_manager:
		demission_manager.start_game()

	if computer and computer.os_ui and computer.os_ui.has_method("show_desktop"):
		computer.os_ui.show_desktop()

	if not desk.report.player_scored.is_connected(increase_score):
		desk.report.player_scored.connect(increase_score)

	if not desk.report.decision_ui.layoff_chosen.is_connected(demission_manager.process_decision):
		desk.report.decision_ui.layoff_chosen.connect(demission_manager.process_decision)

	if not EmployeeList.employee_fired.is_connected(on_employee_fired):
		EmployeeList.employee_fired.connect(on_employee_fired)

func return_to_title() -> void:
	is_playing = false
	if demission_manager:
		demission_manager.stop_game()
	if desk and desk.report:
		desk.report.close_inspection()
	end_menu.hide()
	game_hud.hide()
	reset_score()
	game_time = 0.0
	post_processing.set_distortion(0)
	EmployeeList.reset_list()
	update_employee_number()
	office.clear_office()
	if desk and desk.clock:
		desk.clock.reset_clock()
	if gameplay_controller:
		gameplay_controller.enter_menu()
	if computer and computer.os_ui and computer.os_ui.has_method("show_boot"):
		computer.os_ui.show_boot()

func _process(delta: float) -> void:
	if is_playing:
		game_time += delta
		var progress: float = clampf(game_time / max_game_time, 0.0, 1.0)
		post_processing.set_distortion(progress)
		if desk and desk.clock:
			desk.clock.on_clock_tick(game_time, max_game_time)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_demission_game_finished() -> void:
	is_playing = false
	if demission_manager:
		demission_manager.stop_game()
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
