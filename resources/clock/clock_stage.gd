class_name ClockStage
extends Resource

enum FormatMode { HM, HMS, HMS_CS, HMS_MS, HMS_US }

@export var end_progress: float = 0.5
@export var target_hours: int = 17
@export var target_minutes: int = 0
@export var target_seconds: int = 0
@export var target_centiseconds: int = 0
@export var target_milliseconds: int = 0
@export var target_microseconds: int = 0
@export var format_mode: FormatMode = FormatMode.HM
@export var variant_index: int = 0
