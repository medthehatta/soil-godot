# Market.gd

extends Control

# -- configuration

# -- signals (external)

# -- signals (internal)

signal _view_purchase_enabled
signal _view_purchase_disabled

# -- node aliases

onready var rng = Rng.new()
onready var backend = BackendRequestManager.new().setup(self)
onready var table = $MarginContainer/MarketContainer/RichTable
onready var btn_purchase = $MarginContainer/MarketContainer/TopItems/Purchase
onready var container = $MarginContainer/MarketContainer
onready var errorLabel = $MarginContainer/MarketContainer/ErrorLabel


# -- MODEL --------------------------------------------------------------------


var state = {
    "sort_field": null,
    "field_desc": true,
    "field_mapping": {},
    "entries": [],
    "purchase_enabled": false
}


# Set the configuration parameters
func configure():
    return self


# Set the initial state
func initialize(p_state : Dictionary):
    state = p_state
    return self


# Convenience method for setting the initial state, must call initialize
func setup(p_state : Dictionary):
    return initialize(p_state)


# -- SIGNAL HANDLERS ----------------------------------------------------------

# These signal handlers receive signals from the view, and should update the
# state and (optionally, but usually) emit signals telling the view to update,
# or telling external nodes that a state change has occurred.


func _on_RichTable_item_selected(it):
    state["purchase_enabled"] = true
    emit_signal("_view_purchase_enabled")


func _on_RichTable_item_unselected(it):
    state["purchase_enabled"] = false
    emit_signal("_view_purchase_disabled")


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
    ControlUtil.set_fill_parent(container)

    self.connect("_view_purchase_enabled", self, "enable_purchase_button")
    self.connect("_view_purchase_disabled", self, "disable_purchase_button")


# Render the full state
func render():
    pass


func enable_purchase_button():
    btn_purchase.set_disabled(false)


func disable_purchase_button():
    btn_purchase.set_disabled(true)




var table_row_config

var sort_field = "Offering"
var field_desc = true

var field_mapping = {
    "Offering": "gives",
    "Qual.": "quality",
    "Amt.": "quantity",
    "Wants": "wants",
    "WQua.": "want_quality",
    "WAmt.": "want_quantity",
}


func reload():
    var sort = field_mapping[sort_field]
    var url = (
        "market" +
        "?sort_column=" + str(sort) +
        "&desc=" + str(field_desc)
    )
    backend.httpget(url, "_got_data")


func _got_data(ok, data):
    errorLabel.set_text("")
    errorLabel.set_visible(false)
    if ok:
        table.clear()
        for item in data["data"]:
            var item_dict = {}
            for kv in Utilities.dict_items(field_mapping):
                item_dict[kv[0]] = item[kv[1]]
            table.add_item(item_dict)
    else:
        errorLabel.set_text("Error fetching market data")
        errorLabel.set_visible(true)


func _on_RichTable_sort_by(field):
    print("Desire sort: " + str(field))
    if field == sort_field:
        field_desc = ! field_desc
    else:
        sort_field = field
    reload()
