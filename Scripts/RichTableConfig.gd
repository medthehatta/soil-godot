# RichTableConfig.gd

extends Resource

export(int) var row_height
export(Array, String) var fields
export(Array, int) var field_widths
export(Resource) var font


func _init(p_row_height = 10, p_fields = [], p_field_widths = []):
    row_height = p_row_height
    fields = p_fields
    field_widths = p_field_widths
