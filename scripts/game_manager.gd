extends Node
class_name GameManager

@export var demission_manager: DemissionManager
@export var post_processing: CanvasLayer

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
	
	if demission_manager:
		demission_manager.start_game()

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
	print("Acabou os funcionários! Tempo total: ", game_time)
