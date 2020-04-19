extends Control

const SLOGAN_BUTTON := preload("res://SloganButton.tscn")

var is_open := false

func _ready():
	for slogan in NPC.SLOGANS:
		var slogan_button := SLOGAN_BUTTON.instance()
		slogan_button.get_node("SloganText").text = slogan
		$GridContainer.add_child(slogan_button)
		# warning-ignore:return_value_discarded
		slogan_button.connect("pressed", self, "on_slogan_selected", [slogan])
	
	visible = false


func _input(event):
	if event.is_action_pressed("secondary_click"):
		if is_open:
			close_popup()
		else:
			open_popup()
		get_tree().set_input_as_handled()


func get_mob():
	return $"../../Mob"


func open_popup():
	is_open = true
	visible = true
	rect_position = get_global_mouse_position() - rect_size * 0.5


func close_popup():
	is_open = false
	visible = false


func on_slogan_selected(slogan):
	get_mob().chant(slogan)
	close_popup()
