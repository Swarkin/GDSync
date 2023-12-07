@tool
extends Node
class_name GDSyncUI

signal session_create_pressed
signal session_connect_pressed
signal session_stop_pressed


var ui_instance := (get_node(^'../') as GDSync).plugin_ui_instance
