extends Behavior
class_name RouteAutomation

@export_category("Route Automation")
@export var character: CharacterBody3D
@export var min_interval: float = 10.0 
@export var max_interval: float = 30.0

var _route_timer: float = 0.0
var routine_delay: float = 0.0
var routine: bool = false

func _ready() -> void:
	if character:
		character.set_physics_process(false)
		
		_schedule_next_route()

func _process(delta: float) -> void:
	if routine:
		if character and "index" in character and "points" in character:
			if character.index >= character.points.size():
				route_completed()
		return

	_route_timer += delta
	if _route_timer >= routine_delay:
		start_route()

func _schedule_next_route() -> void:
	_route_timer = 0.0
	var real_min: float = maxf(10.0, min_interval) 
	routine_delay = randf_range(real_min, max_interval)
	

func start_route() -> void:
	if not character:
		return

	routine = true

	if "index" in character:
		character.index = 0
		
	if "waiting_input" in character:
		character.waiting_input = false

	character.set_physics_process(true)

func route_completed() -> void:
	routine = false
	
	if character:
		character.set_physics_process(false)
		
	_schedule_next_route()
