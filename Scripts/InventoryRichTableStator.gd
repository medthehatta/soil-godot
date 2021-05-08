# InventoryRichTableStator.gd


extends Resource


func selected():
    return State.pull_at(["inventory", "selected"], State.EMPTY)


func items():
    return State.pull_at(["inventory", "items"], State.EMPTY)



