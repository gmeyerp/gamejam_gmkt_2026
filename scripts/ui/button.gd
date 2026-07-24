extends Button

const BUTTON_SOUND = preload("uid://n7oef61b4pw8")
@export var unique_sound : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(on_button_pressed)

func on_button_pressed():
	if unique_sound:
		UIGlobalSound.play_sfx(unique_sound)
	else:
		UIGlobalSound.play_sfx(BUTTON_SOUND)
