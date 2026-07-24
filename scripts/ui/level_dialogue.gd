extends Node
class_name Level

const DialogueScreen: PackedScene = preload("res://scenes/dialogue.tscn")

@export_category("Objects")
@export var hud: CanvasLayer = null
@export var dialogue_area: Area3D = null 

@export_category("Dialogue Setup")
@export var chat: Array[String] = []
@export var personagem: Array[Texture2D] = []

var _dialogue_data: Dictionary = {}

func _ready() -> void:
	_dialogue_data = {
		0: {
			"face": personagem[0] if personagem.size() > 0 else null,
			"namefriend": "Udan",
			"dialogue": chat[0] if chat.size() > 0 else ""
		},
		1: {
			"face": personagem[0] if personagem.size() > 0 else null,
			"namefriend": "Udan",
			"dialogue": chat[1] if chat.size() > 1 else ""
		},
		2: {
			"face": personagem[1] if personagem.size() > 1 else null,
			"namefriend": "Javelas",
			"dialogue": chat[2] if chat.size() > 2 else ""
		},
		3: {
			"face": personagem[0] if personagem.size() > 0 else null,
			"namefriend": "Udan",
			"dialogue": chat[3] if chat.size() > 3 else ""
		},
	}

	if dialogue_area:
		dialogue_area.body_entered.connect(area_body)

func area_body(body: Node3D) -> void:
	if body is CharacterBody3D:
		if hud and hud.get_child_count() > 0:
			return
			
		var new_dialogue: Dialogue = DialogueScreen.instantiate()
		new_dialogue.data = _dialogue_data
		hud.add_child(new_dialogue)
		
		dialogue_area.set_deferred("monitoring", false)
