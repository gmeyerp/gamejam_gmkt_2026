extends Control
class_name Dialogue

var steps: float = 0.05
var id: int = 0
var data: Dictionary = {}

@export_category("Objects")
@export var namefriend: Label = null
@export var dialogue: RichTextLabel = null
@export var face: TextureRect = null

func _ready() -> void:
	initialize_dialog()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		steps = 0.01
	else:
		steps = 0.05

	if Input.is_action_just_pressed("ui_accept"):
		if dialogue.visible_ratio < 1.0:
			dialogue.visible_ratio = 1.0
			return

		id += 1
		if id >= data.size():
			queue_free()
		else:
			initialize_dialog()

func initialize_dialog() -> void:
	if data.is_empty() or not data.has(id):
		push_error("Erro: A chave ", id, " não existe no dicionário de diálogos!")
		queue_free() 
		return

	# Carrega nome e diálogo
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
		
	dialogue.visible_characters = 0
	animate_text()

func animate_text() -> void:
	var current_id = id
	while dialogue.visible_ratio < 1.0:
		if current_id != id:
			break
		await get_tree().create_timer(steps).timeout
		dialogue.visible_characters += 1
