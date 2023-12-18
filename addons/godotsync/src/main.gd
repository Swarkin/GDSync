@tool
extends Node
class_name GDSync

@export var ui: GDSyncUIComponent
@export var networking: GDSyncNetworkingComponent
@export var watcher: GDSyncWatcherComponent
@export var indicator: GDSyncIndicatorComponent

var editor_plugin: GDSyncPlugin  ## Set by plugin.gd before _enter_tree()
