# BackendRequest.gd

class_name BackendRequest
extends Node

signal json_signal(r, data)

var req
var target


func httpget(path, obj, callback):
    _prepare(obj, callback)
    _validate(req.request(_url(path)))


func httppost(path, data, obj, callback):
    _prepare(obj, callback)
    var headers = ["Content-Type: application/json"]
    var res = req.request(
        _url(path),
        headers,
        false,
        HTTPClient.METHOD_POST,
        JSON.print(data)
    )
    _validate(res)


func _url(path):
    return "http://localhost:8000/" + path


func _prepare(obj, callback):
    req = HTTPRequest.new()
    target = obj
    target.add_child(self)
    add_child(req)
    req.connect("request_completed", self, "_process_json")
    self.connect("json_signal", obj, callback)


func _validate(result):
    if result != OK:
        emit_signal("json_signal", false, null)
        self.queue_free()


func _process_json(result, response_code, headers, body):
    if response_code == 200:
        var data = parse_json(body.get_string_from_utf8())
        emit_signal("json_signal", true, data)
    else:
        emit_signal("json_signal", false, null)
    self.queue_free()
