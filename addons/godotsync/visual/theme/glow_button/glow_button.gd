@tool
extends Button

@export_group('References')
@export var gradient_rect: TextureRect
@export var overlay_label: Label
@export var gradient_texture: GradientTexture2D

@export_group('')
@export_color_no_alpha var color: Color:
	set(c):
		color = c
		_compute_style(c)

var dry_run := false
var transparency_tween: Tween = null
var scale_tween: Tween = null

func _set(property: StringName, value: Variant) -> bool:
	match property:
		&'text':
			text = value
			overlay_label.text = value
		&'disabled':
			disabled = value
			overlay_label.label_settings.font_color = Color.DARK_GRAY if value else Color.GAINSBORO
		_:
			return false
	return true

func _ready() -> void:
	gradient_texture = gradient_texture.duplicate(true)
	gradient_rect.texture = gradient_texture

func _process(_dt: float) -> void:
	if dry_run: return
	var mouse_pos := get_local_mouse_position()
	gradient_rect.position = mouse_pos - gradient_rect.size * 0.5


func _compute_style(c: Color, disabled_state := false) -> void:
	gradient_texture.gradient.colors[0] = Color(c, 0.69)
	gradient_texture.gradient.colors[1] = Color(c, 0.0)

	var sb := get_theme_stylebox(&'normal').duplicate(true) as StyleBoxFlat
	sb.border_color = c
	add_theme_stylebox_override(&'normal', sb)
	add_theme_stylebox_override(&'hover', sb)

	sb = sb.duplicate(true) as StyleBoxFlat
	sb.border_width_bottom = 2
	add_theme_stylebox_override(&'pressed', sb)

	sb = get_theme_stylebox(&'disabled').duplicate(true) as StyleBoxFlat
	sb.bg_color = Color(0, 0, 0, 0.2)
	sb.border_color = Color(c, 0.2)
	add_theme_stylebox_override(&'disabled', sb)

	sb = get_theme_stylebox(&'focus').duplicate(true) as StyleBoxFlat
	sb.border_color = Color(c, 0.4)
	add_theme_stylebox_override(&'focus', sb)


func _on_mouse_entered() -> void:
	if dry_run: return
	set_process(true)
	_clear_transparency_tween()
	transparency_tween = create_tween()
	transparency_tween.tween_property(gradient_rect, ^'modulate', Color.WHITE if not disabled else Color(Color.WHITE, 0.2), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

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
	transparency_tween.tween_property(gradient_rect, ^'modulate', Color.WHITE if not disabled else Color(Color.WHITE, 0.2), 0.4)


func _clear_transparency_tween() -> void:
	if transparency_tween:
		transparency_tween.kill()
	transparency_tween = null

func _clear_scale_tween() -> void:
	if scale_tween:
		scale_tween.kill()
	scale_tween = null
