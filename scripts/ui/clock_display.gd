class_name ClockDisplay
extends Node3D

@export var sub_viewport: SubViewport
@export var time_label: Label
@export var screen_sprite: Sprite3D
@export var base_viewport_height: int = 64
@export var font_size: int = 36

var _followed_screen: MeshInstance3D


func _ready() -> void:
	if sub_viewport == null:
		sub_viewport = get_node_or_null("SubViewport") as SubViewport
	if time_label == null and sub_viewport:
		time_label = sub_viewport.get_node_or_null("TimeLabel") as Label
	if screen_sprite == null:
		screen_sprite = get_node_or_null("ScreenSprite") as Sprite3D

	if sub_viewport:
		sub_viewport.gui_disable_input = true
		sub_viewport.handle_input_locally = false
		sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

	_apply_label_style()
	_bind_sprite_texture()


func set_time_text(text: String) -> void:
	if time_label:
		time_label.text = text


func follow_screen(screen: MeshInstance3D) -> void:
	if screen == null:
		return
	if _followed_screen and _followed_screen != screen:
		_followed_screen.visible = true
	_followed_screen = screen
	screen.visible = false

	var aabb := screen.get_aabb()
	var face_size := _face_size_from_aabb(aabb)
	var world_width := face_size.x * screen.global_transform.basis.get_scale().x
	var world_height := face_size.y * screen.global_transform.basis.get_scale().y
	world_width = absf(world_width)
	world_height = absf(world_height)
	if world_height < 0.0001:
		world_height = 0.0001

	var aspect := world_width / world_height
	var vp_height := maxi(base_viewport_height, 16)
	var vp_width := maxi(int(round(float(vp_height) * aspect)), 32)
	if sub_viewport:
		sub_viewport.size = Vector2i(vp_width, vp_height)

	if screen_sprite:
		screen_sprite.global_transform = screen.global_transform
		# Nudge slightly along local +Z so we sit in front of the bezel.
		screen_sprite.global_position += screen.global_transform.basis.z.normalized() * 0.001
		screen_sprite.centered = true
		screen_sprite.billboard = BaseMaterial3D.BILLBOARD_DISABLED
		screen_sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
		screen_sprite.pixel_size = world_height / float(vp_height)
		_bind_sprite_texture()

	_apply_label_style()


func _face_size_from_aabb(aabb: AABB) -> Vector2:
	var sx := aabb.size.x
	var sy := aabb.size.y
	var sz := aabb.size.z
	# Two largest axes = screen face (handles XY or XZ oriented screens).
	if sx >= sz and sy >= sz:
		return Vector2(sx, sy)
	if sx >= sy and sz >= sy:
		return Vector2(sx, sz)
	return Vector2(sy, sz)


func _apply_label_style() -> void:
	if time_label == null:
		return
	time_label.add_theme_font_size_override("font_size", font_size)
	time_label.clip_text = false
	time_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER


func _bind_sprite_texture() -> void:
	if screen_sprite == null or sub_viewport == null:
		return
	screen_sprite.texture = sub_viewport.get_texture()
