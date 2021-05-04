# InventoryItem.gd

extends Control


var name_ = ""
var source = ""
var quantity = ""
var cost = ""


signal item_clicked(item)


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func set_item(item):
    return configure(
        item["name"],
        item["source"],
        item["quantity"],
        item["cost"]
    )
    

func get_item():
    return {
        "name": name_,
        "source": source,
        "quantity": quantity,
        "cost": cost,
    }


func _icon_from_name(name_):
    var maybe_icon_path = "res://" + str(name_) + ".png"
    var icon_path = (
        maybe_icon_path if File.new().file_exists(maybe_icon_path) else
        "res://Icon.png"
    )
    return load(icon_path)    


func configure(name1, source1, quantity1, cost1):
    name_ = name1
    source = source1
    quantity = quantity1
    cost = cost1
    $Control/Icon.texture = _icon_from_name(name_)
    $Control/ItemName.text = str(name_)
    $Control/Source.text = str(source)
    $Control/Quantity.text = str(quantity)
    $Control/Cost.text = str(cost)


func _on_Button_pressed():
    emit_signal("item_clicked", get_item())
