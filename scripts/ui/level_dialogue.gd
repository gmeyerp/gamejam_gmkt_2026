extends Node
class_name Level

const DialogueScreen: PackedScene = preload("res://scenes/dialogue.tscn")

@export_category("Objects")
@export var hud: CanvasLayer = null
@export var dialogue_area: Area3D = null 

@export_category("Dialogue Setup")
@export var chat: Array[String] = []
@export var personagem: Array[Texture2D] = []
@export var nameperson: Array[String] = []

var _dialogue_data: Dictionary = {}

func _ready() -> void:
	_dialogue_data = {
		0: {
			"face": personagem[0] if personagem.size() > 0 else null,
			"namefriend": nameperson[0] if nameperson.size() > 0 else "",
			"dialogue": chat[0] if chat.size() > 0 else ""
		},
		1: {
			"face": personagem[0] if personagem.size() > 0 else null,
			"namefriend":  nameperson[0] if nameperson.size() > 0 else "",
			"dialogue": chat[1] if chat.size() > 1 else ""
		},
		2: {
			"face": personagem[1] if personagem.size() > 1 else null,
			"namefriend": nameperson[1] if nameperson.size() > 0 else "",
			"dialogue": chat[2] if chat.size() > 2 else ""
		},
		3: {
			"face": personagem[0] if personagem.size() > 0 else null,
			"namefriend": nameperson[0] if nameperson.size() > 0 else "",
			"dialogue": chat[3] if chat.size() > 3 else ""
		},
	}

	if dialogue_area:
		dialogue_area.body_entered.connect(area_body)

func area_body(body: Node3D) -> void:
	if body is CharacterBody3D:
		if hud and hud.get_child_count() > 0:
			return
		if body.has_method("set_waiting"):
			body.set_waiting()
		var new_dialogue: Dialogue = DialogueScreen.instantiate()
		new_dialogue.data = _dialogue_data
		
		if body.has_method("resume_movement"):
			new_dialogue.dialogue_finished.connect(body.resume_movement)
		hud.add_child(new_dialogue)
		
		dialogue_area.set_deferred("monitoring", false)
