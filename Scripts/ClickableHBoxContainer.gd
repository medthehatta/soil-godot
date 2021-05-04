# ClickableHBoxContainer.gd

extends MarginContainer

signal item_selected(it)
signal row_selected(row)
signal field_selected(field)

var button
var hbox

var starting_color
var is_ready = false

export(Resource) var config
var item = {}


func _ready():
    button = $Button
    hbox = $HBox
    set_anchors_and_margins_preset(PRESET_TOP_WIDE)
    set_custom_minimum_size(Vector2(0, config.row_height))
    if item:
        _populate(item)
    starting_color = get_modulate()
    is_ready = true


func setup(p_config : Resource, p_item : Dictionary = {}):
    config = p_config
    item = p_item
    return self


func _populate(it):
    for f_fw in Utilities.zip(config.fields, config.field_widths):
        var field = f_fw[0]
        var width = f_fw[1]
        var entry = _make_item_field(it[field], width)
        hbox.add_child(entry)
    return self


func _make_item_field(value, width):
    var entry = preload("res://Scenes/InformedButton.tscn").instance()
    entry.inform(value)
    entry.set_theme(preload("res://Resources/FlatButtonStyleBox.tres"))
    entry.set_clip_text(true)
    entry.set_text(str(value))
    if width == -1:
        entry.set_custom_minimum_size(Vector2(0, config.row_height))
        entry.set_h_size_flags(SIZE_EXPAND_FILL)
    else:
        entry.set_custom_minimum_size(Vector2(width, config.row_height))
    entry.add_font_override("font", config.font)
    entry.set_text_align(0)  # ALIGN_LEFT
    entry.connect("clicked", self, "_on_Button_pressed")
    return entry


func _on_Button_pressed(data):
    # Don't emit any signals if we aren't ready yet
    if is_ready:
        emit_signal("item_selected", item)
        emit_signal("row_selected", self)
        emit_signal("field_selected", data)


func highlight():
    set_modulate(starting_color.contrasted())


func unhighlight():
    set_modulate(starting_color)
