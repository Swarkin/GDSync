@tool
extends Node
class_name GDSyncIndicatorComponent

const INDICATOR_2D_SCN := preload('res://addons/godotsync/visual/indicators/2d.tscn')
const INDICATOR_3D_SCN := preload('res://addons/godotsync/visual/indicators/3d.tscn')

enum ScreenType {EDITOR_2D, EDITOR_3D, OTHER}

@export var gdsync: GDSync
var current_screen := ScreenType.OTHER
var indicator_2d_parent: Node2D
var indicator_3d_parent: Node3D

func _ready() -> void:
	gdsync.editor_plugin.main_screen_changed.connect(_on_main_screen_changed)
	gdsync.networking.session_started.connect(_on_session_started)
	gdsync.networking.session_ended.connect(_on_session_ended)

	var p := gdsync.networking.multiplayer_scene_root
	indicator_2d_parent = Node2D.new()
	indicator_3d_parent = Node3D.new()
	p.add_child(indicator_2d_parent)
	p.add_child(indicator_3d_parent)


func _on_main_screen_changed(new_screen: String) -> void:
	prints('Switched screen to', new_screen)
	# TODO: Delete and recreate all indicators upon scene change

	match new_screen:
		'2D':
			current_screen = ScreenType.EDITOR_2D
		'3D':
			current_screen = ScreenType.EDITOR_3D
		_:
			current_screen = ScreenType.OTHER

	_clear_all_indicators()
	_create_relevant_indicators(gdsync.networking.api.get_peers())


#region Indicators
func _create_relevant_indicators(peers: PackedInt32Array) -> void:
	match current_screen:
		ScreenType.EDITOR_2D:
			_create_2d_indicators(peers)
		ScreenType.EDITOR_3D:
			_create_3d_indicators(peers)
		_:
			print('No indicators to create')

func _create_2d_indicators(peers: PackedInt32Array) -> void:
	prints('Creating 3D indicators for peers', peers)

	for peer: int in peers:
		pass
		# TODO

func _create_3d_indicators(peers: PackedInt32Array) -> void:
	prints('Creating 3D indicators for peers', peers)

	for peer: int in peers:
		pass
		# TODO


func _clear_all_indicators() -> void:
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
