extends Control
class_name Dialogue

# 1. Crie o sinal de encerramento
signal dialogue_finished

@export var text_speed: float = 0.015
var id: int = 0
var data: Dictionary = {}

@export_category("Objects")
@export var namefriend: Label = null
@export var dialogue: RichTextLabel = null
@export var face: TextureRect = null

var _tween: Tween = null

func _ready() -> void:
	initialize_dialog()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if dialogue.visible_ratio < 1.0:
			if _tween and _tween.is_running():
				_tween.kill()
			dialogue.visible_ratio = 1.0
			return

		id += 1
		if id >= data.size():
			dialogue_finished.emit()
			queue_free()
		else:
			initialize_dialog()

func initialize_dialog() -> void:
	if data.is_empty() or not data.has(id):
		push_error("Erro: A chave ", id, " não existe no dicionário de diálogos!")
		queue_free()
		return

	if namefriend: namefriend.text = data[id]["namefriend"]
	if dialogue: dialogue.text = data[id]["dialogue"]

	if face:
		var face_data = data[id]["face"]
		if face_data is Texture2D:
			face.texture = face_data
		elif face_data is String and ResourceLoader.exists(face_data):
			face.texture = load(face_data)
		else:
			face.texture = null
		
	animate_text()

func animate_text() -> void:
	dialogue.visible_characters = 0
	if _tween and _tween.is_running():
		_tween.kill()

	var total_characters: int = dialogue.get_total_character_count()
	var duration: float = total_characters * text_speed

	_tween = create_tween()
	_tween.tween_property(dialogue, "visible_characters", total_characters, duration)
