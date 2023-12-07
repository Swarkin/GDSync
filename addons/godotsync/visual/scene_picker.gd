extends Control
class_name GDSyncScenePicker

var selected_scene: PackedScene
@onready var label := %SceneLabel as Label


func _on_file_selected(path: String) -> void:
	selected_scene = load(path)
	if selected_scene:
		label.text = path
	else:
		label.text = 'No Scene selected'

func clear() -> void:
	selected_scene = null
	label.text = 'No Scene selected'
