extends Area3D

func _ready() -> void:
	body_entered.connect(entered_body)

func entered_body(body: Node3D) -> void:
	if body.has_method("set_waiting"):
		body.set_waiting()
