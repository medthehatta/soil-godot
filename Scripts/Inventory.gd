# Inventory.gd

extends Control

onready var table = $RichTable
onready var backend = BackendRequestManager.new().setup(self)

var table_row_config
var sort_field = "name"
var field_desc = false


func _ready():
    table_row_config = table.row_config
    reload()


func reload():
    var url = (
        "inventory/0" +
        "?sort_column=" + str(sort_field.to_lower()) +
        "&desc=" + str(field_desc)
    )
    backend.httpget(url, "_got_data")


func _got_data(ok, data):
    if ok:
        table.clear()
        for item in data["data"]:
            table.add_item({
                "Name": item["name"],
                "Quality": item["quality"],
                "Quantity": item["quantity"],
            })
    else:
        table.add_item({
            "Name": "Error fetching inventory data",
            "Quality": "",
            "Quantity": "",
        })


func _on_RichTable_sort_by(field):
    print("Desire sort: " + str(field))
    if field == sort_field:
        field_desc = ! field_desc
    else:
        sort_field = field
    reload()
