extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("parar_e_aguardar"):
		body.parar_e_aguardar()
