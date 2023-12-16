@tool
extends Node
class_name GDSyncNetworkingComponent

const PORT := 25567
@export var gdsync: GDSync

var api: MultiplayerAPI
var peer: ENetMultiplayerPeer
var multiplayer_scene_root: Node

func _ready() -> void:
	var s := gdsync.ui.instance.session_panel
	s.create_button.pressed.connect(_on_create_pressed)
	s.connect_button.pressed.connect(_on_connect_pressed)
	s.end_button.pressed.connect(_on_end_pressed)


func setup_multiplayer() -> void:
	multiplayer_scene_root = EditorInterface.get_edited_scene_root()
	multiplayer_scene_root.multiplayer.multiplayer_peer = peer
	gdsync.watcher.node_property_changed.connect(_on_node_property_changed)

func reset_multiplayer() -> void:
	if peer:
		peer.close()
		peer = null
	if multiplayer_scene_root:
		multiplayer_scene_root.multiplayer.multiplayer_peer = null
		multiplayer_scene_root = null

# Callbacks
#region Session
func _on_create_pressed() -> void:
	print(' Creating Session')

	peer = ENetMultiplayerPeer.new()
	var err := peer.create_server(PORT)
	if err:
		push_error('Couldn\'t create Server: ', error_string(err))
		reset_multiplayer()
		return

	setup_multiplayer()
	gdsync.watcher.start()

func _on_connect_pressed() -> void:
	print(' Connecting to Session')

	var address := gdsync.ui.instance.session_panel.address_picker.ip  # '127.0.0.1'
	if address.is_empty():
		push_error('Address field is empty.')
		return

	peer = ENetMultiplayerPeer.new()
	var err := peer.create_client(address, PORT)
	if err:
		push_error('Couldn\'t create Client: ', error_string(err))
		reset_multiplayer()
		return

	setup_multiplayer()
	gdsync.watcher.start()

func _on_end_pressed() -> void:
	print(' Ending Session')

	reset_multiplayer()
	gdsync.watcher.stop()
#endregion
#region Multiplayer
func _on_connected_to_server() -> void:  # Client
	print_rich('[color=white]connected_to_server[/color]')

func _on_connection_failed() -> void:    # Client
	print_rich('[color=white]connection_failed[/color]')

func _on_server_disconnected() -> void:  # Client
	print_rich('[color=white]server_disconnected[/color]')

func _on_peer_connected(id: int) -> void:
	print_rich('[color=white]peer_connected(id: ', id, ')[/color]')

func _on_peer_disconnected(id: int) -> void:
	print_rich('[color=white]peer_disconnected(id: ', id, ')[/color]')
#endregion
#region Signals
func _on_node_property_changed(node: Node, property: String) -> void:
	update_property.rpc(gdsync.watcher.relative_path_to(node), property, node[property])
#endregion

#region RPCs
@rpc('any_peer', 'call_local', 'reliable')
func update_property(path: NodePath, property: String, value: Variant) -> void:
	print('-> rpc update_property(path: NodePath = ', path, ', property: String = ', property, 'value: Variant = ', value, ')')
	var node := multiplayer_scene_root.get_node(path)
#endregion
