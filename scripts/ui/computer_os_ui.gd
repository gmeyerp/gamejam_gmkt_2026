class_name ComputerOsUI
extends Control

signal start_pressed
signal quit_app_pressed
signal return_to_boot_requested

@onready var boot_screen: Control = $BootScreen
@onready var desktop: Control = $Desktop
@onready var rulebook_window: ComputerRulebookUI = $RulebookWindow
@onready var quit_confirm: Control = $QuitConfirmDialog

@onready var _boot_start: Button = $BootScreen/Center/VBox/StartButton
@onready var _boot_quit: Button = $BootScreen/Center/VBox/QuitButton
@onready var _rulebook_icon: Button = $Desktop/Icons/RulebookIcon
@onready var _quit_icon: Button = $Desktop/Icons/QuitIcon
@onready var _confirm_yes: Button = $QuitConfirmDialog/Panel/VBox/Buttons/ConfirmButton
@onready var _confirm_no: Button = $QuitConfirmDialog/Panel/VBox/Buttons/CancelButton


func _ready() -> void:
	_boot_start.pressed.connect(_on_boot_start)
	_boot_quit.pressed.connect(_on_boot_quit)
	_rulebook_icon.pressed.connect(open_rulebook)
	_quit_icon.pressed.connect(open_quit_confirm)
	_confirm_yes.pressed.connect(_on_quit_confirmed)
	_confirm_no.pressed.connect(close_quit_confirm)
	if rulebook_window and not rulebook_window.close_requested.is_connected(close_rulebook):
		rulebook_window.close_requested.connect(close_rulebook)
	show_boot()


func show_boot() -> void:
	boot_screen.visible = true
	desktop.visible = false
	_set_rulebook_visible(false)
	quit_confirm.visible = false


func show_desktop() -> void:
	boot_screen.visible = false
	desktop.visible = true
	_set_rulebook_visible(false)
	quit_confirm.visible = false


func open_rulebook() -> void:
	quit_confirm.visible = false
	_set_rulebook_visible(true)
	if rulebook_window:
		rulebook_window.show_ui()


func close_rulebook() -> void:
	_set_rulebook_visible(false)


func open_quit_confirm() -> void:
	_set_rulebook_visible(false)
	quit_confirm.visible = true


func close_quit_confirm() -> void:
	quit_confirm.visible = false


func get_rulebook() -> ComputerRulebookUI:
	return rulebook_window


func _set_rulebook_visible(value: bool) -> void:
	if rulebook_window:
		rulebook_window.visible = value


func _on_boot_start() -> void:
	start_pressed.emit()


func _on_boot_quit() -> void:
	quit_app_pressed.emit()


func _on_quit_confirmed() -> void:
	quit_confirm.visible = false
	return_to_boot_requested.emit()
