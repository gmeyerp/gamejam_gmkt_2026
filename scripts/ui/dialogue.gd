extends Control
class_name Dialogue

signal dialogue_finished

@export var dialogue_speed : float = 0.5
@export var wait_after_complete : float = 3
var waiting : float = 0
var steps: float = 0.0000000000000001
var id: int = 0
var data: Dictionary = {}

@export_category("Objects")
@export var namefriend: Label = null
@export var dialogue: RichTextLabel = null
@export var face: TextureRect = null

func _ready() -> void:
	initialize_dialog()

func _process(delta: float) -> void:
	dialogue.visible_ratio += delta * dialogue_speed
	if Input.is_action_just_pressed("ui_accept"):
		if dialogue.visible_ratio < 1.0:
			dialogue.visible_ratio = 1.0
			waiting = wait_after_complete
	if dialogue.visible_ratio >= 1.0:
		waiting += delta
	if waiting >= wait_after_complete:
		id += 1
		if id >= data.size():
			dialogue_finished.emit()
			queue_free()
		else:
			initialize_dialog()

func initialize_dialog() -> void:
	waiting = 0
	dialogue.visible_ratio = 0
	if data.is_empty() or not data.has(id):
		dialogue_finished.emit()
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
		
	dialogue.visible_characters = 0
	#animate_text()

func animate_text() -> void:
	var current_id = id
	while dialogue.visible_ratio < 1.0:
		if current_id != id:
			break
		await get_tree().create_timer(steps).timeout
		dialogue.visible_characters += 1
