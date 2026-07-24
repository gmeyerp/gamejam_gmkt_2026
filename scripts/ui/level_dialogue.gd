extends Node
class_name Level

const DialogueScreen: PackedScene = preload("res://scenes/dialogue.tscn")

var _dialogue_data: Dictionary = {
	0: {
		"face": "res://resources/Udan.png",
		"namefriend": "Udan",
		"dialogue": "Hoje lá na copa fulaninho estava se gabando que vai lhe dar uma meia de presente."
	},
	1: {
		"face": "res://resources/Javelas.png",
		"namefriend": "Javelas",
		"dialogue": "Obrigado pelo aviso, ficarei de olho"
	},
}

@export_category("Objects")
@export var hud: CanvasLayer = null
@export var dialogue_area: Area3D = null 
func _ready() -> void:
	if dialogue_area:
		dialogue_area.body_entered.connect(_on_dialogue_area_body_entered)

func _on_dialogue_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if hud and hud.get_child_count() > 0:
			return
			
		var new_dialogue: Dialogue = DialogueScreen.instantiate()
		new_dialogue.data = _dialogue_data
		hud.add_child(new_dialogue)
		
		dialogue_area.set_deferred("monitoring", false)
