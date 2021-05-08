# RichTable.gd

extends Control

# -- configuration

export(Resource) var state
var last_new = null

# -- signals (external)

signal item_selected(it)
signal item_unselected(it)
signal selection_changed(sel)
signal sort_by(field)

# -- signals (internal)

signal _scrollbar_filled
signal _item_added(it)
signal _view_item_selected(it)
signal _view_item_unselected(it)

# -- node aliases

onready var scroll = $VBoxOuter/Scroll
onready var listing = $VBoxOuter/Scroll/Listing
onready var header_row = $VBoxOuter/HeaderRow
onready var rng = Rng.new()


# -- MODEL --------------------------------------------------------------------


# Set the configuration parameters
func configure(p_state = null, p_row_config = null, p_multi_select = null):
    if p_state:
        state = p_state
    if p_row_config:
        row_config = p_row_config
    if p_multi_select:
        multi_select = p_multi_select
    return self


# -- SIGNAL HANDLERS ----------------------------------------------------------

# These signal handlers receive signals from the view, and should update the
# state and (optionally, but usually) emit signals telling the view to update,
# or telling external nodes that a state change has occurred.


func _on_row_pressed(row):
    if not (row in state["selected"]):
        # If we are not allowing multi select, we should unselect whatever else
        # is selected first
        if not multi_select and state["selected"].size() > 0:
            _unselect_one(state["selected"][0])
        _select_one(row)
    else:
        _unselect_one(row)
    emit_signal("selection_changed", get_selected())


func get_selected():
    var result = []
    for s in state["selected"]:
        result.append(s.item)
    return result


func _select_one(row):
    state["selected"].append(row)
    emit_signal("item_selected", row.item)
    emit_signal("_view_item_selected", row)


func _unselect_one(row):
    state["selected"].erase(row)
    emit_signal("item_unselected", row.item)
    emit_signal("_view_item_unselected", row)


func _on_header_field_click(data):
    var field = data
    emit_signal("sort_by", field)


func _on_scrollbar_filled():
    # The scrollcontainer is filled with dummy items so the scrollbar always
    # displays.  Once it's filled, we need to reset the "last_new" element,
    # otherwise we will add elements to the end, after the dummy items.
    last_new = null


func _on_item_added(new_item):
    last_new = new_item


# -- VIEW ---------------------------------------------------------------------

# These "view" functions should only read the state, not write to it.  Instead,
# they should just emit internal signals, which will be handled by a signal
# handler.


# Initialize the view
#
# We don't just inline view_init() into _ready() in case we need to validate
# the state before running view_init().
#
func _ready():
    return view_init()


# Initialize the view
func view_init():
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

    self.connect("_item_added", self, "_on_item_added")
    self.connect("_scrollbar_filled", self, "_on_scrollbar_filled")
    self.connect("_view_item_selected", self, "highlight_selected")
    self.connect("_view_item_unselected", self, "unhighlight_selected")


# Render the full state
func render():
    clear()
    fill_to_make_scrollbar()
    for item in state["items"]:
        add_item(item)


# Highlight a selected row
func highlight_selected(row):
    row.highlight()


# Unhighlight a selected row
func unhighlight_selected(row):
    row.unhighlight()


func fill_to_make_scrollbar():
    # Add a bunch of dummy values so the scrollbar actually appears
    var items_per_page = int(listing.get_rect().size.y / row_config.row_height)
    for _x in range(0, items_per_page):
        add_item({})
    emit_signal("_scrollbar_filled")


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

    emit_signal("_item_added", new_item)


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
