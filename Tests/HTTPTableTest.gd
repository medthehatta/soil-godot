extends Control


var table


func _ready():
    table = preload("res://Scenes/HTTPRichTable.tscn").instance()
    table.setup({
        "base_url": "market",
        "row_height": 40,
        "font": load("res://Fonts/Roboto-18.tres"),
        "field_definition": [
            ["Offering", "gives", -1],
            ["Qual.", "quality", 60],
            ["Amt.", "quantity", 60],
            ["Wants", "wants", -1],
            ["WQual.", "want_quality", 60],
            ["WAmt.", "want_quantity", 60]
        ]
    })

    add_child(table)
