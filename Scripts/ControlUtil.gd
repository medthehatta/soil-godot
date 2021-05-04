# ControlUtil.gd

extends Node


func set_fill_parent(node):
    node.set_anchors_and_margins_preset(node.PRESET_WIDE)
    node.size_flags_vertical = node.SIZE_EXPAND_FILL
    node.size_flags_horizontal = node.SIZE_EXPAND_FILL

