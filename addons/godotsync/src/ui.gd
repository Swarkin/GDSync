@tool
extends Node
class_name GDSyncUIComponent

var instance: GDSyncUIPaths
@onready var gdsync := get_parent() as GDSync

func _ready() -> void:
	instance.session.create_button_button.pressed.connect(_on_create_pressed)
	instance.session.connect_button.pressed.connect(_on_connect_pressed)
	instance.session.end_button.pressed.connect(_on_end_pressed)

#region Session Button Callbacks
func _on_create_pressed() -> void:
	pass

func _on_connect_pressed() -> void:
	pass

func _on_end_pressed() -> void:
	pass
#endregion
