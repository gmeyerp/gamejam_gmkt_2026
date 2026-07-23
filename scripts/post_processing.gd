extends CanvasLayer

@onready var lens_distortion: ColorRect = $LensDistortion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_distortion(distortion: float):
	lens_distortion.material.set_shader_parameter("distortion", distortion)
