extends ColorRect

func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value/100)


func _on_ui_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("UI"), value/100)


func _on_bgm_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("BGM"), value/100)


func _on_return_pressed() -> void:
	hide()


func _on_configue_pressed() -> void:
	show()
