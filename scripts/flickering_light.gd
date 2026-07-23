extends SpotLight3D
@onready var animation: AnimationPlayer = $AnimationPlayer

func repair():
	animation.play("RESET")

func break_light():
	animation.play("broken")
