@tool
extends Node
class_name GDSyncIndicatorComponent

const INDICATOR_2D_SCN := preload('res://addons/godotsync/visual/indicators/2d.tscn')
const INDICATOR_3D_SCN := preload('res://addons/godotsync/visual/indicators/3d.tscn')

@export var gdsync: GDSync

var current_screen: String
var indicator_2d_parent: Node2D
var indicator_3d_parent: Node3D

func _ready() -> void:
	var plugin := gdsync.editor_plugin
	if not plugin:
		return

	plugin.main_screen_changed.connect(_on_main_screen_changed)

	var p := gdsync.networking.multiplayer_scene_root
	indicator_2d_parent = Node2D.new()
	indicator_3d_parent = Node3D.new()
	p.add_child(indicator_2d_parent)
	p.add_child(indicator_3d_parent)
	indicator_2d_parent.owner = gdsync.networking.multiplayer_scene_root
	indicator_3d_parent.owner = gdsync.networking.multiplayer_scene_root


func _on_main_screen_changed(new_screen: String) -> void:
	current_screen = new_screen
	prints('Switched screen to', new_screen)
	# TODO: Delete and recreate all indicators upon main screen change

	_clear_all_indicators()
	_create_relevant_indicators(gdsync.networking.api.get_peers())


#region Indicators
func _create_relevant_indicators(peers: PackedInt32Array) -> void:
	match current_screen:
		'2D':
			_create_2d_indicators(peers)
		'3D':
			_create_3d_indicators(peers)
		_:
			print('No indicators to create')

func _create_2d_indicators(peers: PackedInt32Array) -> void:
	prints('Creating 2D indicators for peers', peers)

	for peer: int in peers:
		var instance := INDICATOR_2D_SCN.instantiate()
		(instance.get_node(^'%Label') as Label).text = str(peer)
		indicator_2d_parent.add_child(instance)
		instance.owner = indicator_2d_parent
		# TODO

func _create_3d_indicators(peers: PackedInt32Array) -> void:
	prints('Creating 3D indicators for peers', peers)

	for peer: int in peers:
		var instance := INDICATOR_3D_SCN.instantiate()
		(instance.get_node(^'%Label3D') as Label3D).text = str(peer)
		indicator_3d_parent.add_child(instance)
		instance.owner = indicator_3d_parent
		# TODO


func _clear_all_indicators() -> void:
	print('Clearing all indicators')
	_clear_2d_indicators()
	_clear_3d_indicators()

func _clear_2d_indicators() -> void:
	print('Clearing 2D indicators')
	if indicator_2d_parent:
		for c: Node in indicator_2d_parent.get_children():
			c.queue_free()

func _clear_3d_indicators() -> void:
	print('Clearing 3D indicators')
	if indicator_3d_parent:
		for c: Node in indicator_3d_parent.get_children():
			c.queue_free()

#endregion

#region Callbacks
func _on_session_started() -> void:
	gdsync.networking.api.peer_connected.connect(_on_peer_connected)
	gdsync.networking.api.peer_disconnected.connect(_on_peer_disconnected)

func _on_session_ended() -> void:
	gdsync.networking.api.peer_connected.disconnect(_on_peer_connected)
	gdsync.networking.api.peer_disconnected.disconnect(_on_peer_disconnected)

func _on_peer_connected(id: int) -> void:
	_clear_all_indicators()
	_create_relevant_indicators(gdsync.networking.api.get_peers())

func _on_peer_disconnected(id: int) -> void:
	_clear_all_indicators()
	_create_relevant_indicators(gdsync.networking.api.get_peers())

#endregion
