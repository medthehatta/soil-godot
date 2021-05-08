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


# Godot slicing is bizarre in so many ways, so we wrap a common case here
func rest(arr):
    var arrlen = arr.size()
    if arrlen == 0:
        assert(false, "Cannot get rest of empty array")
    elif arrlen == 1:
        return []
    else:
        return arr.slice(1, arrlen - 1)


func dict_items(dict):
    var items = []
    for k in dict.keys():
        items.append([k, dict[k]])
    return items
