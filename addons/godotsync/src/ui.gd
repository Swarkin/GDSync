@tool
extends Node
class_name GDSyncUIComponent

signal session_create_pressed
signal session_connect_pressed
signal session_stop_pressed

var instance: GDSyncUIPaths
@onready var gdsync := get_parent() as GDSync


func _ready() -> void:
	instance.session.connect_button.pressed.connect()

#region Session Button Callbacks
func
#endregion
