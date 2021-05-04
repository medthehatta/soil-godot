# HTTPRichTable.gd

extends Control

onready var table = $RichTable
onready var backend = BackendRequestManager.new().setup(self)
onready var message = $CenterContainer/Message
onready var centerContainer = $CenterContainer

var is_ready = false
var is_setup = false


var base_url
var sort_field
var field_definition
var row_height
var font
var field_mapping = {}
var field_desc = true
var config


func setup(params : Dictionary):
    base_url = params["base_url"]
    row_height = params["row_height"]
    font = params["font"]
    field_definition = params["field_definition"]
    # Sort on the first field by default
    sort_field = field_definition[0][0]
    var configData = {"fields": [], "field_widths": []}
    for def in field_definition:
        configData["fields"].append(def[0])
        configData["field_widths"].append(def[2])
        field_mapping[def[0]] = def[1]
    config = load("res://Scripts/RichTableConfig.gd").new(
        row_height,
        configData["fields"],
        configData["field_widths"]
    )
    is_setup = true
    if is_ready:
        _start()


func _ready():
    ControlUtil.set_fill_parent(centerContainer)
    is_ready = true
    if is_setup:
        _start()


func _start():
    table.row_config = config
    table._ready()
    reload()


func reload():
    var sort = field_mapping[sort_field]
    var url = (
        str(base_url) +
        "?sort_column=" + str(sort) +
        "&desc=" + str(field_desc)
    )
    backend.httpget(url, "_got_data")


func _got_data(ok, data):
    message.set_text("Loading...")
    centerContainer.set_visible(true)
    if ok:
        table.clear()
        for item in data["data"]:
            var item_dict = {}
            for kv in Utilities.dict_items(field_mapping):
                item_dict[kv[0]] = item[kv[1]]
            table.add_item(item_dict)
        centerContainer.set_visible(false)
    else:
        message.set_text("Error fetching market data")
        centerContainer.set_visible(true)


func _on_RichTable_sort_by(field):
    if field == sort_field:
        field_desc = ! field_desc
    else:
        sort_field = field
    reload()
