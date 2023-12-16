@tool
extends Button

@export_group('References')
@export var gradient_rect: TextureRect
@export var overlay_label: Label
@export var gradient_texture: GradientTexture2D

@export_group('')
@export_color_no_alpha var color: Color:
	set(v):
		color = v
		gradient_texture.gradient.colors[0] = Color(v, 0.69)
		gradient_texture.gradient.colors[1] = Color(v, 0.0)
		for override: StringName in [&'normal', &'hover', &'pressed', &'focus']:
			var stylebox := (get_theme_stylebox(override) as StyleBoxFlat).duplicate(true)
			if override == &'focus':
				stylebox.border_color = Color(v, 0.4)
			else:
				stylebox.border_color = v
			add_theme_stylebox_override(override, stylebox)

var dry_run := false
var transparency_tween: Tween = null
var scale_tween: Tween = null

func _set(property: StringName, value: Variant) -> bool:
	if property == &'text':
		text = value
		overlay_label.text = value
		return true
	return false

func _ready() -> void:
	gradient_texture = gradient_texture.duplicate(true)
	gradient_rect.texture = gradient_texture


func _process(_dt: float) -> void:
	if dry_run: return
	var mouse_pos := get_local_mouse_position()
	gradient_rect.position = mouse_pos - gradient_rect.size * 0.5


func _on_mouse_entered() -> void:
	if dry_run: return
	set_process(true)
	_clear_transparency_tween()
	transparency_tween = create_tween()
	transparency_tween.tween_property(gradient_rect, ^'modulate', Color.WHITE, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func _on_mouse_exited() -> void:
	if dry_run: return
	set_process(false)
	_clear_transparency_tween()
	transparency_tween = create_tween()
	transparency_tween.tween_property(gradient_rect, ^'modulate', Color.TRANSPARENT, 0.5)

func _on_button_down() -> void:
	if dry_run: return
	_clear_scale_tween()
	scale_tween = create_tween()
	scale_tween.tween_property(gradient_rect, ^'scale', Vector2.ONE * 0.6, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_clear_transparency_tween()
	transparency_tween = create_tween()
	transparency_tween.tween_property(gradient_rect, ^'modulate', Color(Color.WHITE, 0.6), 0.1)

func _on_button_up() -> void:
	if dry_run: return
	_clear_scale_tween()
	scale_tween = create_tween()
	scale_tween.tween_property(gradient_rect, ^'scale', Vector2.ONE, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_clear_transparency_tween()
	transparency_tween = create_tween()
	transparency_tween.tween_property(gradient_rect, ^'modulate', Color.WHITE, 0.4)


func _clear_transparency_tween() -> void:
	if transparency_tween:
		transparency_tween.kill()
	transparency_tween = null

func _clear_scale_tween() -> void:
	if scale_tween:
		scale_tween.kill()
	scale_tween = null
