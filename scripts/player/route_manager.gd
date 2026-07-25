extends Node
class_name RouteManager

var registered_bots: Array[RouteAutomation] = []
var current_bot: RouteAutomation = null
var cooldown_timer: float = 0.0
var next_delay: float = 10.0
var started: bool = false

@export var min_interval: float = 10.0
@export var max_interval: float = 25.0

func register_bot(bot: RouteAutomation) -> void:
	if not registered_bots.has(bot):
		registered_bots.append(bot)

func start() -> void:
	started = true
	next_turn()
	$"../Boss".set_physics_process(true)

func _process(delta: float) -> void:
	if not started:
		return
	if current_bot != null:
		return


	cooldown_timer += delta
	if cooldown_timer >= next_delay:
		_start_next_bot_route()
		pass

func next_turn() -> void:
	cooldown_timer = 0.0
	next_delay = randf_range(min_interval, max_interval)

func _start_next_bot_route() -> void:
	if registered_bots.is_empty():
		print("Unregistered bot")
		return

	current_bot = registered_bots.pick_random()
	
	current_bot.execute_route()

func notify_finished(bot: RouteAutomation) -> void:
	if current_bot == bot:
		current_bot = null
		next_turn()
