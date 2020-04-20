extends Control
class_name HexMenu

signal selected_choice(name)

var default_color := Color.white
var highlight_color := Color.red

var open := false setget set_open
var center := Vector2.ZERO
var space_state = null
var all_polygons = []

func _ready() -> void:
	visible = false
	space_state = get_world_2d().direct_space_state
	all_polygons = [$Choice0/Polygon2D, 
					$Choice1/Polygon2D,
					$Choice2/Polygon2D,
					$Choice3/Polygon2D,
					$Choice4/Polygon2D,
					$Choice5/Polygon2D,
					$Choice6/Polygon2D]
	for pol in all_polygons: #reset others
			pol.color = default_color

func _process(_delta: float) -> void:
	self.open = Input.is_action_pressed("secondary_click")
	
	var res = space_state.intersect_point(get_global_mouse_position(),
		32, [], 524288, false, true)
	
	for pol in all_polygons: #reset others
		pol.color = default_color
	
	#highlight hovering choice
	if res.size() > 0:
		var collider = res[0].collider
		var polygon: Polygon2D = collider.get_parent().get_child(0)
		polygon.color = highlight_color


func set_open(value):
	if open == value:
		return
	open = value
	visible = value
	if open:
		center = get_global_mouse_position() - rect_size * 0.5
		rect_position = center
	else:
		# The below line is never used?
		# var angle = (center - get_global_mouse_position() ).angle()
		
		var res = space_state.intersect_point(get_global_mouse_position(),
			32, [], 524288, false, true)

		if res.size() > 0:
			var collider = res[0].collider
			var choice_name = collider.get_parent().name
			emit_signal("selected_choice", choice_name)
