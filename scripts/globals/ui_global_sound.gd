extends AudioStreamPlayer


func play_sfx(sfx: AudioStream) -> void:
	stream = sfx
	play()
