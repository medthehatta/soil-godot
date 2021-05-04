# MarketTable.gd

extends VBoxContainer


var MarketItem = preload("res://Scenes/MarketItem.tscn")
onready var listing = $MarketItemsFrame/MarketItems/MarketItemsV


func add_item(item):
    var listing = get_node("MarketItems/MarketItemsV")
    var new_item = MarketItem.instance()
    new_item.set_item(item)
    listing.add_child(new_item)
