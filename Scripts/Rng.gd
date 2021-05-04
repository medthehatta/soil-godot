# Rng.gd

class_name Rng
extends Reference


var rng = RandomNumberGenerator.new()


func seed(value : int = -1):
    if value == -1:
        rng.randomize()
    else:
        rng.seed = hash(value)
    return rng


func choose(lst : Array):
    var length = lst.size()
    var i = rng.randi_range(0, length - 1)
    return lst[i]
