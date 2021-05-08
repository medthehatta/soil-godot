# State.gd


extends Node


var UNSET = "UNSETUNSETUNSETUNSETUNSETUNSETUNSET"
var EMPTY = "EMPTYEMPTYEMPTYEMPTYEMPTYEMPTYEMPTY"

var state = UNSET


func pull():
    return state


func push(value):
    state = value
    return state


func is_structured(data):
    return (
        typeof(data) == TYPE_DICTIONARY or
        typeof(data) == TYPE_ARRAY
    )


func pull_at(path, default = UNSET, data = null):
    if data == null:
        data = state

    if path.size() == 0:
        return data
    else:
        if not (is_structured(data) and data.has(path[0])):
            if default == UNSET:
                assert(false, "Could not find value at " + str(path))
            else:
                return default
        else:
            return pull_at(Utilities.rest(path), default, data[path[0]])


func as_dict(mapping, default = UNSET):
    var result = {}
    for key in mapping.keys():
        result[key] = pull_at(mapping[key], default)
    return result


func push_at(path, value, data = null):
    if data == null:
        data = state

    if path.size() == 0:
        push(value)
        return pull()
    elif path.size() == 1:
        data[path[0]] = value
        return pull()
    else:
        return push_at(Utilities.rest(path), value, data[path[0]])
