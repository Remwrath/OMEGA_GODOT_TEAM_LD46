extends HexMenu

# Set this to the height of the CooldownProgress inside each Choice
const PROGRESS_CONTROL_HEIGHT := 37

var is_cooling_down

func _ready():
	var mob = get_mob()
	
	# Hide every choice. We'll show only the one's that got assigned with a slogan
	for choice in get_children():
		choice.hide()
	
	var child_index := 0
	for slogan in NPC.SLOGANS:
		var choice = get_child(child_index)
		choice.get_node("Label").text = slogan
		choice.show()
		child_index += 1
	
	mob.connect("chant_cooldown_started", self, "on_chant_cooldown_started")
	mob.connect("chant_cooldown_timeouted", self, "on_chant_cooldown_timeouted")
	

func _process(_delta):
	# Update the CooldownProgress 
	if is_cooling_down:
		var chant_timer = get_mob().chant_cooldown
		for choice in get_children():
			var cooldown_progress = choice.get_node("CooldownProgress")
			# The progress works by resizing the height of the Progress itself
			cooldown_progress.rect_size = Vector2(cooldown_progress.rect_size.x, PROGRESS_CONTROL_HEIGHT * chant_timer.time_left / chant_timer.wait_time)


func get_mob():
	return $"../Mob"

# This gets connected to the HexMenu's selected_choice siganl
func on_choice_selected(choice):
	# Chant when not cooling down
	if !is_cooling_down:
		get_mob().chant(get_node(choice + "/Label").text)


func on_chant_cooldown_started():
	for choice in get_children():
		choice.get_node("CooldownProgress").show()
		is_cooling_down = true



func on_chant_cooldown_timeouted():
	for choice in get_children():
		choice.get_node("CooldownProgress").hide()
		is_cooling_down = false
