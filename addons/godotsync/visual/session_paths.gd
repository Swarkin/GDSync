extends Control

@onready var scene := get_node(^'ScenePicker') as GDSyncScenePicker
@onready var address := get_node(^'%AddressPicker') as GDSyncAddressPicker
@onready var create_button := get_node(^'%Create') as Button
@onready var connect_button := get_node(^'%Connect') as Button
@onready var end_button := get_node(^'%End') as Button
