extends Control

const SLOGAN_BUTTON := preload("res://SloganButton.tscn")

var is_open := false

func _ready():
	var mob = get_mob()
	for slogan in NPC.SLOGANS:
		var slogan_button := SLOGAN_BUTTON.instance()
		slogan_button.get_node("SloganText").text = slogan
		
		var slogan_cooldown := slogan_button.get_node("Cooldown")
		slogan_cooldown.max_value = mob.get_node("ChantCooldown").wait_time
		
		$GridContainer.add_child(slogan_button)
		# warning-ignore:return_value_discarded
		slogan_button.connect("pressed", self, "on_slogan_selected", [slogan])
	
	visible = false
	mob.connect("chant_cooldown_started", self, "on_chant_cooldown_started")
	mob.connect("chant_cooldown_timeouted", self, "on_chant_cooldown_timeouted")
	set_process(false)


func _input(event):
	if event.is_action_pressed("secondary_click"):
		if is_open:
			close_popup()
		else:
			open_popup()
		get_tree().set_input_as_handled()


func _process(_delta):
	var chant_timer = get_mob().chant_cooldown
	for button in $GridContainer.get_children():
		button.get_node("Cooldown").value = chant_timer.time_left


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


func on_chant_cooldown_started():
	for button in $GridContainer.get_children():
		button.get_node("Cooldown").show()
		button.disabled = true
	
	set_process(true)


func on_chant_cooldown_timeouted():
	for button in $GridContainer.get_children():
		button.get_node("Cooldown").hide()
		button.disabled = false
	
	set_process(false)
