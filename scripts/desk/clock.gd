class_name DeskClock
extends Node3D

const START_HOURS := 12
const START_MINUTES := 0
const START_SECONDS := 0
const START_CENTISECONDS := 0
const START_MILLISECONDS := 0
const START_MICROSECONDS := 0

@export var stages: Array[ClockStage] = []
@export var variants: Array[Node3D] = []

var _active_variant_index: int = -1
var _displays: Array[ClockDisplay] = []


func _ready() -> void:
	if stages.is_empty():
		stages = _make_default_stages()
	_cache_displays()
	_activate_variant(0)
	_update_from_progress(0.0)


func on_interact() -> void:
	pass


func on_deselect() -> void:
	pass


func reset_clock() -> void:
	_activate_variant(0)
	_update_from_progress(0.0)


func on_clock_tick(game_time: float, max_time: float) -> void:
	var progress := 0.0
	if max_time > 0.0:
		progress = clampf(game_time / max_time, 0.0, 1.0)
	_update_from_progress(progress)


func _update_from_progress(progress: float) -> void:
	if stages.is_empty():
		return

	var start_progress := 0.0
	var start_face := _face_start_of_game()
	var active_stage: ClockStage = stages[stages.size() - 1]
	var within_stage := false

	for i in stages.size():
		var stage: ClockStage = stages[i]
		if stage == null:
			continue
		if progress <= stage.end_progress:
			active_stage = stage
			within_stage = true
			if i > 0:
				var prev: ClockStage = stages[i - 1]
				start_progress = prev.end_progress
				start_face = _face_from_stage(prev)
			break
		start_progress = stage.end_progress
		start_face = _face_from_stage(stage)

	var end_face := _face_from_stage(active_stage)
	var local_t := 1.0
	if within_stage and active_stage.end_progress > start_progress:
		local_t = clampf(inverse_lerp(start_progress, active_stage.end_progress, progress), 0.0, 1.0)

	var face := _lerp_face(start_face, end_face, local_t)
	_activate_variant(active_stage.variant_index)
	_set_display_text(_format_face(face, active_stage.format_mode))


func _activate_variant(index: int) -> void:
	if index == _active_variant_index:
		return
	_active_variant_index = index
	for i in variants.size():
		if variants[i]:
			variants[i].visible = i == index


func _set_display_text(text: String) -> void:
	if _active_variant_index < 0 or _active_variant_index >= _displays.size():
		return
	var display := _displays[_active_variant_index]
	if display:
		display.set_time_text(text)


func _cache_displays() -> void:
	_displays.clear()
	for variant in variants:
		var display: ClockDisplay = null
		if variant:
			display = variant.get_node_or_null("ClockDisplay") as ClockDisplay
			if display == null:
				for child in variant.get_children():
					if child is ClockDisplay:
						display = child
						break
		_displays.append(display)


func _face_start_of_game() -> Dictionary:
	return {
		"h": START_HOURS,
		"m": START_MINUTES,
		"s": START_SECONDS,
		"cs": START_CENTISECONDS,
		"ms": START_MILLISECONDS,
		"us": START_MICROSECONDS,
	}


func _face_from_stage(stage: ClockStage) -> Dictionary:
	return {
		"h": stage.target_hours,
		"m": stage.target_minutes,
		"s": stage.target_seconds,
		"cs": stage.target_centiseconds,
		"ms": stage.target_milliseconds,
		"us": stage.target_microseconds,
	}


func _lerp_face(from_face: Dictionary, to_face: Dictionary, t: float) -> Dictionary:
	var clamped_t := clampf(t, 0.0, 1.0)
	return {
		"h": int(round(lerp(float(from_face["h"]), float(to_face["h"]), clamped_t))),
		"m": int(round(lerp(float(from_face["m"]), float(to_face["m"]), clamped_t))),
		"s": int(round(lerp(float(from_face["s"]), float(to_face["s"]), clamped_t))),
		"cs": int(round(lerp(float(from_face["cs"]), float(to_face["cs"]), clamped_t))),
		"ms": int(round(lerp(float(from_face["ms"]), float(to_face["ms"]), clamped_t))),
		"us": int(round(lerp(float(from_face["us"]), float(to_face["us"]), clamped_t))),
	}


func _format_face(face: Dictionary, format_mode: ClockStage.FormatMode) -> String:
	var h: int = face["h"]
	var m: int = face["m"]
	var s: int = face["s"]
	var cs: int = face["cs"]
	var ms: int = face["ms"]
	var us: int = face["us"]

	match format_mode:
		ClockStage.FormatMode.HMS:
			return "%02d:%02d:%02d" % [h, m, s]
		ClockStage.FormatMode.HMS_CS:
			return "%02d:%02d:%02d:%02d" % [h, m, s, cs]
		ClockStage.FormatMode.HMS_MS:
			return "%02d:%02d:%02d:%02d:%03d" % [h, m, s, cs, ms]
		ClockStage.FormatMode.HMS_US:
			return "%02d:%02d:%02d:%02d:%03d:%03d" % [h, m, s, cs, ms, us]
		_:
			return "%02d:%02d" % [h, m]


func _make_default_stages() -> Array[ClockStage]:
	var result: Array[ClockStage] = []
	result.append(_make_stage(0.5, 17, 0, 0, 0, ClockStage.FormatMode.HM, 0))
	result.append(_make_stage(0.75, 17, 50, 0, 0, ClockStage.FormatMode.HM, 0))
	result.append(_make_stage(0.875, 17, 59, 0, 0, ClockStage.FormatMode.HM, 0))
	result.append(_make_stage(0.9375, 17, 59, 59, 0, ClockStage.FormatMode.HMS, 1))
	result.append(_make_stage(0.96875, 17, 59, 59, 99, ClockStage.FormatMode.HMS_CS, 2))
	return result


func _make_stage(
	end_progress: float,
	hours: int,
	minutes: int,
	seconds: int,
	centiseconds: int,
	format_mode: ClockStage.FormatMode,
	variant_index: int
) -> ClockStage:
	var stage := ClockStage.new()
	stage.end_progress = end_progress
	stage.target_hours = hours
	stage.target_minutes = minutes
	stage.target_seconds = seconds
	stage.target_centiseconds = centiseconds
	stage.format_mode = format_mode
	stage.variant_index = variant_index
	return stage
