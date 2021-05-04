# HttpUtil.gd

# Nah, this is crap

extends Node

signal json_signal(data)


func backend_get(path, obj, callback):
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.connect("request_completed", self, "_process_json")
    self.connect("json_signal", obj, callback)

    var error = http_request.request("http://localhost:8000/" + path)
    if error != OK:
        emit_signal("json_signal", error)


func _process_json(result, response_code, headers, body):
    var data = parse_json(body.get_string_from_utf8())
    emit_signal("json_signal", data)
