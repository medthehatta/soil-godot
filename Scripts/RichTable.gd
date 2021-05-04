# RichTable.gd

extends Control

export(Resource) var row_config
export(bool) var multi_select

signal item_selected(it)
signal item_unselected(it)
signal selection_changed(sel)
signal sort_by(field)

onready var scroll = $VBoxOuter/Scroll
onready var listing = $VBoxOuter/Scroll/Listing
onready var header_row = $VBoxOuter/HeaderRow
onready var rng = Rng.new()

var last_new = null
var selected = []


func _ready():
    ControlUtil.set_fill_parent($VBoxOuter)
    ControlUtil.set_fill_parent(scroll)
    ControlUtil.set_fill_parent(listing)

    var header = make_header()
    header_row.add_child(header)

    fill_to_make_scrollbar()

    # Add a margin to the header row to compensate for it not having a
    # scrollbar
    var scroll_width = scroll.get_v_scrollbar().get_rect().size.x
    header_row.add_constant_override("margin_right", scroll_width)

    self.connect("selection_changed", self, "_on_selection_changed")


func fill_to_make_scrollbar():
    # Add a bunch of dummy values so the scrollbar actually appears
    var items_per_page = int(listing.get_rect().size.y / row_config.row_height)
    for _x in range(0, items_per_page):
        add_item({})
    # We have to reset last_new, or we will add the actual elements _after_ the
    # empty ones
    last_new = null


func add_item(item : Dictionary):
    var new_item

    if item:
        new_item = make_item(item)
    else:
        new_item = make_empty_row()

    if last_new == null:
        listing.add_child(new_item)
        listing.move_child(new_item, 0)
    else:
        listing.add_child_below_node(last_new, new_item)

    new_item.connect("row_selected", self, "_on_row_pressed")

    last_new = new_item


func clear():
    for child in listing.get_children():
        child.queue_free()


func make_header():
    var header_dict = {}
    for field in row_config.fields:
        header_dict[field] = field
    var header = make_item(header_dict)
    header.connect("field_selected", self, "_on_header_field_click")
    return header


func make_item(item : Dictionary):
    var row = preload("res://Scenes/ClickableHBoxContainer.tscn").instance()
    return row.setup(row_config, item)


func make_empty_row():
    var row = preload("res://Scenes/ClickableHBoxContainer.tscn").instance()
    return row.setup(row_config)


func _on_row_pressed(row):
    if not (row in selected):
        # If we are not allowing multi select, we should unselect whatever else
        # is selected first
        if not multi_select and selected.size() > 0:
            _unselect_one(selected[0])
        _select_one(row)
    else:
        _unselect_one(row)
    emit_signal("selection_changed", get_selected())


func _select_one(row):
    selected.append(row)
    row.highlight()
    emit_signal("item_selected", row.item)


func _unselect_one(row):
    selected.erase(row)
    row.unhighlight()
    emit_signal("item_unselected", row.item)


func get_selected():
    var result = []
    for s in selected:
        result.append(s.item)
    return result


func _on_selection_changed(sel):
    print(str(sel))


func _on_header_field_click(data):
    var field = data
    emit_signal("sort_by", field)
