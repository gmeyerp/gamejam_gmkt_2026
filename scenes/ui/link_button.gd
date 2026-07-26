extends SoundButton

@export var link : String

func _ready() -> void:
	super()

func on_button_pressed():
	super()
	OS.shell_open(link)
