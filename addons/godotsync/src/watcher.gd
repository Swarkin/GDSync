@tool
extends Node
class_name GDSyncWatcherComponent

#signal relevant_node_added(node: Node)
#signal relevant_node_removed(node: Node)
signal node_property_changed(node: Node, property: String)
#signal node_selection_changed(node: Node)

@export var gdsync: GDSync

var editor_inspector := EditorInterface.get_inspector()
var tree: SceneTree
var edited_object: Object
var selected_node: Node

func start() -> void:
	print('Starting Watcher')

	tree = get_tree()
	tree.node_added.connect(_on_node_added)
	tree.node_removed.connect(_on_node_removed)
	editor_inspector.edited_object_changed.connect(_on_edited_object_changed)
	editor_inspector.property_edited.connect(_on_property_edited)

func stop() -> void:
	print('Stopping Watcher')

	tree.node_added.disconnect(_on_node_added)
	tree.node_removed.disconnect(_on_node_removed)
	editor_inspector.edited_object_changed.disconnect(_on_edited_object_changed)
	editor_inspector.property_edited.disconnect(_on_property_edited)
	tree = null
	edited_object = null
	selected_node = null

func _is_relevant(node: Node) -> bool:
	if EditorInterface.get_edited_scene_root().get_parent().is_ancestor_of(node):
		return true
	return false

func relative_path_to(node: Node) -> NodePath:
	return EditorInterface.get_edited_scene_root().get_path_to(node)

#region Callbacks
func _on_node_added(node: Node) -> void:
	if _is_relevant(node):
		prints('+', node)
		#relevant_node_added.emit(node)

func _on_node_removed(node: Node) -> void:
	if _is_relevant(node):
		prints('-', node)
		#relevant_node_removed.emit(node)

func _on_edited_object_changed() -> void:
	var obj := editor_inspector.get_edited_object()
	edited_object = obj

	if obj is Node:
		selected_node = obj
		#node_selection_changed.emit(obj)
	elif selected_node:
		selected_node = null

func _on_property_edited(property: String) -> void:
	if edited_object is Node:
		var path := relative_path_to(edited_object)
		print(path, ':', property, ' = ', edited_object[property])

		node_property_changed.emit(edited_object, property)
	else:
		prints(edited_object, property, '=', edited_object[property])
#endregion
