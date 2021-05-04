# Market.gd

extends Control

onready var table = $MarginContainer/MarketContainer/RichTable
onready var rng = Rng.new()
onready var backend = BackendRequestManager.new().setup(self)
onready var btn_purchase = $MarginContainer/MarketContainer/TopItems/Purchase
onready var container = $MarginContainer/MarketContainer
onready var errorLabel = $MarginContainer/MarketContainer/ErrorLabel

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


func _ready():
    ControlUtil.set_fill_parent($MarginContainer/MarketContainer)
    reload()


func _on_RichTable_item_selected(it):
    btn_purchase.set_disabled(false)


func _on_RichTable_item_unselected(it):
    btn_purchase.set_disabled(true)


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
