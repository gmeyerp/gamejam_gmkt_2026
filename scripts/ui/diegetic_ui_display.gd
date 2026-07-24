class_name DiegeticUIDisplay
extends Node3D

@export var debug_input: bool = true
@export var sub_viewport: SubViewport
@export var screen_mesh: MeshInstance3D
@export var ui_root: Control
@export var camera: Camera3D
@export var linked_interactable: Interactable
@export var animation_player: AnimationPlayer

@export var papers : Array[Node3D]
var current_motive : GlobalVariables.LayoffMotive
@export var stampTexture : MeshInstance3D
@export var keepMaterial : Material
@export var fireMaterial: Material

var input_active: bool = false


func _ready() -> void:
	if sub_viewport == null:
		sub_viewport = get_node_or_null("SubViewport") as SubViewport
	if screen_mesh == null:
		screen_mesh = get_node_or_null("ScreenMesh") as MeshInstance3D
	if ui_root == null and sub_viewport:
		for child in sub_viewport.get_children():
			if child is Control:
				ui_root = child
				break

	resolve_camera()
	resolve_linked_interactable()
	if sub_viewport:
		sub_viewport.handle_input_locally = true
		sub_viewport.gui_disable_input = false

	_apply_viewport_texture()
	set_input_active(false)
	
	reset_papers()

func reset_papers():
	for i in range(papers.size()):
		papers[i].show()

func set_input_active(active: bool) -> void:
	input_active = active
	resolve_camera()
	set_process_input(active)


func get_ui() -> Control:
	return ui_root


func get_linked_interactable() -> Interactable:
	resolve_linked_interactable()
	return linked_interactable


func resolve_linked_interactable() -> void:
	if is_instance_valid(linked_interactable):
		return
	var parent := get_parent()
	if parent == null:
		return
	for child in parent.get_children():
		if child is Interactable:
			linked_interactable = child
			return


func resolve_camera() -> void:
	if is_instance_valid(camera):
		return
	camera = get_viewport().get_camera_3d()
	if camera == null:
		var office := _find_ancestor_named("Office")
		if office:
			camera = office.get_node_or_null("Camera3D") as Camera3D
	if camera == null:
		camera = get_tree().root.find_child("Camera3D", true, false) as Camera3D


func _find_ancestor_named(node_name: String) -> Node:
	var current: Node = self
	while current:
		if current.name == node_name:
			return current
		current = current.get_parent()
	return null


func _apply_viewport_texture() -> void:
	if screen_mesh == null or sub_viewport == null:
		return
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_texture = sub_viewport.get_texture()
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
	screen_mesh.material_override = mat


func _input(event: InputEvent) -> void:
	if not input_active or sub_viewport == null or screen_mesh == null:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		return
	if not (event is InputEventMouseButton or event is InputEventMouseMotion):
		return

	resolve_camera()
	if camera == null:
		if debug_input and event is InputEventMouseButton and event.pressed:
			print("[DiegeticUI] ", name, " skip: camera still null")
		return

	var pos_2d: Variant = _mouse_to_viewport_pos()
	if pos_2d == null:
		if debug_input and event is InputEventMouseButton and event.pressed:
			print("[DiegeticUI] ", name, " skip: ray missed ScreenMesh")
		return

	var mapped_pos: Vector2 = pos_2d
	var mapped := event.duplicate() as InputEvent
	if mapped is InputEventMouse:
		mapped.position = mapped_pos
		mapped.global_position = mapped_pos
	sub_viewport.push_input(mapped)

	if debug_input and event is InputEventMouseButton and event.pressed:
		var hovered := sub_viewport.gui_get_hovered_control()
		var hovered_name := "null"
		if hovered:
			hovered_name = hovered.name
		print("[DiegeticUI] push LMB pos=", mapped_pos, " hovered=", hovered_name)


func _mouse_to_viewport_pos() -> Variant:
	var quad := screen_mesh.mesh as QuadMesh
	if quad == null:
		return null

	var mouse := get_viewport().get_mouse_position()
	var origin := camera.project_ray_origin(mouse)
	var direction := camera.project_ray_normal(mouse)

	var xf := screen_mesh.global_transform
	var plane := Plane(xf.basis.z.normalized(), xf.origin)
	var hit: Variant = plane.intersects_ray(origin, direction)
	if hit == null:
		return null

	var local: Vector3 = xf.affine_inverse() * (hit as Vector3)
	var half := quad.size * 0.5
	if absf(local.x) > half.x or absf(local.y) > half.y:
		return null

	var uv := Vector2(local.x / quad.size.x + 0.5, -local.y / quad.size.y + 0.5)
	return Vector2(uv.x * float(sub_viewport.size.x), uv.y * float(sub_viewport.size.y))


func _on_layoff_chosen(motive: GlobalVariables.LayoffMotive) -> void:
	set_input_active(false)
	current_motive = motive
	animation_player.play("send_report")

func stamp():
	if current_motive == GlobalVariables.LayoffMotive.Keep:
		stampTexture.material_override = keepMaterial
	else:
		stampTexture.material_override = fireMaterial

func update_papers() -> void:
	var employees = EmployeeList.get_employee_number()
	if employees <= 13:
		papers[4].hide()
	if employees <= 10:
		papers[3].hide()
	if employees <= 7:
		papers[2].hide()
	if employees == 2:
		papers[1].hide()
	if employees == 1:
		papers[0].hide()
	if employees == 0:
		animation_player.stop()
