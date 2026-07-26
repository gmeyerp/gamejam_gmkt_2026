extends CharacterBody3D
class_name Behavior

const DialogueScreen: PackedScene = preload("res://scenes/dialogue.tscn")

@export_category("Objects")
@export var hud: CanvasLayer = null
@export var dialogue_area: Area3D = null 
var new_dialogue: Node
var moving : bool = false

@export_category("Dialogue Setup")
@export var conversas: Array[Array] = [] 

@export var lista_de_nomes: Array[String] = [
	"April", "Amy", "Ray", "Malory", "Ron",
	"Craig", "Pam", "Creed", "Sterling", "Cheryl",
	"Lana", "Kevin", "Cyril", "Stanley", "Scott", "Jim",
]

@export var personagem: Array[Texture2D] = []
@export var nameperson: Array[String] = []

var _dialogue_data: Dictionary = {}
@export var speed: float = 3.0
@export var points: Array[Node3D]

var index: int = 0
var waiting_input: bool = false

func _ready() -> void:
	if dialogue_area:
		dialogue_area.body_entered.connect(area_body)
		dialogue_area.body_exited.connect(area_exited)
	set_physics_process(false)

func build_random_dialogue_data() -> void:
	_dialogue_data.clear()
	
	if conversas.is_empty():
		push_warning("Nenhuma conversa cadastrada para este NPC!")
		return

	var n1: String = "Alguém"
	var n2: String = "Outrem"
	
	if lista_de_nomes.size() >= 2:
		var nomes_embaralhados = lista_de_nomes.duplicate()
		nomes_embaralhados.shuffle()
		n1 = nomes_embaralhados[0]
		n2 = nomes_embaralhados[1]
	elif lista_de_nomes.size() == 1:
		n1 = lista_de_nomes[0]

	var substituicoes = {
		"nome1": n1,
		"nome2": n2
	}

	var conversa_sorteada: Array = conversas.pick_random()

	for i in range(conversa_sorteada.size()):
		var texto_bruto: String = str(conversa_sorteada[i])
		
		var texto_formatado: String = texto_bruto.format(substituicoes)

		_dialogue_data[i] = {
			"face": personagem[i] if i < personagem.size() else (personagem[0] if personagem.size() > 0 else null),
			"namefriend": nameperson[i] if i < nameperson.size() else (nameperson[0] if nameperson.size() > 0 else ""),
			"dialogue": texto_formatado
		}

func area_body(body: Node3D) -> void:
	if body is Behavior:
		if hud and hud.get_child_count() > 0:
			return
			
		body.set_waiting()
		body.build_random_dialogue_data()
			
		new_dialogue = DialogueScreen.instantiate()
		new_dialogue.data = body._dialogue_data
		
		new_dialogue.dialogue_finished.connect(func():
			if body.has_method("resume_movement"):
				body.resume_movement()
		)
		
		hud.add_child(new_dialogue)
		
		if dialogue_area:
			dialogue_area.set_deferred("monitoring", false)

func area_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		reset_dialogue_area()

func reset_dialogue_area() -> void:
	if dialogue_area:
		dialogue_area.set_deferred("monitoring", true)

func _physics_process(_delta: float) -> void:
	if points.is_empty():
		return
	if velocity != Vector3.ZERO:
		look_at_from_position(position, position - velocity)
	moving = velocity != Vector3.ZERO

	if index >= points.size():
		velocity = Vector3.ZERO
		rotation = points[0].rotation
		set_physics_process(false) 
		return

	if waiting_input:
		velocity = Vector3.ZERO
		move_and_slide()
		
		if Input.is_physical_key_pressed(KEY_1):
			waiting_input = false
			index += 1
		return

	var target_node = points[index]
	if not target_node:
		return

	var target_position: Vector3 = target_node.global_position
	var direction: Vector3 = global_position.direction_to(target_position)
	velocity = direction * speed

	move_and_slide()

	if global_position.distance_to(target_position) < 0.5:
		index += 1

func set_waiting() -> void:
	waiting_input = true

func resume_movement() -> void:
	waiting_input = false
	index += 1

func on_fired(employee: EmployeeData):
	print("Fired: " + employee.name)
	if (employee.name == name):
		("Friend fired")
		if new_dialogue:
			new_dialogue.dialogue_finished.emit()
			new_dialogue.queue_free()
		queue_free()
