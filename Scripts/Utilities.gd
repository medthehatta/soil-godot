# Utilities.gd

extends Node


func enumerate(lst : Array):
    var result = []
    for i in range(0, lst.size() + 1):
        result.append([i, lst[i]])
    return result


func zip(lst1 : Array, lst2 : Array):
    var result = []
    var size1 = lst1.size()
    var size2 = lst2.size()
    
    var length
    if size1 <= size2:
        length = size1
    else:
        length = size2
    
    for i in range(0, length):
        result.append([lst1[i], lst2[i]])
    return result


func backend_get(path, obj, callback):
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.connect("request_completed", self, "_process_json")

    var error = http_request.request("http://localhost:8000/" + path)
    if error != OK:
        push_error("An error occurred in GET for " + path)


func _process_json(result, response_code, headers, body):
    var data = parse_json(body.get_string_from_utf8())


func dict_items(dict):
    var items = []
    for k in dict.keys():
        items.append([k, dict[k]])
    return items
