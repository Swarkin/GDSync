@tool
extends Control
class_name GDSyncScenePicker

@export var scene_label: Label
var selected_scene: PackedScene


func _on_file_selected(path: String) -> void:
	selected_scene = load(path)
	if selected_scene:
		scene_label.text = path
	else:
		scene_label.text = 'No Scene selected'

func clear() -> void:
	selected_scene = null
	scene_label.text = 'No Scene selected'
