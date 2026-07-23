extends CharacterBody3D

@export var speed: float = 2.0
@export var points: Array[Vector3] = [
	Vector3(5, 0, -5),
	Vector3(5, 0, 0),
	Vector3(1, 0, 0),
	Vector3(1, 0, 0),
	Vector3(5, 0, 0),
	Vector3(5, 0, 5)
]

var index: int = 0
var waiting_input: bool = false

func _physics_process(_delta: float) -> void:
	if points.is_empty():
		return

	if waiting_input:
		velocity = Vector3.ZERO
		move_and_slide()
		if Input.is_physical_key_pressed(KEY_1):
			waiting_input = false
			index += 1
		return

	var target_position: Vector3 = points[index]
	var direction: Vector3 = global_position.direction_to(target_position)
	velocity = direction * speed

	move_and_slide()

	if global_position.distance_to(target_position) < 0.5:
		if index == 2:
			waiting_input = true
		else:
			index += 1

		if index >= points.size():
			queue_free()
