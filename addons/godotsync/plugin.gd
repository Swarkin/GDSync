@tool
extends EditorPlugin
class_name GDSyncPlugin

var Main := load('res://addons/godotsync/src/main.tscn') as PackedScene
var UI := load('res://addons/godotsync/visual/ui.tscn') as PackedScene
var main_instance: GDSync
var ui_instance: Control


func setup() -> void:
	main_instance = Main.instantiate() as GDSync
	ui_instance = UI.instantiate() as Control

	main_instance.editor_plugin = self
	main_instance.ui.instance = ui_instance

	get_node(^'/root').add_child(main_instance, true)
	EditorInterface.get_editor_main_screen().add_child(ui_instance)


func cleanup() -> void:
	if ui_instance:
		ui_instance.queue_free()
	if main_instance:
		main_instance.queue_free()


#region Plugin Functions
func _enable_plugin() -> void:
	print_rich('[color=white][b] --- Enabling GDSync ---[/b][/color]')
	setup()
	_make_visible(false)

func _disable_plugin() -> void:
	print_rich('[color=white][b] --- Disabling GDSync ---[/b][/color]')
	cleanup()

func _make_visible(state: bool) -> void:
	print_rich('[color=darkgray] _make_visible(', state, ')[/color]')
	if ui_instance:
		ui_instance.visible = state


func _get_plugin_name() -> String:
	return 'Sync'

func _has_main_screen() -> bool:
	return true

func _get_plugin_icon() -> Texture2D:
	return load('res://addons/godotsync/icon.svg') as Texture2D
#endregion
