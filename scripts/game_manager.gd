extends Node

var is_playing: bool
@export var max_game_time: float = 15
var game_time: float = 0

func game_start():
	game_time = 0
	is_playing = true

func _process(delta: float) -> void:
	if is_playing:
		game_time += delta

func _on_start_button_pressed() -> void:
	game_start()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
