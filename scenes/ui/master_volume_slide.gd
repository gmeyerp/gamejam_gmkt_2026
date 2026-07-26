extends HSlider




func _on_visibility_changed() -> void:
	value = AudioServer.get_bus_volume_linear(0) * 100
