@tool
extends Node
class_name GDSyncUIComponent

var instance: GDSyncUIPaths
@onready var gdsync := get_parent() as GDSync
@onready var session_create := instance.session.create_button.pressed as Signal
@onready var session_connect := instance.session.connect_button.pressed as Signal
@onready var session_end := instance.session.end_button.pressed as Signal
