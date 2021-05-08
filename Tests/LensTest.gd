extends Control


func _ready():
    State.push({"a": {"b": 1, "c": 2}, "d": 3})
    print("Initial value: " + str(State.pull()))
    print("Searching for value at: " + str(["a", "c"]))
    print(State.pull_at(["a", "c"]))
    print("Setting a.b to 10")
    State.push_at(["a", "b"], 10)
    print("Final value: " + str(State.pull()))
