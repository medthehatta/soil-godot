# InformedButton.gd

extends Button

signal clicked(data)

var mydata = {}
var is_ready = false


func _ready():
    connect("pressed", self, "_on_Button_pressed")
    is_ready = true


func inform(p_mydata = null):
    mydata = p_mydata
    return self


func _on_Button_pressed():
    # Don't emit any signals if we aren't ready yet
    if is_ready:
        emit_signal("clicked", mydata)
