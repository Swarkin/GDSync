@tool
extends Node
class_name GDSyncNetworking

@onready var gdsync_ui := get_node(^'../UI') as GDSyncUI
var api: MultiplayerAPI
var peer: ENetMultiplayerPeer


func _ready() -> void:
	print(get_path())
	print(get_parent().get_children())
	prints('GDSyncUI:', gdsync_ui)

#region RPCs
@rpc('any_peer', 'reliable')
func update_property(path: NodePath, property: StringName, value: Variant) -> void:
	prints('-> rpc_update_property(', path, property, value, ')')
#endregion


#func _on_session_create_pressed() -> void:
	#print('Starting Session')
#
	#peer = ENetMultiplayerPeer.new()
	#var err := peer.create_server(PORT)
	#prints('Creating Server:', error_string(err))
	#_setup_multiplayer()
#
#func _on_session_connect_pressed() -> void:
	#print('Connecting to Session')
#
	#peer = ENetMultiplayerPeer.new()
	#var err := peer.create_client('127.0.0.1', PORT)
	#prints('Creating Client:', error_string(err))
	#_setup_multiplayer()
#
#func _setup_multiplayer() -> void:
	#networking.rpc_update_property.connect(_on_rpc_update_property)
#
	#var target_scene := EditorInterface.get_open_scenes()[0]
	#prints('Target Scene:', target_scene)
	#mp_scene_root = EditorInterface.get_edited_scene_root()
#
	#api = mp_scene_root.multiplayer
	#api.multiplayer_peer = peer
#
	#api.connected_to_server.connect(_on_connected_to_server)
	#api.connection_failed.connect(_on_connection_failed)
	#api.server_disconnected.connect(_on_server_disconnected)
	#api.peer_connected.connect(_on_peer_connected)
	#api.peer_disconnected.connect(_on_peer_disconnected)
#
	#mp_active = true
#
#func _on_session_end_pressed() -> void:
	#print('Ending Session')
#
	#peer.close()
	#mp_active = false
#
#func _on_rpc_update_property(path: NodePath, property: StringName, value: Variant) -> void:
	#var node := mp_scene_root.get_node(path)
	#prints('-> rpc update_property(', node, property, value, ')')
	#node[property] = value
