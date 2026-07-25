extends Behavior
class_name RouteAutomation

@export_category("Route Automation")
@export var character: Behavior
@export var manager: RouteManager

var routine: bool = false

func _ready() -> void:
	if character:
		character.set_physics_process(false)
		
	if manager:
		manager.register_bot(self)

func _process(_delta: float) -> void:
	if routine and character:
		if character.index >= character.points.size():
			_on_route_completed()

func execute_route() -> void:
	print(name + "executing route")
	if not character:
		return

	routine = true
	
	character.index = 0
	character.waiting_input = false

	character.set_physics_process(true)

func _on_route_completed() -> void:
	routine = false
	
	if character:
		character.velocity = Vector3.ZERO
		character.set_physics_process(false)
		
	if manager:
		manager.notify_finished(self)
