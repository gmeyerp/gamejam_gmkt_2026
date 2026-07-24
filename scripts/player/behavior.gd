extends CharacterBody3D

@export var speed: float = 2.0
@export var points: Array[Node3D]

var index: int = 0
var waiting_input: bool = false

func _physics_process(_delta: float) -> void:
	if points.is_empty():
		return

	if index >= points.size():
		queue_free()
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

func parar_e_aguardar() -> void:
	waiting_input = true
