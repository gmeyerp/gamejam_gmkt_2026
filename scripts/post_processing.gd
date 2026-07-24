extends CanvasLayer

@onready var lens_distortion: ColorRect = $LensDistortion


func set_distortion(distortion: float):
	lens_distortion.material.set_shader_parameter("distortion", distortion)
