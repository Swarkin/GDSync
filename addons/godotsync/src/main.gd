@tool
extends Node
class_name GDSync

var editor_inspector := EditorInterface.get_inspector()
var editor_plugin: GDSyncPlugin  ## Set by plugin.gd before _enter_tree()

@export var networking: GDSyncNetworkingComponent
@export var ui: GDSyncUIComponent

#func _ready() -> void:
	#var tree := get_tree()
	#tree.node_added.connect(_on_node_added)
	#tree.node_removed.connect(_on_node_removed)
	#scene_changed.connect(_on_scene_changed)
	#scene_closed.connect(_on_scene_closed)
#
	#(ui_instance.get_node(^'%Session/%Create') as Button).pressed.connect(_on_session_create_pressed)
	#(ui_instance.get_node(^'%Session/%Connect') as Button).pressed.connect(_on_session_connect_pressed)
	#(ui_instance.get_node(^'%Session/%End') as Button).pressed.connect(_on_session_end_pressed)
#
	#inspector.edited_object_changed.connect(_on_edited_object_changed)
	#inspector.property_edited.connect(_on_property_edited)


##region Editor Callbacks
#var edited_object: Object
#
#func _on_node_added(node: Node) -> void:
	#if EditorInterface.get_edited_scene_root().get_parent().is_ancestor_of(node):
		#prints('+', node)
#
#func _on_node_removed(node: Node) -> void:
	#if EditorInterface.get_edited_scene_root().get_parent().is_ancestor_of(node):
		#prints('-', node)
#
#func _on_scene_changed(root: Node) -> void:
	#prints('Scene changed:', root)
#
#func _on_scene_closed(filepath: String) -> void:
	#prints('Scene closed:', filepath)
#
#func _on_edited_object_changed() -> void:
	#edited_object = inspector.get_edited_object()
	#prints('Edited Object changed:', edited_object)
#
#func _on_property_edited(property: String) -> void:
	#prints('Edited:', property)
	#if not edited_object is Node or not mp_active:
		#return
#
	#if EditorInterface.get_edited_scene_root().get_parent().is_ancestor_of(edited_object):
		#prints('<- rpc update_property(', edited_object, property, edited_object[property], ')')
		#networking.update_property.rpc(mp_scene_root.get_path_to(edited_object), property, edited_object[property])
##endregion
