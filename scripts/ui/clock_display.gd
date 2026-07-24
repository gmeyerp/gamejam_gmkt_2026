class_name ClockDisplay
extends Node3D

@export var sub_viewport: SubViewport
@export var screen_mesh: MeshInstance3D
@export var time_label: Label
@export var viewport_width: int = 256
@export var viewport_height: int = 64
@export var screen_width: float = 0.22
@export var screen_height: float = 0.06
@export var font_size: int = 36


func _ready() -> void:
	if sub_viewport == null:
		sub_viewport = get_node_or_null("SubViewport") as SubViewport
	if screen_mesh == null:
		screen_mesh = get_node_or_null("ScreenMesh") as MeshInstance3D
	if time_label == null and sub_viewport:
		time_label = sub_viewport.get_node_or_null("TimeLabel") as Label

	_apply_layout()
	if sub_viewport:
		sub_viewport.gui_disable_input = true
		sub_viewport.handle_input_locally = false
		sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

	_apply_viewport_texture()


func set_time_text(text: String) -> void:
	if time_label:
		time_label.text = text


func _apply_layout() -> void:
	if sub_viewport:
		sub_viewport.size = Vector2i(viewport_width, viewport_height)
	if time_label:
		time_label.add_theme_font_size_override("font_size", font_size)
		time_label.clip_text = false
		time_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		time_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if screen_mesh:
		var quad := QuadMesh.new()
		quad.size = Vector2(screen_width, screen_height)
		screen_mesh.mesh = quad
		screen_mesh.position = Vector3(0.0, 0.0, 0.071)


func _apply_viewport_texture() -> void:
	if screen_mesh == null or sub_viewport == null:
		return
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_texture = sub_viewport.get_texture()
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
	screen_mesh.material_override = mat
