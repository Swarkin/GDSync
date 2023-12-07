extends Control

var ip := '127.0.0.1'
var port := 25567

@onready var ip_err := %IPError as Label
@onready var port_err := %PortError as Label

func _ready() -> void:
	validate_ip(ip)
	validate_port(str(port))


func validate_ip(new_text: String) -> void:
	if new_text.is_valid_ip_address():
		ip = new_text
		ip_err.visible = false
	else:
		ip = ''
		ip_err.visible = true

func validate_port(new_text: String) -> void:
	var new_port := new_text.to_int()

	if new_port > 0 and new_port < 65536:
		port = new_port
		port_err.visible = false
	else:
		port = 0
		port_err.visible = true
